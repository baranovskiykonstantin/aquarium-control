import QtQuick 2.0

Rectangle {
    id: messageBox
    z: 0
    color: "transparent"

    function show() {
        messageBox.z = 3
    }

    function setTitle(title) {
        // Do not modify message box if it's showing
        if (messageBox.z != 3) {
            messageTitle.text = title
        }
    }

    function setText(message) {
        // Do not modify message box if it's showing
        if (messageBox.z != 3) {
            messageText.text = message
        }
    }

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        color: "#80000000"
        anchors.fill: parent
    }

    Rectangle {
        id: message
        color: colors.messageBackground
        width: parent.width * 0.6
        height: mmTOpx(40)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: messageTitle
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: mmTOpx(2)
            color: colors.messageText
            font.pixelSize: mmTOpx(3.5)
            font.bold: true
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: messageText
            anchors.top: messageTitle.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: okButton.top
            anchors.margins: mmTOpx(1)
            color: colors.messageText
            font.pixelSize: mmTOpx(3.5)
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
            id: okButton
            color: colors.buttonBackground
            anchors.bottom: parent.bottom
            anchors.bottomMargin: mmTOpx(1)
            anchors.left: parent.left
            anchors.leftMargin: mmTOpx(1)
            anchors.right: parent.right
            anchors.rightMargin: mmTOpx(1)
            height: mmTOpx(10)

            Text {
                text: qsTr("OK")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: colors.buttonText
                font.pixelSize: mmTOpx(3.5)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    messageBox.z = 0
                    messageTitle.text = ""
                    messageText.text = ""
                }
                onPressed: okButton.color = colors.buttonPressed
                onReleased: okButton.color = colors.buttonBackground
            }
        }
    }
}
