import QtQuick 2.0
import QtQuick.Controls 2.1

Rectangle {
    id: setupHeat
    color: "transparent"

    onOpacityChanged: {
        if (opacity == 1) {
            var matchRes = heat.toString().match(new RegExp("(\\d+)-(\\d+)", "m"))
            itemMinTempSpinbox.value = matchRes[1]
            itemMaxTempSpinbox.value = matchRes[2]
        }
    }

    function cancel () {
        mainItem.state = "gui"
    }

    function heatOn () {
        cmdBox.appendText('\n')
        socket.stringData = "heat on\r"
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Heater was turned on manually."))
    }

    function heatOff () {
        cmdBox.appendText('\n')
        socket.stringData = "heat off\r"
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Heater was turned off manually."))
    }

    function heatAuto () {
        cmdBox.appendText('\n')
        socket.stringData = "heat auto\r"
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Heater was set to automatic mode."))
    }

    function setup () {
        cmdBox.appendText('\n')
        socket.stringData = "heat %1-%2\r"
        .arg(("00" + itemMinTempSpinbox.value).slice(-2))
        .arg(("00" + itemMaxTempSpinbox.value).slice(-2))
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Water temperature will be maintained in range %1-%2 °C.")
                           .arg(("00" + itemMinTempSpinbox.value).slice(-2))
                           .arg(("00" + itemMaxTempSpinbox.value).slice(-2))
                           )
    }

    Flickable {
        width: parent.width - 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom
        anchors.bottom: buttonBox1.top
        contentWidth: width
        contentHeight: itemColumn.childrenRect.height
        boundsBehavior: Flickable.OvershootBounds

        Column {
            id: itemColumn
            width: parent.width
            spacing: 5

            Item {
                id: itemMinTemp
                width: parent.width
                height: 52 * guiScale

                Rectangle {
                    id: itemMinTempBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemMinTempLabelText
                    text: qsTr("Minimal temperature")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemMinTempSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
                    id: itemMinTempSpinbox
                    editable: true
                    value: 0
                    from: 0
                    to: 99
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemMinTemp.height

                    onValueChanged: {
                        if (value > itemMaxTempSpinbox.value) {
                            messageBox.setText(qsTr("Minimal temperature cannot be bigger than maximal."))
                            messageBox.show()
                            value = itemMaxTempSpinbox.value
                        }
                    }
                }
            }

            Item {
                id: itemMaxTemp
                width: parent.width
                height: 52 * guiScale

                Rectangle {
                    id: itemMaxTempBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemMaxTempLabelText
                    text: qsTr("Maximal temperature")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemMaxTempSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
                    id: itemMaxTempSpinbox
                    editable: true
                    from: 0
                    to: 99
                    value: 99
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemMaxTemp.height

                    onValueChanged: {
                        if (value < itemMinTempSpinbox.value) {
                            messageBox.setText(qsTr("Maximal temperature cannot be less than minimal."))
                            messageBox.show()
                            value = itemMinTempSpinbox.value
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: header
        color: "#0096ff"
        height: 48 * guiScale
        width: parent.width

        Rectangle {
            id: headerBackground
            color: "#33aaff"
            width: parent.width
            height: parent.height - 5
        }

        Text {
            id: headerText
            text: qsTr("Heat setup")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#1e1e1e"
            font.pointSize: 11
        }
    }

    Rectangle {
        id: buttonBox1
        color: "#0096ff"
        anchors.bottom: buttonBox2.top
        width: parent.width
        height: 48 * guiScale - 5

        Row {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 5
            spacing: 5

            Rectangle {
                id: heatOnButton
                color: "#33aaff"
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Turn on")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: heatOn()
                    onPressed: heatOnButton.color = "#f0f0f0"
                    onReleased: heatOnButton.color = "#33aaff"
                }
            }

            Rectangle {
                id: heatOffButton
                color: "#33aaff"
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Turn off")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: heatOff()
                    onPressed: heatOffButton.color = "#f0f0f0"
                    onReleased: heatOffButton.color = "#33aaff"
                }
            }

            Rectangle {
                id: heatAutoButton
                color: "#33aaff"
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Auto")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: heatAuto()
                    onPressed: heatAutoButton.color = "#f0f0f0"
                    onReleased: heatAutoButton.color = "#33aaff"
                }
            }
        }
    }

    Rectangle {
        id: buttonBox2
        color: "#0096ff"
        anchors.bottom: parent.bottom
        width: parent.width
        height: 48 * guiScale

        Row {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            Rectangle {
                id: cancelButton
                color: "#33aaff"
                width: (parent.width - parent.spacing) / 2
                height: parent.height

                Text {
                    text: qsTr("Cancel")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: cancel()
                    onPressed: cancelButton.color = "#f0f0f0"
                    onReleased: cancelButton.color = "#33aaff"
                }
            }

            Rectangle {
                id: setupButton
                color: "#33aaff"
                width: (parent.width - parent.spacing) / 2
                height: parent.height

                Text {
                    text: qsTr("Set")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: setup()
                    onPressed: setupButton.color = "#f0f0f0"
                    onReleased: setupButton.color = "#33aaff"
                }
            }
        }
    }
}
