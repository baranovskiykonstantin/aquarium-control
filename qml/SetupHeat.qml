import QtQuick 2.0
import QtQuick.Controls 2.1

Rectangle {
    id: setupHeat
    color: "transparent"

    onOpacityChanged: {
        if (opacity == 1) {
            var matchRes = aquarium.heat.toString().match(new RegExp("(\\d+)-(\\d+)", "m"))
            itemMinTempSpinbox.value = matchRes[1]
            itemMaxTempSpinbox.value = matchRes[2]
        }
    }

    function cancel () {
        mainWindow.state = "gui"
    }

    function heatOn () {
        cmdBox.appendText('\n')
        mainWindow.sendToAquarium("heat on\r")
        mainWindow.sendToAquarium("status\r")
        messageBox.setText(qsTr("Heater was turned on manually."))
    }

    function heatOff () {
        cmdBox.appendText('\n')
        mainWindow.sendToAquarium("heat off\r")
        mainWindow.sendToAquarium("status\r")
        messageBox.setText(qsTr("Heater was turned off manually."))
    }

    function heatAuto () {
        cmdBox.appendText('\n')
        mainWindow.sendToAquarium("heat auto\r")
        mainWindow.sendToAquarium("status\r")
        messageBox.setText(qsTr("Heater was set to automatic mode."))
    }

    function setup () {
        cmdBox.appendText('\n')
        mainWindow.sendToAquarium(
            "heat %1-%2\r"
            .arg(("00" + itemMinTempSpinbox.value).slice(-2))
            .arg(("00" + itemMaxTempSpinbox.value).slice(-2))
            )
        mainWindow.sendToAquarium("status\r")
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
                    color: colors.itemBackground
                }

                Text {
                    id: itemMinTempLabelText
                    text: qsTr("Minimal temperature")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemMinTempSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: colors.itemText
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemMinTempSpinbox
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
                    color: colors.itemBackground
                }

                Text {
                    id: itemMaxTempLabelText
                    text: qsTr("Maximal temperature")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemMaxTempSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: colors.itemText
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemMaxTempSpinbox
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
        color: colors.background
        height: 48 * guiScale
        width: parent.width

        Rectangle {
            id: headerBackground
            color: colors.headerBackground
            width: parent.width
            height: parent.height - 5
        }

        Text {
            id: headerText
            text: qsTr("Heat setup")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.headerText
            font.pointSize: 11
        }
    }

    Rectangle {
        id: buttonBox1
        color: colors.background
        anchors.bottom: buttonBox2.top
        width: parent.width
        height: 48 * guiScale

        Row {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 5
            spacing: 5

            Rectangle {
                id: heatOnButton
                color: colors.buttonBackground
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Turn on")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colors.buttonText
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: heatOn()
                    onPressed: heatOnButton.color = colors.buttonPressed
                    onReleased: heatOnButton.color = colors.buttonBackground
                }
            }

            Rectangle {
                id: heatOffButton
                color: colors.buttonBackground
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Turn off")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colors.buttonText
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: heatOff()
                    onPressed: heatOffButton.color = colors.buttonPressed
                    onReleased: heatOffButton.color = colors.buttonBackground
                }
            }

            Rectangle {
                id: heatAutoButton
                color: colors.buttonBackground
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Auto")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colors.buttonText
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: heatAuto()
                    onPressed: heatAutoButton.color = colors.buttonPressed
                    onReleased: heatAutoButton.color = colors.buttonBackground
                }
            }
        }
    }

    Rectangle {
        id: buttonBox2
        color: colors.background
        anchors.bottom: parent.bottom
        width: parent.width
        height: 48 * guiScale

        Row {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            Rectangle {
                id: setupButton
                color: colors.buttonBackground
                width: (parent.width - parent.spacing) / 2
                height: parent.height

                Text {
                    text: qsTr("Set")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colors.buttonText
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: setup()
                    onPressed: setupButton.color = colors.buttonPressed
                    onReleased: setupButton.color = colors.buttonBackground
                }
            }

            Rectangle {
                id: cancelButton
                color: colors.buttonBackground
                width: (parent.width - parent.spacing) / 2
                height: parent.height

                Text {
                    text: qsTr("Cancel")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colors.buttonText
                    font.pointSize: 11
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
}
