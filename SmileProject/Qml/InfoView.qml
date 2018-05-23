import QtQuick 2.2
import QtQuick.Controls 1.2
Item {
    id: viewTextItem

    anchors.fill: parent

    TextDisplaySinglePageNotCutText {
        id: testText
        objectName: "asdsa"
        anchors.centerIn: parent
        height: 100
        width: 327
        textFontSize: 28
        text: textxx
        isMultiLine: true
        alignType: "0"
        isUnCutWord: true
        property string textxx: "DRS 4 News - Was die Welt bewegtU CAN GET IT ALLRBUEBE0smusikwelle.ch"
    }

}

