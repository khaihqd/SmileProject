#ifndef MAINWINDOWAGENT_H
#define MAINWINDOWAGENT_H

#include <QQuickItem>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QtQuick>
#include <QQmlContext>
#include <QString>
#include <QStringList>


#include "camera.h"
class MainWindowAgent: public QObject
{
    Q_OBJECT
public:
    MainWindowAgent();
    ~MainWindowAgent();

public:
    static MainWindowAgent* getInstance();
    void initialize() ;
    Q_INVOKABLE void handleEvent(QString evg);
    QQmlApplicationEngine* getAppEngine();

private:
    enum SCREEN_ID {
        ID_VIEW_CAMERA,
        ID_VIEW_IMAGE,
        ID_VIEW_INFO
    };
    void handleOpenImage();
    void createScreen(SCREEN_ID screenId);

private:
    static MainWindowAgent* _instance;
    QQmlApplicationEngine m_qmlEngine;
    QObject* m_mainObj;
    QObject* m_appContainer;
    QObject* m_widget;
    Camera* m_camera;
};
#endif // MAINWINDOWAGENT_H
