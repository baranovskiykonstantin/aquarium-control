import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: setupLightTime
    color: "transparent"

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

    property string timeType: "on" // "off"

    function cancel() {
        mainWindow.state = "setupLight"
    }

    function ok() {
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
                messageBox.setText(qsTr("Time of turn on must be less than time of turn off."))
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
                messageBox.setText(qsTr("Time of turn off must be bigger than time of turn on."))
                messageBox.show()
            }
            break
        }

        setupLightBox.initOnOpacityCahnged = false
        cancel()
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
        anchors.bottom: buttonBox.top
        contentWidth: width
        contentHeight: itemColumn.childrenRect.height
        boundsBehavior: Flickable.OvershootBounds

        Column {
            id: itemColumn
            width: parent.width
            spacing: mmTOpx(1)

            Item {
                id: itemHours
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemHoursBackgound
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemHoursLabelText
                    text: qsTr("Hours")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemHoursSpinbox.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
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
                height: mmTOpx(10)

                Rectangle {
                    id: itemMinutesBackgound
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemMinutesLabelText
                    text: qsTr("Minutes")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemMinutesSpinbox.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
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
                height: mmTOpx(10)

                Rectangle {
                    id: itemSecondsBackgound
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemSecondsLabelText
                    text: qsTr("Seconds")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemSecondsSpinbox.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemSecondsSpinbox
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
        id: buttonBox
        color: colors.background
        anchors.bottom: parent.bottom
        width: parent.width
        height: mmTOpx(10)

        Row {
            anchors.fill: parent
            anchors.margins: mmTOpx(1)
            spacing: mmTOpx(1)

            Rectangle {
                id: okButton
                color: colors.buttonBackground
                width: (parent.width - parent.spacing) / 2
                height: parent.height

                Text {
                    text: qsTr("OK")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colors.buttonText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: ok()
                    onPressed: okButton.color = colors.buttonPressed
                    onReleased: okButton.color = colors.buttonBackground
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
