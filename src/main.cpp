#include <QApplication>
#include <QQmlApplicationEngine>
#include "mygame.h"
#include <QQmlContext>
#include <QIcon>

int main(int argc, char *argv[])
{
    QApplication::setDesktopSettingsAware(false);
    QApplication::setAttribute(Qt::AA_Use96Dpi);
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon("://app_icon.ico"));
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    QObject *root = engine.rootObjects()[0];
    MyGame w(root);
    engine.rootContext()->setContextProperty("_my_game", &w);


    return app.exec();
}
