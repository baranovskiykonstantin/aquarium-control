import QtQuick 2.0

Rectangle {
    id: messageBox
    z: 0
    color: "transparent"

    property bool error: false

    function show () {
        messageBox.z = 3
    }

    function setTitle (title) {
        messageTitle.text = title
    }

    function setText (message) {
        messageText.text = message
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
        height: 150 * guiScale
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: messageTitle
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 10
            color: colors.messageText
            font.pointSize: 11
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
            anchors.margins: 5
            color: colors.messageText
            font.pointSize: 11
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
            id: okButton
            color: colors.buttonBackground
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
            height: 48 * guiScale

            Text {
                text: messageBox.error ? qsTr("Exit") : qsTr("OK")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: colors.buttonText
                font.pointSize: 11
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    messageBox.error ? Qt.quit() : messageBox.z = 0
                    messageTitle.text = ""
                    messageText.text = ""
                }
                onPressed: okButton.color = colors.buttonPressed
                onReleased: okButton.color = colors.buttonBackground
            }
        }
    }
}
