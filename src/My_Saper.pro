TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp \
    mygame.cpp

RESOURCES += qml.qrc \
    rc.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    mygame.h

DISTFILES += \
    myapp.rc

#win32: RC_FILE = myapp.rc
