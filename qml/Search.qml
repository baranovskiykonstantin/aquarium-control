import QtQuick 2.0
import QtQuick.Window 2.0

Rectangle {
    id: searchBox
    color: "transparent"
    anchors.fill: parent

    onOpacityChanged: {
        if (opacity == 1) {
            startAnimation()
        }
        else {
            stopAnimation()
        }
    }

    function startAnimation() {
        fishImage.source = "../icons/fish.svg"
        fishAnimation.running = true
    }

    function stopAnimation() {
        fishImage.source = "../icons/fish-sad.svg"
        fishAnimation.running = false
    }

    function setText(newText) {
        searchText.text = newText
    }

    Rectangle {
        id: searchMessage
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: fishImage.height + searchText.height + searchText.anchors.topMargin

        Behavior on height {
            NumberAnimation { duration: 250 }
        }

        Image {
            id: fishImage
            focus: true
            source: "../icons/fish.svg"
            width: mmTOpx(8)
            height: width
            fillMode: Image.Stretch

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            RotationAnimation {
                id: fishInit
                target: fishImage
                easing.type: Easing.InOutExpo
                property: "rotation"
                from: fishImage.rotation
                to: fishImage.rotation > 180 ? 360 : 0
                duration: 2500
                loops: 1
                alwaysRunToEnd: true
                running: false
            }

            SequentialAnimation {
                id: fishAnimation
                loops: Animation.Infinite
                running: true
                onRunningChanged: {
                    if (running == false) {
                        fishInit.running = true
                    }
                }

                RotationAnimation {
                    target: fishImage
                    easing.type: Easing.InOutBack
                    property: "rotation"
                    from: 0
                    to: 360
                    duration: 2500
                    loops: 1
                    alwaysRunToEnd: true
                }
                PauseAnimation {
                    duration: 250
                }
                RotationAnimation {
                    target: fishImage
                    easing.type: Easing.InOutBack
                    property: "rotation"
                    from: 360
                    to: 0
                    duration: 2500
                    loops: 1
                    alwaysRunToEnd: true
                }
                PauseAnimation {
                    duration: 250
                }
            }
        }

        Text {
            id: searchText
            anchors.top: fishImage.bottom
            anchors.topMargin: mmTOpx(5)
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Search of aquariums...")
            horizontalAlignment: Text.AlignHCenter
            color: colors.itemText
            font.pixelSize: mmTOpx(4)
        }
    }

    Rectangle {
        id: buttonBox
        color: colors.background
        anchors.bottom: parent.bottom
        width: parent.width
        height: mmTOpx(10)

        Rectangle {
            id: cancelButton
            color: colors.buttonBackground
            anchors.margins: mmTOpx(1)
            anchors.fill: parent

            Text {
                text: qsTr("Cancel")
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: colors.buttonText
                font.pixelSize: mmTOpx(3.5)
                wrapMode: Text.WordWrap
            }

            MouseArea {
                anchors.fill: parent
                onClicked: mainWindow.stopSearching()
                onPressed: cancelButton.color = colors.buttonPressed
                onReleased: cancelButton.color = colors.buttonBackground
            }
        }
    }
}

