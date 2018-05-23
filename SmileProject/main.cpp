#include <QApplication>
#include "mainwindowagent.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    MainWindowAgent::getInstance()->initialize();
    return app.exec();
}
