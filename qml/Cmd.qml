import QtQuick 2.0
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: cmdBox
    color: colors.cmdBoxBackground

    onOpacityChanged: {
        if (opacity == 1) {
            scrollToEnd()
            cmdText.focus = true
        }
    }

    property string command: ""

    function goToGUI() {
        mainWindow.state = "gui"
    }

    function sendCmd() {
        if (cmdText.text == "exit") {
            Qt.quit()
        }
        command = cmdText.text
        mainWindow.sendToAquarium(command)
        scrollToEnd()
        cmdText.focus = true
        cmdText.text = ""
    }

    function appendText(str) {
        if (command != "" && str.match(command)) {
            str = str.replace(command, "<br><font color=\"%1\">%2</font><br>"
                                       .arg(colors.headerText)
                                       .arg(command))
            command = ""
        }
        str = str.replace(/\r\n/g, "<br>")
        str = str.replace("OK", "<font color=\"lime\">OK</font>")
        str = str.replace("ERROR", "<font color=\"tomato\">ERROR</font>")
        str = str.replace("UNKNOWN", "<font color=\"gray\">UNKNOWN</font>")
        cmdOutput.text += str
        scrollToEnd()
    }

    function setText(str) {
        cmdOutput.text = str
    }

    function scrollToEnd() {
        // If content is bigger then the text field - scroll to end
        if (cmdOutput.height > cmdOutputScroll.height) {
            cmdOutputScroll.contentY = cmdOutput.height - cmdOutputScroll.height
        }
    }

    Flickable {
        id: cmdOutputScroll
        width: parent.width
        height: parent.height - cmdInput.height
        contentWidth: width
        contentHeight: cmdOutput.height
        boundsBehavior: Flickable.OvershootBounds

        Text {
            id: cmdOutput
            width: parent.width
            textFormat: Text.StyledText
            color: colors.cmdBoxText
            font.pixelSize: mmTOpx(3.5)
            wrapMode: Text.WrapAnywhere
            text: "<font color=\"tomato\">aquarium (disconnected):</font><br>"
        }
    }

    Rectangle {
        id: scrollBar
        anchors.right: cmdOutputScroll.right
        y: cmdOutputScroll.visibleArea.yPosition * (parent.height - cmdInput.height)
        width: mmTOpx(2)
        height: cmdOutputScroll.visibleArea.heightRatio * (parent.height - cmdInput.height)
        radius: mmTOpx(1)
        color: colors.cmdBoxScrollBar
    }

    Item {
        id: cmdInput
        anchors.top:cmdOutputScroll.bottom
        width: parent.width
        height: mmTOpx(8)

        Button {
            id: cmdButtonGoToGUI
            anchors.left: parent.left
            height: cmdInput.height
            width: height
            flat: true
            onClicked: cmdBox.goToGUI()

            background: Rectangle {
                color: cmdButtonGoToGUI.down ? colors.buttonPressed : colors.buttonBackground

                Image {
                    id: cmdButtonGoToGUIImage
                    source: "../icons/gui.svg"
                    width: cmdButtonGoToGUI.width
                    height: cmdButtonGoToGUI.height
                    fillMode: Image.Stretch
                }

                ColorOverlay {
                    anchors.fill: cmdButtonGoToGUIImage
                    source: cmdButtonGoToGUIImage
                    color: colors.buttonText
                }
            }
        }

        TextField {
            id: cmdText
            placeholderText: qsTr("Enter command")
            anchors.left: cmdButtonGoToGUI.right
            font.pixelSize: mmTOpx(4)
            color: colors.cmdInputText
            width: parent.width - cmdButtonGoToGUI.width - cmdButtonSend.width
            height: cmdInput.height
            maximumLength: 63
            Keys.onReturnPressed: cmdBox.sendCmd()

            background: Rectangle {
                color: colors.cmdInputBackground
            }
        }

        Button {
            id: cmdButtonSend
            anchors.left: cmdText.right
            height: cmdInput.height
            width: height
            flat: true
            onClicked: cmdBox.sendCmd()

            background: Rectangle {
                color: cmdButtonSend.down ? colors.buttonPressed : colors.buttonBackground

                Image {
                    id: cmdButtonSendImage
                    source: "../icons/send.svg"
                    width: cmdButtonSend.width
                    height: cmdButtonSend.height
                    fillMode: Image.Stretch
                }

                ColorOverlay {
                    anchors.fill: cmdButtonSendImage
                    source: cmdButtonSendImage
                    color: colors.buttonText
                }
            }
        }
    }
}
