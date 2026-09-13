#include <QtCore/qmetaobject.h>
#include <QSerialPortInfo>
#include <QIODevice>

#include "serial_port.h"

SerialPort::SerialPort(QObject *parent) :
    QObject(parent),
    m_serialport(new QSerialPort(this)),
    m_data()
{
    m_serialport->setDataBits(QSerialPort::Data8);
    m_serialport->setStopBits(QSerialPort::OneStop);
    m_serialport->setParity(QSerialPort::NoParity);
    m_serialport->setFlowControl(QSerialPort::NoFlowControl);
    connect(m_serialport, &QSerialPort::errorOccurred,
            this, &SerialPort::onPortError);
    connect(m_serialport, &QSerialPort::readyRead,
            this, &SerialPort::onPortReadyRead);
}

SerialPort::~SerialPort() = default;

void SerialPort::onPortError(QSerialPort::SerialPortError errorType)
{
    const QMetaEnum metaEnum = QMetaEnum::fromType<QSerialPort::SerialPortError>();
    const QString errorString = QString::fromUtf8(metaEnum.valueToKey(errorType));

    emit portError(errorString);
}

void SerialPort::searchPorts()
{
    const auto ports = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &serialPortInfo : ports) {
        emit portFound(serialPortInfo.portName());
    }
}

void SerialPort::openPort(QString name)
{
    m_serialport->setPortName(name);
    m_serialport->open(QIODevice::ReadWrite);
}

void SerialPort::closePort()
{
    if (m_serialport->isOpen()) {
        m_serialport->close();
    }
}

void SerialPort::onPortReadyRead()
{
    const QByteArray data = m_serialport->readAll();
    m_data += QString::fromUtf8(data.constData());
    while (m_data.contains(QLatin1String("\r\n"))) {
        const int lineEndIndex = m_data.indexOf(QLatin1String("\r\n"));
        const QString line = m_data.left(lineEndIndex);
        m_data.remove(0, lineEndIndex + 2);
        emit lineReceived(line);
    }
}

void SerialPort::sendLine(QString line)
{
    if (m_serialport->isOpen()) {
        m_data = QString();
        const QByteArray text = line.toUtf8() + '\r';
        m_serialport->write(text);
    }
}
