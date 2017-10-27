import QtQuick 2.0
import QtQuick.Controls 2.1

Rectangle {
    id: setupLight
    color: "transparent"

    property alias timeOn: itemLightOnValue.text
    property alias timeOff: itemLightOffValue.text

    property bool initOnOpacityCahnged: true

    onOpacityChanged: {
        if (opacity == 1) {
            if (initOnOpacityCahnged) {
                var matchRes = aquarium.light.toString().match(new RegExp("(\\d+:\\d+:\\d+)-(\\d+:\\d+:\\d+)", "m"))
                itemLightOnValue.text = matchRes[1]
                itemLightOffValue.text = matchRes[2]
                itemBrightnessSpinbox.value = aquarium.lightLevel
                initOnOpacityCahnged = true
            }
        }
        initOnOpacityCahnged = true
    }

    function cancel () {
        mainWindow.state = "gui"
    }

    function lightOn () {
        cmdBox.appendText('\n')
        mainWindow.sendToAquarium("light on\r")
        mainWindow.sendToAquarium("status\r")
        messageBox.setText(qsTr("Light was turned on manually."))
    }

    function lightOff () {
        cmdBox.appendText('\n')
        mainWindow.sendToAquarium("light off\r")
        mainWindow.sendToAquarium("status\r")
        messageBox.setText(qsTr("Light was turned off manually."))
    }

    function lightAuto () {
        cmdBox.appendText('\n')
        mainWindow.sendToAquarium("light auto\r")
        mainWindow.sendToAquarium("status\r")
        messageBox.setText(qsTr("Light was set to automatic mode."))
    }

    function setup () {
        cmdBox.appendText('\n')
        mainWindow.sendToAquarium(
            "light %1-%2 %3\r"
            .arg(itemLightOnValue.text)
            .arg(itemLightOffValue.text)
            .arg(("000" + itemBrightnessSpinbox.value).slice(-3))
            )
        mainWindow.sendToAquarium("status\r")
        messageBox.setText(qsTr("Light will turn on at %1 o'clock with brightness %3% and turn off at %2 o'clock.")
                           .arg(itemLightOnValue.text)
                           .arg(itemLightOffValue.text)
                           .arg(itemBrightnessSpinbox.value)
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
                id: itemLightOn
                width: parent.width
                height: 52 * guiScale

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
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: colors.itemText
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                Text {
                    id: itemLightOnValue
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: colors.itemText
                    font.pointSize: 11
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
                height: 52 * guiScale

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
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: colors.itemText
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                Text {
                    id: itemLightOffValue
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: colors.itemText
                    font.pointSize: 11
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
                height: 52 * guiScale

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
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: colors.itemText
                    font.pointSize: 11
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
        }
    }

    Rectangle {
        id: header
        color: colors.background
        height: 64 * guiScale
        width: parent.width

        Rectangle {
            id: headerBackground
            color: colors.headerBackground
            width: parent.width
            height: parent.height - 5
        }

        Text {
            id: headerText
            text: qsTr("Light setup")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.headerText
            font.pointSize: 15
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
                    font.pointSize: 11
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
                    font.pointSize: 11
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
                    font.pointSize: 11
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
