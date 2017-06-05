import QtQuick 2.0
import QtQuick.Controls 2.1

Rectangle {
    id: setupLightTime
    color: "transparent"

    property string timeType: "on" // "off"

    onOpacityChanged: {
        if (opacity == 1) {
            var matchRes = ["","","",""]

            switch (timeType) {
            case "on":
                headerText.text = qsTr("Time of turn on the light")
                matchRes = setupLightBox.timeOn.toString().match(new RegExp("(\\d{2}):(\\d{2}):(\\d{2})", "m"))
                break
            case "off":
                headerText.text = qsTr("Time of turn off the light")
                matchRes = setupLightBox.timeOff.toString().match(new RegExp("(\\d{2}):(\\d{2}):(\\d{2})", "m"))
                break
            }

            itemHoursSpinbox.value = matchRes[1]
            itemMinutesSpinbox.value = matchRes[2]
            itemSecondsSpinbox.value = matchRes[3]
        }
    }

    function cancel () {
        mainItem.state = "setupLight"
    }

    function ok () {
        var onTimeSec, offTimeSec, matchRes

        switch (timeType) {
        case "on":
            matchRes = setupLightBox.timeOff.toString().match(new RegExp("(\\d{2}):(\\d{2}):(\\d{2})", "m"))
            onTimeSec = itemHoursSpinbox.value * 3600 + itemMinutesSpinbox.value * 60 + itemSecondsSpinbox.value
            offTimeSec = matchRes[1] * 3600 + matchRes[2] * 60 + matchRes[3] * 1
            if (onTimeSec < offTimeSec) {
                setupLightBox.timeOn = "%1:%2:%3"
                .arg(("00" + itemHoursSpinbox.value).slice(-2))
                .arg(("00" + itemMinutesSpinbox.value).slice(-2))
                .arg(("00" + itemSecondsSpinbox.value).slice(-2))
            }
            else {
                messageBox.setText(qsTr("Time of turn on cannot be bigger than time of turn off."))
                messageBox.show()
            }
            break
        case "off":
            matchRes = setupLightBox.timeOn.toString().match(new RegExp("(\\d{2}):(\\d{2}):(\\d{2})", "m"))
            onTimeSec = matchRes[1] * 3600 + matchRes[2] * 60 + matchRes[3] * 1
            offTimeSec = itemHoursSpinbox.value * 3600 + itemMinutesSpinbox.value * 60 + itemSecondsSpinbox.value
            if (offTimeSec > onTimeSec) {
                setupLightBox.timeOff = "%1:%2:%3"
                .arg(("00" + itemHoursSpinbox.value).slice(-2))
                .arg(("00" + itemMinutesSpinbox.value).slice(-2))
                .arg(("00" + itemSecondsSpinbox.value).slice(-2))
            }
            else {
                messageBox.setText(qsTr("Time of turn off cannot be less than time of turn on."))
                messageBox.show()
            }
            break
        }

        setupLightBox.initOnOpacityCahnged = false
        cancel()
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
                    editable: true
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
                    editable: true
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
                    editable: true
                    from: 0
                    to: 59
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemSeconds.height
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
                id: okButton
                color: "#33aaff"
                width: (parent.width - parent.spacing) / 2
                height: parent.height

                Text {
                    text: qsTr("OK")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: ok()
                    onPressed: okButton.color = "#f0f0f0"
                    onReleased: okButton.color = "#33aaff"
                }
            }
        }
    }
}
