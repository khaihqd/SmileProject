import QtQuick 2.2
import QtQuick.Controls 1.2
Rectangle {
    id: demoButton
    width: 120
    height: 26
    color: btnMouseArea.containsMouse ? "#BBBBBB" : "#CCCCCC"
    property alias _textLabel: btnLabel.text
    property string normalSource: ""
    property string focusSource: ""
    signal clicked()
    onNormalSourceChanged: {
        btnImage.source = normalSource;
    }
    Text {
        id: btnLabel
        anchors.centerIn: parent
        color: "black"
    }
    Image {
        id: btnImage
        anchors.fill: parent
        source: normalSource
    }

    MouseArea {
        id: btnMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onContainsMouseChanged: {
            btnImage.source = containsMouse ? focusSource : normalSource;
        }
        onClicked: {
            demoButton.clicked();
        }
    }
}
