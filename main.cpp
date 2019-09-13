#include <QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
//#include <QLoggingCategory>
#include <QTranslator>
#include <QScreen>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("baranovskiykonstantin");

    QTranslator qtTranslator;
    qtTranslator.load(QLocale(), "lang", "_", ":/translations");
    app.installTranslator(&qtTranslator);

//    QLoggingCategory::setFilterRules(QStringLiteral("qt.bluetooth* = true"));
/*
    QLoggingCategory::setFilterRules(QStringLiteral("* = true\n"
                                                    "qt.quick* = false\n"
                                                    "qt.qml* = false\n"
                                                    "qt.qpa* = false\n"
                                                    "qt.opengl* = false\n"
                                                    "qt.v4* = false\n"
                                                    "qt.scenegraph* = false"));
*/
    QQuickView view;
    view.setTitle("Aquarium control");
    view.setSource(QUrl(QStringLiteral("qrc:/qml/Main.qml")));
    view.setResizeMode(QQuickView::SizeRootObjectToView);
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
