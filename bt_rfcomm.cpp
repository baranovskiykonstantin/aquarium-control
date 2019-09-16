#include <QBluetoothUuid>
#include <QtCore/qmetaobject.h>
#include <QBluetoothDeviceInfo>
#include <QBluetoothAddress>

#include "bt_rfcomm.h"

BTRfcomm::BTRfcomm(QObject *parent) : QObject(parent)
{
    m_data = QString();
    m_discoveryAgent = new QBluetoothServiceDiscoveryAgent(this);
    m_discoveryAgent->setUuidFilter(QBluetoothUuid(QString("00001101-0000-1000-8000-00805F9B34FB")));
    connect(m_discoveryAgent, SIGNAL(serviceDiscovered(QBluetoothServiceInfo)),
            this, SLOT(onServiceDiscovered(QBluetoothServiceInfo)));
    connect(m_discoveryAgent, SIGNAL(finished()),
            this, SLOT(onServiceDiscoveryFinished()));
    connect(m_discoveryAgent, SIGNAL(error(QBluetoothServiceDiscoveryAgent::Error)),
            this, SLOT(onServiceDiscoveryError(QBluetoothServiceDiscoveryAgent::Error)));


    m_socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol, this);
    connect(m_socket, SIGNAL(readyRead()),
            this, SLOT(onReadyRead()));
    connect(m_socket, SIGNAL(connected()),
            this, SLOT(onSocketConnected()));
    connect(m_socket, SIGNAL(disconnected()),
            this, SLOT(onSocketDisconnected()));
    connect(m_socket, SIGNAL(error(QBluetoothSocket::SocketError)),
            this, SLOT(onSocketError(QBluetoothSocket::SocketError)));

    m_service = new QBluetoothServiceInfo();
    m_service->setServiceUuid(QBluetoothUuid(QString("00001101-0000-1000-8000-00805F9B34FB")));
}

BTRfcomm::~BTRfcomm()
{
    m_discoveryAgent->stop();
    m_socket->disconnectFromService();
}

void BTRfcomm::startDiscovery()
{
    m_discoveryAgent->start();
}

void BTRfcomm::stopDiscovery()
{
    m_discoveryAgent->stop();
}

void BTRfcomm::onServiceDiscovered(const QBluetoothServiceInfo &service)
{
    emit discovered(service.device().name(),
                    service.device().address().toString());
}

void BTRfcomm::onServiceDiscoveryFinished()
{
    emit discoveryFinished();
}

void BTRfcomm::onServiceDiscoveryError(QBluetoothServiceDiscoveryAgent::Error errorType)
{
    QMetaEnum metaEnum = QMetaEnum::fromType<QBluetoothServiceDiscoveryAgent::Error>();
    QString errorString = metaEnum.valueToKey(errorType);

    emit discoveryError(errorString);
}

bool BTRfcomm::getServiceDiscoveryStatus()
{
    return m_discoveryAgent->isActive();
}

void BTRfcomm::connectDevice(QString address)
{
    m_socket->disconnectFromService();
    QBluetoothDeviceInfo device(QBluetoothAddress(address), QString(), 0);
    m_service->setDevice(device);
    m_socket->connectToService(*m_service);
}

void BTRfcomm::disconnectDevice()
{
    m_socket->disconnectFromService();
}

void BTRfcomm::onSocketConnected()
{
    emit connected(m_service->device().address().toString());
}

void BTRfcomm::onSocketDisconnected()
{
    emit disconnected();
}

void BTRfcomm::onSocketError(QBluetoothSocket::SocketError errorType)
{
    QMetaEnum metaEnum = QMetaEnum::fromType<QBluetoothSocket::SocketError>();
    QString errorString = metaEnum.valueToKey(errorType);

    emit connectionError(errorString);
}

void BTRfcomm::onReadyRead()
{
/*  readLine() does not work as expected.
    while (m_socket->canReadLine())
    {
        QByteArray line = m_socket->readLine();
        emit lineReceived(QString::fromUtf8(line.constData(), line.length()));
    }
*/
    QByteArray data = m_socket->readAll();
    m_data += QString::fromUtf8(data.constData());
    while (m_data.contains("\r\n"))
    {
        int lineEndIndex = m_data.indexOf("\r\n");
        QString line = m_data.left(lineEndIndex);
        m_data.remove(0, lineEndIndex + 2);
        emit lineReceived(line);
    }
}

void BTRfcomm::sendLine(QString line)
{
    if (m_socket->state() == QBluetoothSocket::ConnectedState)
    {
        m_data = QString();
        QByteArray text = line.toUtf8() + '\r';
        m_socket->write(text);
    }
}