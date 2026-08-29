#ifndef BT_RFCOMM_H
#define BT_RFCOMM_H

#include <QObject>
#include <QString>
#include <QSet>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QBluetoothSocket>
#include <QBluetoothPermission>

class BTRfcomm : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isDiscovering READ getDiscoveryStatus NOTIFY discoveringChanged)

public:
    explicit BTRfcomm(QObject *parent = nullptr);
    ~BTRfcomm() override;

    Q_INVOKABLE void startDiscovery();
    Q_INVOKABLE void stopDiscovery();

    Q_INVOKABLE void connectDevice(QString address);
    Q_INVOKABLE void disconnectDevice();

    Q_INVOKABLE void sendLine(QString line);

signals:
    void discovered(QString name, QString address);
    void discoveryFinished();
    void discoveryError(QString error);
    void discoveringChanged();

    void connected(QString deviceAddress);
    void disconnected();
    void connectionError(QString error);

    void lineReceived(QString line);

private slots:
    void onDeviceDiscovered(const QBluetoothDeviceInfo &info);
    void onDeviceDiscoveryFinished();
    void onDeviceDiscoveryError(QBluetoothDeviceDiscoveryAgent::Error error);

    void onSocketReadyRead();
    void onSocketConnected();
    void onSocketDisconnected();
    void onSocketError(QBluetoothSocket::SocketError error);

private:
    using PermissionCallback = void (BTRfcomm::*)();

    bool ensureBluetoothPermission(PermissionCallback onGranted, const char *deniedErrorSignal);
    void doStartDiscovery();
    void doConnectDevice();
    void emitPermissionDenied(const char *deniedErrorSignal);
    void emitBondedDevices();
    void emitDiscoveredUnique(const QString &name, const QString &address);

    bool getDiscoveryStatus() const;

    QBluetoothDeviceDiscoveryAgent *m_discoveryAgent = nullptr;
    QBluetoothSocket *m_socket = nullptr;
    QString m_data;
    QString m_pendingAddress;
    QSet<QString> m_foundAddresses;
    bool m_discoveryRunning = false;
};

#endif // BT_RFCOMM_H
