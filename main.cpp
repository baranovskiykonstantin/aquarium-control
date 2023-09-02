#include <QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
//#include <QLoggingCategory>
#include <QTranslator>
#include <QScreen>

#include "serial_port.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("baranovskiykonstantin");

    QTranslator qtTranslator;
    qtTranslator.load(QLocale(), "lang", "_", ":/translations");
    app.installTranslator(&qtTranslator);

    qmlRegisterType<SerialPort>("SerialPort", 1, 0, "SerialPort");

//    QLoggingCategory::setFilterRules(QStringLiteral("qt.bluetooth* = true"));

    QQuickView view;
    view.setTitle("Aquarium control");
    view.setSource(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    QObject::connect(view.engine(), SIGNAL(quit()), qApp, SLOT(quit()));
#ifndef Q_OS_ANDROID
    QSize screenSize = app.primaryScreen()->size();
    int width = 640;
    int height = 480;
    int posX = (screenSize.width() - width) / 2;
    int posY = (screenSize.height() - height) / 2;
    view.setGeometry(QRect(posX, posY, width, height));
#endif
    view.show();
    return app.exec();
}
