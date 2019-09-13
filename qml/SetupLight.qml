import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: setupLight
    color: "transparent"

    onOpacityChanged: {
        if (opacity == 1) {
            if (initOnOpacityCahnged) {
                var matchRes = aquarium.light.toString().match(new RegExp("(\\d+:\\d+:\\d+)-(\\d+:\\d+:\\d+)", "m"))
                itemLightOnValue.text = matchRes[1]
                itemLightOffValue.text = matchRes[2]
                itemBrightnessSpinbox.value = aquarium.lightLevel
                itemRiseSpinbox.value = aquarium.riseTime
                initOnOpacityCahnged = true
            }
        }
        initOnOpacityCahnged = true
    }

    property alias timeOn: itemLightOnValue.text
    property alias timeOff: itemLightOffValue.text
    property bool initOnOpacityCahnged: true

    function cancel() {
        mainWindow.state = "gui"
    }

    function lightOn() {
        mainWindow.sendToAquarium("light on")
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr("Light has been turned on manually."))
    }

    function lightOff() {
        mainWindow.sendToAquarium("light off")
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr("Light has been turned off manually."))
    }

    function lightAuto() {
        mainWindow.sendToAquarium("light auto")
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr("Light has been set to automatic mode."))
    }

    function setup() {
        mainWindow.sendToAquarium(
            "light %1-%2 %3 %4"
            .arg(itemLightOnValue.text)
            .arg(itemLightOffValue.text)
            .arg(("000" + itemBrightnessSpinbox.value).slice(-3))
            .arg(("00" + itemRiseSpinbox.value).slice(-2))
            )
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr("Light will turn on at %1 o'clock with brightness %3% and turn off at %2 o'clock.\nLight will rise/fall in %4 minutes.")
                           .arg(itemLightOnValue.text)
                           .arg(itemLightOffValue.text)
                           .arg(itemBrightnessSpinbox.value)
                           .arg(itemRiseSpinbox.value)
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
            text: qsTr("Light setup")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.headerText
            font.pixelSize: mmTOpx(3.5)
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
                id: itemLightOn
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemLightOnBackground
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemLightOnLabelText
                    text: qsTr("Turn on time")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemLightOnValue.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                Text {
                    id: itemLightOnValue
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.leftMargin: mmTOpx(1)
                    anchors.rightMargin: anchors.leftMargin
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        setupLightTimeBox.timeType = "on"
                        mainWindow.state = "setupLightTime"
                    }
                    onPressed: itemLightOnBackground.color = colors.itemPressed
                    onReleased: itemLightOnBackground.color = colors.itemBackground
                    onCanceled: itemLightOnBackground.color = colors.itemBackground
                }
            }

            Item {
                id: itemLightOff
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemLightOffBackground
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemLightOffLabelText
                    text: qsTr("Turn off time")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemLightOffValue.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                Text {
                    id: itemLightOffValue
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.leftMargin: mmTOpx(1)
                    anchors.rightMargin: anchors.leftMargin
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        setupLightTimeBox.timeType = "off"
                        mainWindow.state = "setupLightTime"
                    }
                    onPressed: itemLightOffBackground.color = colors.itemPressed
                    onReleased: itemLightOffBackground.color = colors.itemBackground
                    onCanceled: itemLightOffBackground.color = colors.itemBackground
                }
            }

            Item {
                id: itemBrightness
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemBrightnessBackground
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemBrightnessLabelText
                    text: qsTr("Brightness")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemBrightnessSpinbox.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemBrightnessSpinbox
                    from: 0
                    to: 100
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemBrightness.height
                }
            }

            Item {
                id: itemRise
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemRiseBackground
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemRiseLabelText
                    text: qsTr("Rise time")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemRiseSpinbox.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemRiseSpinbox
                    from: 0
                    to: 30
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemRise.height
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
                id: lightOnButton
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
                    onClicked: lightOn()
                    onPressed: lightOnButton.color = colors.buttonPressed
                    onReleased: lightOnButton.color = colors.buttonBackground
                }
            }

            Rectangle {
                id: lightOffButton
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
                    onClicked: lightOff()
                    onPressed: lightOffButton.color = colors.buttonPressed
                    onReleased: lightOffButton.color = colors.buttonBackground
                }
            }

            Rectangle {
                id: lightAutoButton
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
                    onClicked: lightAuto()
                    onPressed: lightAutoButton.color = colors.buttonPressed
                    onReleased: lightAutoButton.color = colors.buttonBackground
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
