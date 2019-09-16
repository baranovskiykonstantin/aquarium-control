#ifndef BT_RFCOMM_H
#define BT_RFCOMM_H

#include <QObject>
#include <QString>
#include <QBluetoothServiceInfo>
#include <QBluetoothServiceDiscoveryAgent>
#include <QBluetoothSocket>

class BTRfcomm : public QObject
{
    Q_OBJECT

public:
    explicit BTRfcomm(QObject *parent = nullptr);
    ~BTRfcomm();

    Q_INVOKABLE void startDiscovery();
    Q_INVOKABLE void stopDiscovery();
    Q_PROPERTY(bool isDiscovering READ getServiceDiscoveryStatus)

    Q_INVOKABLE void connectDevice(QString address);
    Q_INVOKABLE void disconnectDevice();

    Q_INVOKABLE void sendLine(QString line);

signals:
    void discovered(QString name, QString address);
    void discoveryFinished();
    void discoveryError(QString error);

    void connected(QString deviceAddress);
    void disconnected();
    void connectionError(QString error);

    void lineReceived(QString line);

private slots:
    void onServiceDiscovered(const QBluetoothServiceInfo &service);
    void onServiceDiscoveryFinished();
    void onServiceDiscoveryError(QBluetoothServiceDiscoveryAgent::Error error);

    void onReadyRead();
    void onSocketConnected();
    void onSocketDisconnected();
    void onSocketError(QBluetoothSocket::SocketError);

private:
    QBluetoothServiceDiscoveryAgent *m_discoveryAgent;
    QBluetoothSocket *m_socket;
    QBluetoothServiceInfo *m_service;
    QString m_data;

    bool getServiceDiscoveryStatus();
};

#endif // BT_RFCOMM_H
