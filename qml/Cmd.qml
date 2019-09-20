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

    property string cmdPrompt: qsTr(
        "<font color=\"tomato\">aquarium (disconnected): </font>"
    )
    property int responseLineCount: 0

    function goToGUI() {
        mainWindow.state = "gui"
    }

    function sendCmd() {
        if (cmdTimer.running) {
            return
        }

        if (cmdText.text == "exit") {
            Qt.quit()
        }
        else if (cmdText.text == "clear") {
            cmdOutput.text = "<pre><b>%1</b></pre>".arg(cmdPrompt)
        }
        else {
            mainWindow.sendToAquarium(cmdText.text)
            switch (cmdText.text) {
                case "status": responseLineCount = 7; break
                case "help": responseLineCount = 27; break
                default: responseLineCount = 2
            }
            cmdTimer.start()
        }
        scrollToEnd()
        cmdText.text = ""
        cmdText.focus = true
    }

    function appendLine(line) {
        cmdOutput.text = cmdOutput.text.replace("</b></pre>", "")
        if (line == "OK") {
            cmdOutput.text += "<font color=\"lime\">OK</font><br>"
        }
        else if (line == "ERROR") {
            cmdOutput.text += "<font color=\"tomato\">ERROR</font><br>"
        }
        else if (line == "UNKNOWN") {
            cmdOutput.text += "<font color=\"gray\">UNKNOWN</font><br>"
        }
        else {
            cmdOutput.text += line + "<br>"
        }

        if (responseLineCount > 0) {
            responseLineCount -= 1
            if (responseLineCount == 0) {
                cmdOutput.text += cmdPrompt
                cmdTimer.stop()
            }
        }

        cmdOutput.text += "</b></pre>"
        scrollToEnd()
    }

    function setPrompt(name, address) {
        cmdOutput.text = "<pre><b>"
        if (address == "00:00:00:00:00:00") {
            cmdPrompt = qsTr(
                "<font color=\"tomato\">aquarium (disconnected): </font>"
            )
        }
        else {
            cmdPrompt = "<font color=\"%1\">%2 (%3): </font>"
                        .arg(colors.headerText)
                        .arg(name)
                        .arg(address)
        }
        cmdOutput.text += cmdPrompt + "</b></pre>"
    }

    function scrollToEnd() {
        if (cmdOutput.height > cmdOutputScroll.height) {
            cmdOutputScroll.contentY = cmdOutput.height - cmdOutputScroll.height
        }
    }

    Timer {
        id:cmdTimer
        interval: 5000
        repeat: false
        running: false
        onTriggered: {
            responseLineCount = 1
            appendLine(qsTr("no response"))
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
            textFormat: Text.RichText
            color: colors.cmdBoxText
            font.pixelSize: mmTOpx(3.5)
            wrapMode: Text.WrapAnywhere
            text: "<pre><b>%1</b></pre>".arg(cmdPrompt)
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
