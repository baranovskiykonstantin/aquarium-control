#include <QBluetoothUuid>
#include <QBluetoothAddress>
#include <QBluetoothServiceInfo>
#include <QCoreApplication>
#include <QMetaEnum>
#include <QPermission>

#ifdef Q_OS_ANDROID
#  include <QJniObject>
#endif

#include "bt_rfcomm.h"

namespace {
constexpr auto kSppUuid = "00001101-0000-1000-8000-00805F9B34FB";
}

BTRfcomm::BTRfcomm(QObject *parent) :
    QObject(parent),
    m_socket(new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol, this))
{
    connect(m_socket, &QBluetoothSocket::readyRead,
            this, &BTRfcomm::onSocketReadyRead);
    connect(m_socket, &QBluetoothSocket::connected,
            this, &BTRfcomm::onSocketConnected);
    connect(m_socket, &QBluetoothSocket::disconnected,
            this, &BTRfcomm::onSocketDisconnected);
    connect(m_socket, &QBluetoothSocket::errorOccurred,
            this, &BTRfcomm::onSocketError);
}

BTRfcomm::~BTRfcomm() = default;

void BTRfcomm::emitPermissionDenied(const char *deniedErrorSignal)
{
    if (qstrcmp(deniedErrorSignal, "discovery") == 0) {
        emit discoveryError(QStringLiteral("MissingPermissionsError"));
    } else {
        emit connectionError(QStringLiteral("MissingPermissionsError"));
    }
}

bool BTRfcomm::ensureBluetoothPermission(PermissionCallback onGranted, const char *deniedErrorSignal)
{
    QBluetoothPermission permission;
    permission.setCommunicationModes(QBluetoothPermission::Access);

    const auto status = qApp->checkPermission(permission);
    if (status == Qt::PermissionStatus::Granted) {
        return true;
    }

    if (status == Qt::PermissionStatus::Denied) {
        emitPermissionDenied(deniedErrorSignal);
        return false;
    }

    qApp->requestPermission(permission, this,
                            [this, onGranted, deniedErrorSignal](const QPermission &result) {
        if (result.status() != Qt::PermissionStatus::Granted) {
            emitPermissionDenied(deniedErrorSignal);
            return;
        }
        (this->*onGranted)();
    });
    return false;
}

void BTRfcomm::startDiscovery()
{
    if (!ensureBluetoothPermission(&BTRfcomm::doStartDiscovery, "discovery")) {
        return;
    }
    doStartDiscovery();
}

void BTRfcomm::doStartDiscovery()
{
    if (m_discoveryAgent) {
        m_discoveryAgent->stop();
        m_discoveryAgent->deleteLater();
        m_discoveryAgent = nullptr;
    }

    m_foundAddresses.clear();

    // Android Classic SDP is unreliable (esp. for already-paired SPP modules).
    // Enumerate bonded devices first, then run Classic inquiry.
    emitBondedDevices();

    m_discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    connect(m_discoveryAgent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered,
            this, &BTRfcomm::onDeviceDiscovered);
    connect(m_discoveryAgent, &QBluetoothDeviceDiscoveryAgent::finished,
            this, &BTRfcomm::onDeviceDiscoveryFinished);
    connect(m_discoveryAgent, &QBluetoothDeviceDiscoveryAgent::errorOccurred,
            this, &BTRfcomm::onDeviceDiscoveryError);

    m_discoveryRunning = true;
    emit discoveringChanged();

    const auto methods = QBluetoothDeviceDiscoveryAgent::ClassicMethod;
    if (QBluetoothDeviceDiscoveryAgent::supportedDiscoveryMethods().testFlag(methods)) {
        m_discoveryAgent->start(methods);
    } else {
        m_discoveryAgent->start();
    }
}

void BTRfcomm::emitBondedDevices()
{
#ifdef Q_OS_ANDROID
    const QJniObject adapter = QJniObject::callStaticObjectMethod(
        "android/bluetooth/BluetoothAdapter",
        "getDefaultAdapter",
        "()Landroid/bluetooth/BluetoothAdapter;");
    if (!adapter.isValid()) {
        return;
    }

    const QJniObject bondedSet = adapter.callObjectMethod(
        "getBondedDevices", "()Ljava/util/Set;");
    if (!bondedSet.isValid()) {
        return;
    }

    const QJniObject iterator = bondedSet.callObjectMethod(
        "iterator", "()Ljava/util/Iterator;");
    if (!iterator.isValid()) {
        return;
    }

    while (iterator.callMethod<jboolean>("hasNext", "()Z")) {
        const QJniObject device = iterator.callObjectMethod(
            "next", "()Ljava/lang/Object;");
        if (!device.isValid()) {
            continue;
        }

        const QString name = device.callObjectMethod(
            "getName", "()Ljava/lang/String;").toString();
        const QString address = device.callObjectMethod(
            "getAddress", "()Ljava/lang/String;").toString();
        emitDiscoveredUnique(name, address);
    }
#endif
}

void BTRfcomm::emitDiscoveredUnique(const QString &name, const QString &address)
{
    if (address.isEmpty() || m_foundAddresses.contains(address)) {
        return;
    }
    m_foundAddresses.insert(address);
    emit discovered(name, address);
}

void BTRfcomm::stopDiscovery()
{
    if (m_discoveryAgent && m_discoveryRunning) {
        m_discoveryAgent->stop();
        m_discoveryRunning = false;
        emit discoveringChanged();
    }
}

void BTRfcomm::onDeviceDiscovered(const QBluetoothDeviceInfo &info)
{
    if (!info.isValid()) {
        return;
    }
    emitDiscoveredUnique(info.name(), info.address().toString());
}

void BTRfcomm::onDeviceDiscoveryFinished()
{
    if (!m_discoveryRunning) {
        return;
    }
    m_discoveryRunning = false;
    emit discoveringChanged();
    emit discoveryFinished();
}

void BTRfcomm::onDeviceDiscoveryError(QBluetoothDeviceDiscoveryAgent::Error errorType)
{
    const QMetaEnum metaEnum = QMetaEnum::fromType<QBluetoothDeviceDiscoveryAgent::Error>();
    const QString errorString = QString::fromLatin1(metaEnum.valueToKey(static_cast<int>(errorType)));

    m_discoveryRunning = false;
    emit discoveringChanged();
    emit discoveryError(errorString);
}

bool BTRfcomm::getDiscoveryStatus() const
{
    return m_discoveryRunning;
}

void BTRfcomm::connectDevice(QString address)
{
    m_pendingAddress = std::move(address);
    if (!ensureBluetoothPermission(&BTRfcomm::doConnectDevice, "connection")) {
        return;
    }
    doConnectDevice();
}

void BTRfcomm::doConnectDevice()
{
    stopDiscovery();
    m_socket->connectToService(
        QBluetoothAddress(m_pendingAddress),
        QBluetoothUuid(QString::fromLatin1(kSppUuid))
    );
}

void BTRfcomm::disconnectDevice()
{
    m_socket->disconnectFromService();
}

void BTRfcomm::onSocketConnected()
{
    emit connected(m_socket->peerAddress().toString());
}

void BTRfcomm::onSocketDisconnected()
{
    emit disconnected();
}

void BTRfcomm::onSocketError(QBluetoothSocket::SocketError errorType)
{
    const QMetaEnum metaEnum = QMetaEnum::fromType<QBluetoothSocket::SocketError>();
    const QString errorString = QString::fromLatin1(metaEnum.valueToKey(static_cast<int>(errorType)));

    emit connectionError(errorString);
}

void BTRfcomm::onSocketReadyRead()
{
    const QByteArray data = m_socket->readAll();
    m_data += QString::fromUtf8(data.constData(), data.size());
    while (m_data.contains(QLatin1String("\r\n"))) {
        const int lineEndIndex = m_data.indexOf(QLatin1String("\r\n"));
        const QString line = m_data.left(lineEndIndex);
        m_data.remove(0, lineEndIndex + 2);

        emit lineReceived(line);
    }
}

void BTRfcomm::sendLine(QString line)
{
    if (m_socket->state() == QBluetoothSocket::SocketState::ConnectedState) {
        const QByteArray text = line.toUtf8() + '\r';
        m_socket->write(text);
    }
}
