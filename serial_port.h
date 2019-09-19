#ifndef SERIAL_PORT_H
#define SERIAL_PORT_H

#include <QObject>
#include <QString>
#include <QSerialPort>

class SerialPort : public QObject
{
    Q_OBJECT

public:
    explicit SerialPort(QObject *parent = nullptr);
    ~SerialPort();

    Q_INVOKABLE void searchPorts();

    Q_INVOKABLE void openPort(QString name);
    Q_INVOKABLE void closePort();

    Q_INVOKABLE void sendLine(QString line);

signals:
    void portFound(QString name);
    void portError(QString error);

    void lineReceived(QString line);

private slots:
    void onPortError(QSerialPort::SerialPortError errorType);
    void onPortReadyRead();

private:
    QSerialPort *m_serialport;
    QString m_data;
};

#endif // SERIAL_PORT_H
