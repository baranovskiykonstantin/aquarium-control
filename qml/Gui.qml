import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: guiBox
    color: "transparent"

    function updateGui() {
        mainWindow.sendToAquarium("status")
    }

    function goToCMD() {
        mainWindow.state = "cmd"
    }

    function setHeader(value) {
        guiHeaderText.text = value
    }

    function setValue(item, value) {
        switch (item) {
        case "date":
            list.itemAt(0).setValue(value)
            break
        case "time":
            list.itemAt(1).setValue(value)
            break
        case "temp":
            list.itemAt(2).setValue(value)
            break
        case "heat":
            list.itemAt(3).setValue(value)
            break
        case "light":
            list.itemAt(4).setValue(value)
            break
        case "display":
            list.itemAt(5).setValue(value)
            break
        }
    }

    function setup(item) {
        switch (item) {
        case "date":
            mainWindow.state = "setupDate"
            break
        case "time":
            mainWindow.state = "setupTime"
            break
        case "temp":
        case "heat":
            mainWindow.state = "setupHeat"
            break
        case "light":
            mainWindow.state = "setupLight"
            break
        case "display":
            switch (aquarium.display) {
            case "time":
                mainWindow.sendToAquarium("display temp")
                messageBox.setText(qsTr("Display shows the temperature now."))
                break
            case "temp":
                mainWindow.sendToAquarium("display time")
                messageBox.setText(qsTr("Display shows the time now."))
                break
            }
            mainWindow.sendToAquarium("status")
            break
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
            onClicked: mainWindow.startSearching()
            onPressed: guiHeaderBackground.color = colors.headerPressed
            onReleased: guiHeaderBackground.color = colors.headerBackground
        }
    }

    Flickable {
        width: parent.width - mmTOpx(2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: guiHeader.bottom
        anchors.bottom: guiButtonBox.top
        contentWidth: width
        contentHeight: itemColumn.childrenRect.height
        boundsBehavior: Flickable.OvershootBounds

        Column {
            id: itemColumn
            width: parent.width
            spacing: mmTOpx(1)

            Repeater {
                id: list
                model: ListModel {
                    ListElement {
                        name: "date"
                    }
                    ListElement {
                        name: "time"
                    }
                    ListElement {
                        name: "temp"
                    }
                    ListElement {
                        name: "heat"
                    }
                    ListElement {
                        name: "light"
                    }
                    ListElement {
                        name: "display"
                    }
                }
                delegate: Item {
                    width: parent.width
                    height: mmTOpx(10)

                    function setValue(value) {
                        itemLabelText.text = value
                        // Fit text in label by decreasing font size
                        while (itemLabelText.truncated == true) {
                            itemLabelText.font.pixelSize -= mmTOpx(0.1)
                        }
                    }

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
                        source: "../icons/%1.svg".arg(name)
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
                        text: qsTr("no data")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: itemImageBackground.right
                        anchors.right: parent.right
                        anchors.leftMargin: mmTOpx(1)
                        color: colors.itemText
                        font.pixelSize: mmTOpx(3.5)
                        fontSizeMode: Text.HorizontalFit
                        minimumPixelSize: mmTOpx(2)
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: setup(name)
                        onPressed: itemBackground.color = colors.itemPressed
                        onReleased: itemBackground.color = colors.itemBackground
                        onCanceled: itemBackground.color = colors.itemBackground
                    }
                }
            }
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
                width: (parent.width - 2 * parent.spacing) / 3
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
                id: updateButton
                color: colors.buttonBackground
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Update")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colors.buttonText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: updateGui()
                    onPressed: updateButton.color = colors.buttonPressed
                    onReleased: updateButton.color = colors.buttonBackground
                }
            }

            Rectangle {
                id: exitButton
                color: colors.buttonBackground
                width: (parent.width - 2 * parent.spacing) / 3
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
                    onClicked: { Qt.quit() }
                    onPressed: exitButton.color = colors.buttonPressed
                    onReleased: exitButton.color = colors.buttonBackground
                }
            }
        }
    }
}
