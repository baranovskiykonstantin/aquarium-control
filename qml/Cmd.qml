import QtQuick 2.0
import QtQuick.Controls 2.1

Rectangle {
    id: cmdBox
    color: colors.cmdBoxBackground

    onOpacityChanged: {
        if (opacity === 1) {
            cmdText.focus = true
            scrollToEnd()
        }
    }

    function goToGUI() {
       mainWindow.state = "gui"
    }

    function sendCmd() {
        if (cmdText.text == "exit") {
            Qt.quit()
        }
        else if (cmdText.text == "help") {
            appendText(qsTr(
                           "\n" +
                           "Available commands:\n" +
                           "\n" +
                           "status\n" +
                           "\n" +
                           "\tGet information about current state of aquarium.\n" +
                           "\n" +
                           "\n" +
                           "date DD.MM.YY W\n" +
                           "\n" +
                           "\tSet date.\n" +
                           "\n" +
                           "\tDD - day of month (01-31)\n" +
                           "\tMM - month (01-12)\n" +
                           "\tYY - year (00-99)\n" +
                           "\tW  - day of week (1 - monday .. 7 - sunday)\n" +
                           "\n" +
                           "\n" +
                           "time HH:MM:SS\n" +
                           "time +CC\n" +
                           "time -CC\n" +
                           "time HH:MM:SS +CC\n" +
                           "time HH:MM:SS -CC\n" +
                           "\n" +
                           "\tSet time and/or time correction.\n" +
                           "\n" +
                           "\tHH - hours (00-23)\n" +
                           "\tMM - minutes (00-59)\n" +
                           "\tSS - seconds (00-59)\n" +
                           "\tCC - time correction in seconds (00-59)\n" +
                           "\n" +
                           "\n" +
                           "heat LL-HH\n" +
                           "heat on\n" +
                           "heat off\n" +
                           "heat auto\n" +
                           "\n" +
                           "\tHeater setup.\n" +
                           "\n" +
                           "\tLL - minimal temperature (00-99)\n" +
                           "\tHH - maximal temperature (00-99)\n" +
                           "\n" +
                           "\n" +
                           "light H1:M1:S1-H2:M2:S2\n" +
                           "light level XXX\n" +
                           "light H1:M1:S1-H2:M2:S2 XXX\n" +
                           "light on\n" +
                           "light off\n" +
                           "light auto\n" +
                           "\n" +
                           "\tLight setup.\n" +
                           "\n" +
                           "\tH1:M1:S1 - time of turn on light (00:00:00-23:59:59)\n" +
                           "\tH2:M2:S2 - time of turn off light (00:00:00-23:59:59)\n" +
                           "\tXXX      - brightness level (000-100)\n" +
                           "\n" +
                           "\n" +
                           "display time\n" +
                           "display temp\n" +
                           "\n" +
                           "\tDisplay setup.\n" +
                           "\n" +
                           "\n" +
                           "help\n" +
                           "\n" +
                           "\tPrint this help message.\n" +
                           "\n" +
                           "\n" +
                           "exit\n" +
                           "\n" +
                           "\tExit application."
                           )
                       )
        }
        else {
            var data = cmdText.text + "\r"
            appendText('\n')
            mainWindow.sendToAquarium(data)
        }
        scrollToEnd()
        cmdText.text = ""
    }

    function appendText (str) {
        cmdOutput.text += str
    }

    function setText (str) {
        cmdOutput.text = str
    }

    function scrollToEnd () {
        // If content bigger then text field - scroll to end
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
            color: colors.cmdBoxText
            font.family: "Droid Sans Mono"
            font.pointSize: 11
            wrapMode: Text.WrapAnywhere
        }
    }

    Rectangle {
        id: scrollBar
        anchors.right: cmdOutputScroll.right
        y: cmdOutputScroll.visibleArea.yPosition * (parent.height - cmdInput.height)
        width: 6
        height: cmdOutputScroll.visibleArea.heightRatio * (parent.height - cmdInput.height)
        radius: 3
        color: colors.cmdBoxScrollBar
    }

    Item {
        id: cmdInput
        anchors.top:cmdOutputScroll.bottom
        width: parent.width
        height: 32 * guiScale

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
                    source: "../icons/gui.png"
                    width: cmdButtonGoToGUI.width
                    height: cmdButtonGoToGUI.height
                    fillMode: Image.Stretch
                }
            }
        }

        TextField {
            id: cmdText
            placeholderText: qsTr("Enter command")
            anchors.left: cmdButtonGoToGUI.right
            font.pointSize: 11
            color: colors.cmdInputText
            width: parent.width - cmdButtonGoToGUI.width - cmdButtonSend.width
            height: cmdInput.height
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
                    source: "../icons/send.png"
                    width: cmdButtonSend.width
                    height: cmdButtonSend.height
                    fillMode: Image.Stretch
                }
            }
        }
    }
}
