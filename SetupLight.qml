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
                var matchRes = light.toString().match(new RegExp("(\\d+:\\d+:\\d+)-(\\d+:\\d+:\\d+)", "m"))
                itemLightOnValue.text = matchRes[1]
                itemLightOffValue.text = matchRes[2]
                itemBrightnessSpinbox.value = lightLevel
                initOnOpacityCahnged = true
            }
        }
        initOnOpacityCahnged = true
    }

    function cancel () {
        mainItem.state = "gui"
    }

    function lightOn () {
        cmdBox.appendText('\n')
        socket.stringData = "light on\r"
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Light was turned on manually."))
    }

    function lightOff () {
        cmdBox.appendText('\n')
        socket.stringData = "light off\r"
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Light was turned off manually."))
    }

    function lightAuto () {
        cmdBox.appendText('\n')
        socket.stringData = "light auto\r"
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Light was set to automatic mode."))
    }

    function setup () {
        cmdBox.appendText('\n')
        socket.stringData = "light %1-%2 %3\r"
        .arg(itemLightOnValue.text)
        .arg(itemLightOffValue.text)
        .arg(("000" + itemBrightnessSpinbox.value).slice(-3))
        socket.stringData = "status\r"
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
                    id: itemLightOnBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemLightOnLabelText
                    text: qsTr("Turn on time")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemLightOnValue.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                Text {
                    id: itemLightOnValue
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        setupLightTimeBox.timeType = "on"
                        mainItem.state = "setupLightTime"
                    }
                }
            }

            Item {
                id: itemLightOff
                width: parent.width
                height: 52 * guiScale

                Rectangle {
                    id: itemLightOffBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemLightOffLabelText
                    text: qsTr("Turn off time")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemLightOffValue.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                Text {
                    id: itemLightOffValue
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        setupLightTimeBox.timeType = "off"
                        mainItem.state = "setupLightTime"
                    }
                }
            }

            Item {
                id: itemBrightness
                width: parent.width
                height: 52 * guiScale

                Rectangle {
                    id: itemBrightnessBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemBrightnessLabelText
                    text: qsTr("Brightness")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemBrightnessSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
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
            text: qsTr("Light setup")
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
        height: 48 * guiScale

        Row {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 5
            spacing: 5

            Rectangle {
                id: lightOnButton
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
                    onClicked: lightOn()
                    onPressed: lightOnButton.color = "#f0f0f0"
                    onReleased: lightOnButton.color = "#33aaff"
                }
            }

            Rectangle {
                id: lightOffButton
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
                    onClicked: lightOff()
                    onPressed: lightOffButton.color = "#f0f0f0"
                    onReleased: lightOffButton.color = "#33aaff"
                }
            }

            Rectangle {
                id: lightAutoButton
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
                    onClicked: lightAuto()
                    onPressed: lightAutoButton.color = "#f0f0f0"
                    onReleased: lightAutoButton.color = "#33aaff"
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
        }
    }
}
