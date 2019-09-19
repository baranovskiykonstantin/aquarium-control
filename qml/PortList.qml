import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: portListBox
    color: "transparent"

    function cancel() {
        mainWindow.state = "gui"
    }

    function addItem(name) {
        portListModel.append({"portName": name})
    }

    function getItemCount() {
        return portListModel.count
    }

    function removeItems() {
        portListModel.clear()
    }

    Rectangle {
        id: header
        color: colors.background
        height: mmTOpx(14)
        width: parent.width

        Rectangle {
            id: headerBackground
            color: colors.headerBackground
            width: parent.width
            height: parent.height - mmTOpx(1)
        }

        Text {
            id: headerText
            text: qsTr("Select communication port")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.headerText
            font.pixelSize: mmTOpx(4)
        }
    }

    Rectangle {
        id: listControl
        color: "transparent"
        width: parent.width - mmTOpx(2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom
        anchors.bottom: buttonBox.top

        ListModel {
            id: portListModel

            // ListItem {
            //     portName: ...
            // }
        }

        Component {
            id: listItemDelegate

            Item {
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemBackground
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: listItemText
                    text: portName
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: itemBackground.left
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mainWindow.connectToAquarium(portName)
                    onPressed: itemBackground.color = colors.itemPressed
                    onReleased: itemBackground.color = colors.itemBackground
                    onCanceled: itemBackground.color = colors.itemBackground
                }
            }
        }

        ListView {
            id: portListView
            anchors.fill: parent
            spacing: mmTOpx(1)
            model: portListModel
            delegate: listItemDelegate
            focus: true
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
                onClicked: cancel()
                onPressed: cancelButton.color = colors.buttonPressed
                onReleased: cancelButton.color = colors.buttonBackground
            }
        }
    }
}
