import QtQuick 2.0
import QtQuick.Controls 2.0

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

    function cancel() {
        mainWindow.state = "gui"
    }

    function heatOn() {
        mainWindow.sendToAquarium("heat on")
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr("Heater has been turned on manually."))
    }

    function heatOff() {
        mainWindow.sendToAquarium("heat off")
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr("Heater has been turned off manually."))
    }

    function heatAuto() {
        mainWindow.sendToAquarium("heat auto")
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr("Heater has been set to automatic mode."))
    }

    function setup() {
        mainWindow.sendToAquarium(
            "heat %1-%2"
            .arg(("00" + itemMinTempSpinbox.value).slice(-2))
            .arg(("00" + itemMaxTempSpinbox.value).slice(-2))
            )
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr("Water temperature will be maintained in range %1-%2 °C.")
                           .arg(("00" + itemMinTempSpinbox.value).slice(-2))
                           .arg(("00" + itemMaxTempSpinbox.value).slice(-2))
                           )
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
            text: qsTr("Heat setup")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.headerText
            font.pixelSize: mmTOpx(4)
        }
    }

    Flickable {
        width: parent.width - mmTOpx(2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom
        anchors.bottom: buttonBox1.top
        contentWidth: width
        contentHeight: itemColumn.childrenRect.height
        boundsBehavior: Flickable.OvershootBounds

        Column {
            id: itemColumn
            width: parent.width
            spacing: mmTOpx(1)

            Item {
                id: itemMinTemp
                width: parent.width
                height: mmTOpx(10)

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
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemMinTempSpinbox
                    value: 22
                    from: 18
                    to: 35
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemMinTemp.height

                    onValueChanged: {
                        if (value > itemMaxTempSpinbox.value) {
                            itemMaxTempSpinbox.value = value
                        }
                    }
                }
            }

            Item {
                id: itemMaxTemp
                width: parent.width
                height: mmTOpx(10)

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
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemMaxTempSpinbox
                    from: 18
                    to: 35
                    value: 25
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemMaxTemp.height

                    onValueChanged: {
                        if (value < itemMinTempSpinbox.value) {
                            itemMinTempSpinbox.value = value
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: buttonBox1
        color: colors.background
        anchors.bottom: buttonBox2.top
        width: parent.width
        height: mmTOpx(10)

        Row {
            anchors.fill: parent
            anchors.margins: mmTOpx(1)
            anchors.bottomMargin: 0
            spacing: mmTOpx(1)

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
                    font.pixelSize: mmTOpx(3.5)
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
                    font.pixelSize: mmTOpx(3.5)
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
                    font.pixelSize: mmTOpx(3.5)
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
        height: mmTOpx(10)

        Row {
            anchors.fill: parent
            anchors.margins: mmTOpx(1)
            spacing: mmTOpx(1)

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
                    font.pixelSize: mmTOpx(3.5)
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
}
