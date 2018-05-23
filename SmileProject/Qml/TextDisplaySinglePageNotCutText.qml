import QtQuick 2.3

Text {
    id: text_field
    property real timePerPage: 3000
    property int textFontSize: 23
    property string alignType: "0"
    property bool isMultiLine: false
    property string orgText: ""
    property bool isUnCutWord: false
    property var _stringList: []
    horizontalAlignment: alignType === "0" ? Text.AlignHCenter : Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
    color: "green"//#FFFFFF"
    font.pixelSize: textFontSize
    clip: true

    onOrgTextChanged: {
        runTextUnCut();
        startCalculateText();
    }
    Component.onCompleted: {
        startCalculateText();
        runTextUnCut();
    }
    onVisibleChanged: {
        if (visible) {
            runTextUnCut();
        }
    }
    onTextChanged: {
        if (!isTextRun) {
            orgText = text;
        }
    }
    onIsMultiLineChanged: {
        if (isMultiLine) {
            maximumLineCount = 2;
        } else {
            maximumLineCount = 1;
        }
        runTextUnCut();
        startCalculateText();
    }

    property bool isTextRun: false
    function setText(textData) {
        isTextRun = true;
        text_field.text = textData;
        isTextRun = false;
    }

    function runTextUnCut() {
        timerUncut.stop();
        timerUncut.start();
    }

    function isCorrectStringListLength() {
        var ret = false;
        if (isMultiLine && _stringList.length == 2)
            ret = true;
        else if (!isMultiLine && _stringList.length == 1)
            ret = true;
        return ret;
    }

    property int currentPage: 0
    property bool isRunToTheRight: true
    function doUpdateText() {
        if (_stringList.length == 0) {
            setText("");
            return;
        } else if (!isContinueCalculate && isCorrectStringListLength()) {
            text_field.wrapMode = Text.WrapAnywhere;
            setText(orgText);
            timerUncut.stop();
            return;
        } else if (isMultiLine) {
            runMultiLine()
        } else {
            runOneLine();
        }
    }

    function runMultiLine() {
        if (currentPage <= 0 && !isRunToTheRight){
            // Stop run and trimed();
            setText(orgText);
            if (isUnCutWord) {
                text_field.wrapMode = Text.WordWrap;
            } else {
                text_field.wrapMode = Text.WrapAnywhere;
            }
            text_field.elide = Text.ElideRight;
            timerUncut.stop();
            return;
        }
        var line1 = checkIndex(currentPage) ? _stringList[currentPage] : "";
        var line2 = checkIndex(currentPage + 1) ? _stringList[currentPage + 1] : "";
        setText(line1 + line2);

        if (!isContinueCalculate && currentPage + 2 >= _stringList.length) {
            isRunToTheRight = false;
        }
        if (isRunToTheRight)
            currentPage+=2;
        else
            currentPage-=2;
    }

    function checkIndex(idx) {
        if (idx >= 0 && idx < _stringList.length)
            return true;
        return false;
    }

    function runOneLine() {
        if (currentPage <= 0 && !isRunToTheRight){
            // Stop run and trimed();
            setText(orgText);
            text_field.wrapMode = Text.WrapAnywhere;
            text_field.elide = Text.ElideRight;
            timerUncut.stop();
            return;
        }
        setText(checkIndex(currentPage) ? _stringList[currentPage] : "");
        if (!isContinueCalculate && currentPage + 1 >= _stringList.length) {
            isRunToTheRight = false;
        }
        if (isRunToTheRight)
            currentPage++;
        else
            currentPage--;
    }

    function startCalculateText() {
        _stringList = [];
        startIdx = 0;
        endIdx = Math.round(text_field.width / text_field.font.pixelSize);
        currentPage = 0;
        isContinueCalculate = true;
        isRunToTheRight = true;
        if (isMultiLine) {
            maximumLineCount = 2;
            verticalAlignment = Text.AlignTop;
        } else {
            maximumLineCount = 1;
        }
        if (isUnCutWord) {
            text_field.wrapMode = Text.WordWrap;
        } else {
            text_field.wrapMode = Text.WrapAnywhere;
        }
        text_field.elide = Text.ElideNone;

        calculateTextWidth();
    }

    property bool isContinueCalculate: true
    function calculateTextWidth() {
        if (startIdx >= orgText.length) {
            return;
        }
        if (endIdx >= orgText.length) {
            endIdx = orgText.length;
            isContinueCalculate = false;
        }
        unvisibleText.text = "";
        unvisibleText.text = orgText.slice(startIdx, endIdx);
    }

    property int startIdx: 0
    property int endIdx: Math.round(text_field.width / text_field.font.pixelSize)
    Text {
        id: unvisibleText
        visible: false
        font: text_field.font
        property bool isStop: false
        onWidthChanged: {
            if (width == 0)
                return;
            if (unvisibleText.width > text_field.width) {
                endIdx--;
                isStop = true;
                calculateTextWidth();
            } else if (endIdx == orgText.length) {
                _stringList.push(unvisibleText.text);
                if ((_stringList.length == 1 && !isContinueCalculate)
                    || (isMultiLine && _stringList.length == 2 && !isContinueCalculate)) {
                    doUpdateText();
                }
            } else if (unvisibleText.width < text_field.width && !isStop) {
                endIdx++;
                calculateTextWidth();
            } else {
                isStop = false;
                var lastIdx = unvisibleText.text.lastIndexOf(" ");
                if (isUnCutWord && lastIdx !== -1) {
                    startIdx += lastIdx + 1;
                    endIdx += lastIdx + 1;
                    _stringList.push(unvisibleText.text.slice(0, lastIdx + 1));
                } else {
                    startIdx = endIdx ;
                    endIdx += unvisibleText.text.length;
                    _stringList.push(unvisibleText.text);
                }

                if ((!isMultiLine && _stringList.length == 1)
                    || (isMultiLine && _stringList.length == 2)) {
                    doUpdateText();
                }
                if (isContinueCalculate) {
                    calculateTextWidth();
                    return;
                }
            }
        }
    }

    Timer {
        id:timerUncut
        interval: timePerPage
        running: false
        repeat: true
        onTriggered: {
            doUpdateText();
        }
    }

    // Easy solution
//    onorgTextChanged: {
//        runTextUnCut();
//    }
//    Component.onCompleted: {
//        //runTextUnCut();
//    }
//    onVisibleChanged: {
//        if (visible) {
//            runTextUnCut();
//        }
//    }

//    function runTextUnCut() {
//        timerUncut.stop();
//        console.log("runTextUnCut start");
//        calculateTextWidth();
//        timerUncut.start();
//    }

//    function calculateTextWidth() {
//        console.log("calculateTextWidth" + startIdx + "|"+ endIdx);
//        unvisibleText.text = orgText.slice(startIdx, endIdx);
//    }

//    property int startIdx: 0
//    property int endIdx: 1//Math.round(text_field.width / text_field.font.pixelSize)
//    Text {
//        id: unvisibleText
//        visible: false
//        font: text_field.font
//        property bool isStop: false
//        onWidthChanged: {
//            console.log("onTextChanged:" + unvisibleText.text + "|"+ unvisibleText.width + "|"+ text_field.width);
//            if (unvisibleText.width > text_field.width) {
//                endIdx--;
//                isStop = true;
//                unvisibleText.text = orgText.slice(startIdx, endIdx);
//            } else if (unvisibleText.width < text_field.width && !isStop) {
//                endIdx++;
//                unvisibleText.text = orgText.slice(startIdx, endIdx);
//            } else {
//                isStop = false;
//                startIdx += unvisibleText.text.length ;
//                endIdx += unvisibleText.text.length;
//                _stringList.push(unvisibleText.text)
//                console.log("Finish"+ text_field.text + "|"+ startIdx + "|"+ endIdx);
//            }
//        }
//    }

//    Timer {
//        id:timerUncut
//        interval: timePerPage
//        running: false
//        repeat: true
//        onTriggered: {
//            calculateTextWidth();
//        }
//    }
}


