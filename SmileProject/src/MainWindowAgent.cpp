#include "MainWindowAgent.h"
#include <QMediaService>

#include "camera.h"

#include <QtWidgets>
#define LOCAL_INVOKE(PROPERTY, VALUE) \
    m_qmlEngine.rootObjects().at(0)->setProperty(PROPERTY, VALUE);

#define SETPROPERTY(OBJECT, PROPERTY, VALUE) {QList<QObject*> _uiObjects = m_widget->findChildren<QObject*>(OBJECT); \
                                                if (m_widget->objectName() == OBJECT) m_widget->setProperty(PROPERTY, VALUE); \
                                                foreach (QObject* _uiObject, _uiObjects) {\
                                                    if (_uiObject) _uiObject->setProperty(PROPERTY, VALUE);}}
#define DEL_POINTER(p) if(p){ delete p; p = nullptr; }

MainWindowAgent* MainWindowAgent::_instance = NULL;

MainWindowAgent::MainWindowAgent() {
    m_camera = nullptr;
}

MainWindowAgent::~MainWindowAgent() {
    DEL_POINTER(m_camera);
}

MainWindowAgent* MainWindowAgent::getInstance() {
    if (!_instance) {
        _instance = new MainWindowAgent();
    }
    return _instance;
}
QQmlApplicationEngine* MainWindowAgent::getAppEngine() {
    return &m_qmlEngine;
}
void MainWindowAgent::initialize() {
    m_qmlEngine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    QQmlContext *context = m_qmlEngine.rootContext();
    context->setContextProperty("_mainWindow", MainWindowAgent::getInstance());

    m_mainObj = m_qmlEngine.rootObjects().at(0);
    m_appContainer = m_mainObj->findChild<QQuickItem *>("app_container");
    createScreen(ID_VIEW_CAMERA);
}

void MainWindowAgent::handleEvent(QString evg) {
#define START(str) if (evg.startsWith(str)) {
#define CASE(str) } else if (evg.startsWith(str)) {
#define END }
    QString param = "";
    START("Open")
        handleOpenImage();
    CASE("Analyze")
        createScreen(ID_VIEW_INFO);
    END
}

void MainWindowAgent::handleOpenImage() {
    QVariant var;
    QMetaObject::invokeMethod(m_mainObj, "getFileUrl", Q_RETURN_ARG(QVariant, var));
    QString directory = var.toString();
    qDebug() << "handleOpenImage openned:"  + directory;
    createScreen(ID_VIEW_IMAGE);
    SETPROPERTY("chosenImage", "source", "file:///" + directory);
}

void MainWindowAgent::createScreen(SCREEN_ID screenId) {
    switch (screenId) {
    case ID_VIEW_CAMERA: {
        m_appContainer->setProperty("source", "qrc:/Qml/CameraView.qml");
        break;
    }
    case ID_VIEW_IMAGE: {
        m_appContainer->setProperty("source", "qrc:/Qml/ImageView.qml");
        break;
    }
    case ID_VIEW_INFO: {
        m_appContainer->setProperty("source", "qrc:/Qml/InfoView.qml");
        break;
    }
    default: {
        m_appContainer->setProperty("source", "qrc:/Qml/CameraView.qml");
        break;
    }
    }

    m_widget = qvariant_cast<QObject*>(m_appContainer->property("item"));

    if (screenId == ID_VIEW_CAMERA) {
        if (!m_camera) {
            m_camera = new Camera();
        }
        m_camera->setParent(m_widget);
    }
}
