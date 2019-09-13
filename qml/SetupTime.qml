import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: setupTime
    color: "transparent"

    onOpacityChanged: {
        if (opacity == 1) {
            var matchRes = aquarium.time.toString().match(new RegExp("(\\d{2}):(\\d{2}):(\\d{2})", "m"))
            itemHoursSpinbox.value = matchRes[1]
            itemMinutesSpinbox.value = matchRes[2]
            itemSecondsSpinbox.value = matchRes[3]
            itemCorrectionSpinbox.value = aquarium.correction
        }
    }

    function cancel() {
        mainWindow.state = "gui"
    }

    function setupCurrent() {
        var currentTime = new Date().toLocaleString(Qt.locale("en_US"), "HH:mm:ss")
        mainWindow.sendToAquarium(
            "time %1 %2"
            .arg(currentTime)
            .arg(itemCorrectionSpinbox.getFormattedValue())
            )
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr("Time %1 with correction %2 sec. has been set successfully.")
                           .arg(currentTime)
                           .arg(itemCorrectionSpinbox.value)
                           )
    }

    function setup() {
        mainWindow.sendToAquarium(
            "time %1:%2:%3 %4"
            .arg(("00" + itemHoursSpinbox.value).slice(-2))
            .arg(("00" + itemMinutesSpinbox.value).slice(-2))
            .arg(("00" + itemSecondsSpinbox.value).slice(-2))
            .arg(itemCorrectionSpinbox.getFormattedValue())
            )
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr("Time %1:%2:%3 with correction %4 sec. has been set successfully.")
                           .arg(("00" + itemHoursSpinbox.value).slice(-2))
                           .arg(("00" + itemMinutesSpinbox.value).slice(-2))
                           .arg(("00" + itemSecondsSpinbox.value).slice(-2))
                           .arg(itemCorrectionSpinbox.value)
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
            text: qsTr("Time setup")
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

            Item {
                id: itemCorrection
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemCorrectionBackgound
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemCorrectionLabelText
                    text: qsTr("Time correction")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemCorrectionSpinbox.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemCorrectionSpinbox
                    from: -59
                    to: 59
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemCorrection.height

                    function getFormattedValue() {
                        var correctionStr = ""
                        var absCorrectionValue = Math.abs(parseInt(itemCorrectionSpinbox.value, 10))
                        if (itemCorrectionSpinbox.value >= 0) {
                            correctionStr = "+"
                        }
                        else {
                            correctionStr = "-"
                        }
                        correctionStr += ("00" + absCorrectionValue).slice(-2)
                        return correctionStr
                    }
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
                id: setupCurrentButton
                color: colors.buttonBackground
                width: (parent.width - 2 * parent.spacing) / 3
                height: parent.height

                Text {
                    text: qsTr("Set current time")
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: colors.buttonText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.WordWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: setupCurrent()
                    onPressed: setupCurrentButton.color = colors.buttonPressed
                    onReleased: setupCurrentButton.color = colors.buttonBackground
                }
            }

            Rectangle {
                id: setupButton
                color: colors.buttonBackground
                width: (parent.width - 2 * parent.spacing) / 3
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
                width: (parent.width - 2 * parent.spacing) / 3
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
