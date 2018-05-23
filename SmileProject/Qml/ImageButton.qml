import QtQuick 2.2
import QtQuick.Controls 1.2
Image {
    id: demoImageButton
    width: 80
    height: 80
    property string normalSource: ""
    property string hoverSource: ""
    property string clickSource: ""
    property string onClickEvent: ""
    property string eventParam: ""
    source: normalSource
    onNormalSourceChanged: {
        demoImageButton.source = normalSource;
    }
    signal btnClick()
    MouseArea {
        id: btnMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            if (hoverSource !== "") {
                demoImageButton.source = hoverSource;
            }
        }
        onExited: {
            if (normalSource !== "") {
                demoImageButton.source = normalSource;
            }
        }
        onPressed: {
            if (clickSource !== "") {
                demoImageButton.source = clickSource;
            }
        }
        onReleased: {
            if (containsMouse) {
                demoImageButton.source = hoverSource;
            } else {
                demoImageButton.source = normalSource;
            }
        }
        onClicked: {
            demoImageButton.btnClick();
            if (_mainWindow) {
                _mainWindow.handleEvent(onClickEvent + "(" + eventParam + ")");
            }
        }
    }
}
