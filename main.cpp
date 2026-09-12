#include <QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QTranslator>
#include <QScreen>
#include <QLocale>

#include "bt_rfcomm.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName(QStringLiteral("baranovskiykonstantin"));
    app.setApplicationName(QStringLiteral("aquarium-control"));
    app.setApplicationVersion(QString::fromUtf8(APP_VERSION));

    QTranslator qtTranslator;
    if (qtTranslator.load(QLocale(), QStringLiteral("lang"), QStringLiteral("_"),
                          QStringLiteral(":/translations"))) {
        app.installTranslator(&qtTranslator);
    }

    qmlRegisterType<BTRfcomm>("BTRfcomm", 1, 0, "BTRfcomm");

    QQuickView view;
    view.setTitle(QStringLiteral("Aquarium control"));
    view.setSource(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    QObject::connect(view.engine(), &QQmlEngine::quit, &app, &QGuiApplication::quit);
#ifndef Q_OS_ANDROID
    const QSize screenSize = app.primaryScreen()->size();
    constexpr int width = 640;
    constexpr int height = 480;
    const int posX = (screenSize.width() - width) / 2;
    const int posY = (screenSize.height() - height) / 2;
    view.setGeometry(QRect(posX, posY, width, height));
#endif
    view.show();
    return app.exec();
}
