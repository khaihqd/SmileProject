import QtQuick 2.2
import QtQuick.Controls 1.2
import QtMultimedia 5.8
Item {
    id: viewTextItem
    anchors.fill: parent
    Camera {
        id: camera

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        flash.mode: Camera.FlashRedEyeReduction

        imageCapture {
            onImageCaptured: {
                photoPreview.source = preview  // Show the preview in an Image
            }
        }
    }

    VideoOutput {
        source: camera
        anchors.fill: parent
        focus : visible // to receive focus and capture key events when visible
    }

    Image {
        id: photoPreview
    }
    ImageButton {
        id: captureBtn
        x: viewTextItem.width - captureBtn.width * 1.5
        y: viewTextItem.height - captureBtn.height * 1.5
        opacity: 0.3
        source: "qrc:/Image/captureBtn.jpg"
        MouseArea {
            id: btnMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onContainsMouseChanged: {
                captureBtn.opacity = containsMouse ? 0.8 : 0.3;
            }
            onClicked: {
                if (_mainWindow) {
                    //_mainWindow.handleEvent();
                }
            }
            drag.target: captureBtn
            drag.axis: Drag.XAndYAxis
            drag.minimumX: 0
            drag.maximumX: viewTextItem.width - captureBtn.width
            drag.minimumY: 0
            drag.maximumY: viewTextItem.height - captureBtn.height
        }
    }
}

