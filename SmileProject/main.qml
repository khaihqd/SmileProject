import QtQuick 2.5
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import "qrc:/Qml"
Window {
    id: gbMainAppWindow
    visible: true
    width: 800
    height: 480
    color: "#EEEEEE"
    property string _OPEN: "Open"
    property string _ANALYZE: "Analyze"
    property real _margin: 10

    Rectangle {
        id: titleBar
        anchors {
            left: gbMainAppWindow.left
            top: gbMainAppWindow.top
        }
        width: gbMainAppWindow.width
        height: 30
        color: "#DDDDDD"
        border.color: "yellow"
        border.width: 2
        Row {
            id: titleRow
            anchors.verticalCenter: parent.verticalCenter
            spacing: _margin

            TextButton {
                id: openBtn
                anchors.verticalCenter: parent.verticalCenter
                _textLabel: qsTr("Open An Image")
                onClicked: {
                    fileDialog.title = "Please choose an image file";
                    fileDialog.nameFilters = [ "Image file (*.png, *.jpg)", "All files (*)" ]
                    fileDialog.open();
                }
            }

            TextButton {
                id: analyzeBtn
                anchors.verticalCenter: parent.verticalCenter
                _textLabel: qsTr("Analyze")
                onClicked: {
                    if(_mainWindow) {
                        _mainWindow.handleEvent(_ANALYZE);
                    }
                }
            }

            TextDisplaySinglePageNotCutText {
                id: textField
                width: 300
                height: titleBar.height
                text: "Empty"
                textFontSize: 16
                alignType: "1"
            }
        }
    }

    Loader {
        id: app_container
        objectName: "app_container"
        anchors {
            left: titleBar.left
            top: titleBar.bottom
        }
        height: gbMainAppWindow.height - titleBar.height
        width: gbMainAppWindow.width
    }
    function getFileUrl() {
        return textField.text;
    }
    FileDialog {
        id: fileDialog
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl);
            textField.text = fileDialog.fileUrl;
            textField.text = textField.text.replace("file:///", "");
            if(_mainWindow) {
                _mainWindow.handleEvent(_OPEN);
            }
            //Qt.quit();
        }
        onRejected: {
            console.log("Canceled")
            //Qt.quit()
        }
        visible: false
    }

    ImageButton {
        id: addInfoBtn
        anchors {
            horizontalCenter: parent.left
            horizontalCenterOffset: width / 3
            verticalCenter: parent.bottom
            verticalCenterOffset: -height / 3
        }

        normalSource: "qrc:/Image/addInfo.jpg"
        hoverSource: "qrc:/Image/addInfo_hover.png"
        clickSource: "qrc:/Image/addInfo.jpg"
        onBtnClick: {
            addInfoTable.visible = !addInfoTable.visible;
        }
    }

    Image {
        id: addInfoTable
        width: 300
        height: 400
        x: 200
        y: 40
        source: "qrc:/Image/addInfoTable_bg.jpg"
        visible: false
        Text {
            id: addInfoLabel
            anchors {
                top: parent.top
                topMargin: _margin
                horizontalCenter: parent.horizontalCenter
            }

            text: "Please enter your information"
        }

        Column {
            id: addInfoColumn
            anchors {

                top: addInfoLabel.bottom
                topMargin: _margin
                left: parent.left
                right: parent.right
            }
            spacing: _margin
            Repeater {
                id: addInfoRepeater
                //
            }
        }
    }
}
