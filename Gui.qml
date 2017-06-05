import QtQuick 2.0

Rectangle {
    id: guiBox
    color: "transparent"

    function updateGui() {
        cmdBox.appendText('\n')
        socket.stringData = "status\r"
    }

    function goToCMD() {
        mainItem.state = "cmd"
    }

    function setHeader (value) {
        guiHeaderText.text = value
    }

    function setValue (item, value) {
        switch (item) {
        case "date":
            list.itemAt(0).value = value
            break
        case "time":
            list.itemAt(1).value = value
            break
        case "temp":
            list.itemAt(2).value = value
            break
        case "heat":
            list.itemAt(3).value = value
            break
        case "light":
            list.itemAt(4).value = value
            break
        case "display":
            list.itemAt(5).value = value
            break
        }
    }

    function setup (item) {
        switch (item) {
        case "date":
            mainItem.state = "setupDate"
            break
        case "time":
            mainItem.state = "setupTime"
            break
        case "temp":
        case "heat":
            mainItem.state = "setupHeat"
            break
        case "light":
            mainItem.state = "setupLight"
            break
        case "display":
            cmdBox.appendText('\n')
            switch (display) {
            case "time":
                socket.stringData = "display temp\r"
                messageBox.setText(qsTr("Display shows the temperature now."))
                break
            case "temp":
                socket.stringData = "display time\r"
                messageBox.setText(qsTr("Display shows the time now."))
                break
            }
            socket.stringData = "status\r"
            break
        }
    }

    Flickable {
        width: parent.width - 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: guiHeader.bottom
        anchors.bottom: guiButtonBox.top
        contentWidth: width
        contentHeight: itemColumn.childrenRect.height
        boundsBehavior: Flickable.OvershootBounds

        Column {
            id: itemColumn
            width: parent.width
            spacing: 5

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
                    property alias value: itemLabelText.text
                    width: parent.width
                    height: 52 * guiScale

                    Rectangle {
                        id: itemBackgound
                        anchors.fill: parent
                        color: "#33aaff"
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
                        source: "icons/%1.png".arg(name)
                        fillMode: Image.Pad
                        anchors.verticalCenter: itemImageBackground.verticalCenter
                        anchors.horizontalCenter: itemImageBackground.horizontalCenter
                    }

                    Text {
                        id: itemLabelText
                        text: qsTr("no data")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: itemImageBackground.right
                        anchors.right: parent.right
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        color: "#1e1e1e"
                        font.pointSize: 11
                        wrapMode: Text.Wrap
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: setup(name)
                    }
                }
            }
        }
    }

    Rectangle {
        id: guiHeader
        color: "#0096ff"
        height: 48 * guiScale
        width: parent.width

        Rectangle {
            id: guiHeaderBackground
            color: "#33aaff"
            width: parent.width
            height: parent.height - 5
        }

        Text {
            id: guiHeaderText
            text: qsTr("Aquarium")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#1e1e1e"
            font.pointSize: 11
        }
    }

    Rectangle {
        id: guiButtonBox
        color: "#0096ff"
        anchors.bottom: parent.bottom
        width: parent.width
        height: 48 * guiScale

        Row {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            Rectangle {
                id: exitButton
                color: "#33aaff"
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Exit")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: { Qt.quit() }
                    onPressed: exitButton.color = "#f0f0f0"
                    onReleased: exitButton.color = "#33aaff"
                }
            }

            Rectangle {
                id: updateButton
                color: "#33aaff"
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Update")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: updateGui()
                    onPressed: updateButton.color = "#f0f0f0"
                    onReleased: updateButton.color = "#33aaff"
                }
            }

            Rectangle {
                id: cmdButton
                color: "#33aaff"
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Terminal")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: goToCMD()
                    onPressed: cmdButton.color = "#f0f0f0"
                    onReleased: cmdButton.color = "#33aaff"
                }
            }

        }
    }
}
