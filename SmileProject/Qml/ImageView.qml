import QtQuick 2.2
import QtQuick.Controls 1.2
Item {
    id: viewTextItem
    anchors.fill: parent

    Image {
        id: chosenImage
        objectName: "chosenImage"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

}

