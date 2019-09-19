#include <QtCore/qmetaobject.h>
#include <QSerialPortInfo>

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
    connect(m_serialport, SIGNAL(errorOccurred(QSerialPort::SerialPortError)),
            this, SLOT(onPortError(QSerialPort::SerialPortError)));
    connect(m_serialport, SIGNAL(readyRead()),
            this, SLOT(onPortReadyRead()));
}

SerialPort::~SerialPort()
{
    delete m_serialport;
}

void SerialPort::onPortError(QSerialPort::SerialPortError errorType)
{
    QMetaEnum metaEnum = QMetaEnum::fromType<QSerialPort::SerialPortError>();
    QString errorString = metaEnum.valueToKey(errorType);

    emit portError(errorString);
}

void SerialPort::searchPorts()
{
    foreach (const QSerialPortInfo &serialPortInfo, QSerialPortInfo::availablePorts())
    {
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
    if (m_serialport->isOpen())
    {
        m_serialport->close();
    }
}

void SerialPort::onPortReadyRead()
{
    QByteArray data = m_serialport->readAll();
    m_data += QString::fromUtf8(data.constData());
    while (m_data.contains("\r\n"))
    {
        int lineEndIndex = m_data.indexOf("\r\n");
        QString line = m_data.left(lineEndIndex);
        m_data.remove(0, lineEndIndex + 2);
        emit lineReceived(line);
    }
}

void SerialPort::sendLine(QString line)
{
    if (m_serialport->isOpen())
    {
        m_data = QString();
        QByteArray text = line.toUtf8() + '\r';
        m_serialport->write(text);
    }
}
