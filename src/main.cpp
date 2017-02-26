#include <QApplication>
#include <QQuickView>

#include "GSEmulator.h"
#include "EmulationRunner.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    qmlRegisterType<GSEmulator>("GearSystem", 1, 0, "GearSystemEmulator");

    QQuickView view;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl("qrc:///main.qml"));
    view.show();

    int result = app.exec();

    EmulationRunner::waitAll();

    return result;
}
