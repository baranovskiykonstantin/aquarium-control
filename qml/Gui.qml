import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQml 2.12

Rectangle {
    id: guiBox
    color: "transparent"

    function goToCMD() {
        mainWindow.state = "cmd"
    }

    function setHeader(value) {
        guiHeaderText.text = value
    }

    function setValue(item, value) {
        var items = ["date", "time", "temp", "heat", "light", "display"]
        itemListModel.set(items.indexOf(item), {"itemText":value})
    }

    function setup(item) {
        switch (item) {
            case "date": mainWindow.state = "setupDate"; break
            case "time": mainWindow.state = "setupTime"; break
            case "temp":
            case "heat": mainWindow.state = "setupHeat"; break
            case "light": mainWindow.state = "setupLight"; break
            case "display":
                switch (aquarium.display) {
                    case "time":
                        mainWindow.sendToAquarium("display temp")
                        messageBox.setText(qsTr(
                            "Display shows the temperature now."
                        ))
                        break
                    case "temp":
                        mainWindow.sendToAquarium("display time")
                        messageBox.setText(qsTr(
                            "Display shows the time now."
                        ))
                        break
                }
                mainWindow.sendToAquarium("status")
                break
        }
    }

    Rectangle {
        id: itemListControl
        color: "transparent"
        width: parent.width - mmTOpx(2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: guiHeader.bottom
        anchors.bottom: guiButtonBox.top

        ListModel {
            id: itemListModel

            ListElement {
                itemName: "date"
                itemText: qsTr("no data")
            }
            ListElement {
                itemName: "time"
                itemText: qsTr("no data")
            }
            ListElement {
                itemName: "temp"
                itemText: qsTr("no data")
            }
            ListElement {
                itemName: "heat"
                itemText: qsTr("no data")
            }
            ListElement {
                itemName: "light"
                itemText: qsTr("no data")
            }
            ListElement {
                itemName: "display"
                itemText: qsTr("no data")
            }
        }

        Component {
            id: itemListDelegate

            Item {
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemBackground
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Rectangle {
                    id: itemImageBackground
                    anchors.left: parent.left
                    height: parent.height
                    width: height
                    color: "transparent"
                }

                Image {
                    id: itemImage
                    source: "../icons/%1.svg".arg(itemName)
                    height: mmTOpx(8)
                    width: height
                    fillMode: Image.Stretch
                    anchors.verticalCenter: itemImageBackground.verticalCenter
                    anchors.horizontalCenter: itemImageBackground.horizontalCenter
                }

                ColorOverlay {
                    anchors.fill: itemImage
                    source: itemImage
                    color: colors.itemText
                }

                Text {
                    id: itemLabelText
                    text: itemText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: itemImageBackground.right
                    anchors.right: parent.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: setup(itemName)
                    onPressed: itemBackground.color = colors.itemPressed
                    onReleased: itemBackground.color = colors.itemBackground
                    onCanceled: itemBackground.color = colors.itemBackground
                }
            }
        }

        ListView {
            id: itemListView
            anchors.fill: parent
            spacing: mmTOpx(1)
            model: itemListModel
            delegate: itemListDelegate
            focus: true
        }
    }

    Rectangle {
        id: guiHeader
        color: colors.background
        height: mmTOpx(14)
        width: parent.width

        Rectangle {
            id: guiHeaderBackground
            color: colors.headerBackground
            width: parent.width
            height: parent.height - mmTOpx(1)
        }

        Text {
            id: guiHeaderText
            text: qsTr("aquarium (disconnected)")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.headerText
            font.pixelSize: mmTOpx(4)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: mainWindow.searchPorts()
            onPressed: guiHeaderBackground.color = colors.headerPressed
            onReleased: guiHeaderBackground.color = colors.headerBackground
        }
    }

    Rectangle {
        id: guiButtonBox
        color: colors.background
        anchors.bottom: parent.bottom
        width: parent.width
        height: mmTOpx(10)

        Row {
            anchors.fill: parent
            anchors.margins: mmTOpx(1)
            spacing: mmTOpx(1)

            Rectangle {
                id: cmdButton
                color: colors.buttonBackground
                width: (parent.width - parent.spacing) / 2
                height: parent.height

                Text {
                    text: qsTr("Terminal")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colors.buttonText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: goToCMD()
                    onPressed: cmdButton.color = colors.buttonPressed
                    onReleased: cmdButton.color = colors.buttonBackground
                }
            }

            Rectangle {
                id: exitButton
                color: colors.buttonBackground
                width: (parent.width - parent.spacing) / 2
                height: parent.height

                Text {
                    text: qsTr("Exit")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colors.buttonText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mainWindow.quit()
                    onPressed: exitButton.color = colors.buttonPressed
                    onReleased: exitButton.color = colors.buttonBackground
                }
            }
        }
    }
}
