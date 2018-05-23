TEMPLATE = app

QT += qml quick widgets widgets multimedia multimediawidgets
CONFIG += c++11

INCLUDEPATH += ./inc \
               ./src

HEADERS += \
    inc/camera.h \
    inc/imagesettings.h \
    inc/MainWindowAgent.h \
    inc/videosettings.h

SOURCES += \
    src/camera.cpp \
    src/imagesettings.cpp \
    src/MainWindowAgent.cpp \
    src/videosettings.cpp \
    main.cpp

RESOURCES += qml.qrc \
    image.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES +=
