import QtQuick 2.0
import QtQuick.Controls 2.1

Rectangle {
    id: setupTime
    color: "transparent"

    onOpacityChanged: {
        if (opacity == 1) {
            var matchRes = time.toString().match(new RegExp("(\\d{2}):(\\d{2}):(\\d{2})", "m"))
            itemHoursSpinbox.value = matchRes[1]
            itemMinutesSpinbox.value = matchRes[2]
            itemSecondsSpinbox.value = matchRes[3]
            itemCorrectionSpinbox.value = correction
        }
    }

    function cancel () {
        mainItem.state = "gui"
    }

    function setupCurrent () {
        var currentTime = new Date().toLocaleString(Qt.locale("en_US"), "HH:mm:ss")
        cmdBox.appendText('\n')
        socket.stringData = "time %1 %2\r"
        .arg(currentTime)
        .arg(itemCorrectionSpinbox.getFormattedValue())
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Time %1 with correction %2 was set successfull.")
                           .arg(currentTime)
                           .arg(itemCorrectionSpinbox.value)
                           )
    }

    function setup () {
        cmdBox.appendText('\n')
        socket.stringData = "time %1:%2:%3 %4\r"
        .arg(("00" + itemHoursSpinbox.value).slice(-2))
        .arg(("00" + itemMinutesSpinbox.value).slice(-2))
        .arg(("00" + itemSecondsSpinbox.value).slice(-2))
        .arg(itemCorrectionSpinbox.getFormattedValue())
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Time %1:%2:%3 with correction %4 was set successfull.")
                           .arg(("00" + itemHoursSpinbox.value).slice(-2))
                           .arg(("00" + itemMinutesSpinbox.value).slice(-2))
                           .arg(("00" + itemSecondsSpinbox.value).slice(-2))
                           .arg(itemCorrectionSpinbox.value)
                           )
    }

    Flickable {
        width: parent.width - 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom
        anchors.bottom: buttonBox.top
        contentWidth: width
        contentHeight: itemColumn.childrenRect.height
        boundsBehavior: Flickable.OvershootBounds

        Column {
            id: itemColumn
            width: parent.width
            spacing: 5

            Item {
                id: itemHours
                width: parent.width
                height: 52 * guiScale

                Rectangle {
                    id: itemHoursBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemHoursLabelText
                    text: qsTr("Hours")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemHoursSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
                    id: itemHoursSpinbox
                    from: 0
                    to: 23
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemHours.height
                }
            }

            Item {
                id: itemMinutes
                width: parent.width
                height: 52 * guiScale

                Rectangle {
                    id: itemMinutesBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemMinutesLabelText
                    text: qsTr("Minutes")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemMinutesSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
                    id: itemMinutesSpinbox
                    from: 0
                    to: 59
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemMinutes.height
                }
            }

            Item {
                id: itemSeconds
                width: parent.width
                height: 52 * guiScale

                Rectangle {
                    id: itemSecondsBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemSecondsLabelText
                    text: qsTr("Seconds")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemSecondsSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
                    id: itemSecondsSpinbox
                    from: 0
                    to: 59
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemSeconds.height
                }
            }

            Item {
                id: itemCorrection
                width: parent.width
                height: 52 * guiScale

                Rectangle {
                    id: itemCorrectionBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemCorrectionLabelText
                    text: qsTr("Time correction")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemCorrectionSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
                    id: itemCorrectionSpinbox
                    from: -59
                    to: 59
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemCorrection.height

                    function getFormattedValue () {
                        var correctionStr = ""
                        var absCorrectionValue = Math.abs(parseInt(itemCorrectionSpinbox.value, 10))
                        if (itemCorrectionSpinbox.value >= 0)
                            correctionStr = "+"
                        else
                            correctionStr = "-"
                        correctionStr += ("00" + absCorrectionValue).slice(-2)
                        return correctionStr
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
            text: qsTr("Time setup")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#1e1e1e"
            font.pointSize: 11
        }
    }

    Rectangle {
        id: buttonBox
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
                width: (parent.width - 2 * parent.spacing) / 3
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
                id: setupCurrentButton
                color: "#33aaff"
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Set current time")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: setupCurrent()
                    onPressed: setupCurrentButton.color = "#f0f0f0"
                    onReleased: setupCurrentButton.color = "#33aaff"
                }
            }

            Rectangle {
                id: setupButton
                color: "#33aaff"
                width: (parent.width - 2 * parent.spacing) / 3
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
