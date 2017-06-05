#include <QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QDebug>
#include <QBluetoothLocalDevice>
#include <QTranslator>
#include <QScreen>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QTranslator qtTranslator;
    qtTranslator.load(QLocale(), "lang", "_", ":/translations");
    app.installTranslator(&qtTranslator);

    QList<QBluetoothHostInfo> infos = QBluetoothLocalDevice::allDevices();
    if (infos.isEmpty())
        qWarning() << "Missing Bluetooth local device. "
                      "Application will not work properly.";
    QQuickView view;
    view.setTitle("Aquarium control");
    view.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    // Qt.quit() called in embedded .qml by default only emits
    // quit() signal, so do this (optionally use Qt.exit()).
    QObject::connect(view.engine(), SIGNAL(quit()), qApp, SLOT(quit()));
    QSize screenSize = app.primaryScreen()->size();
    int width = 640;
    int height = 480;
    int posX = (screenSize.width() - width) / 2;
    int posY = (screenSize.height() - height) / 2;
    view.setGeometry(QRect(posX, posY, width, height));
    view.show();
    return app.exec();
}
