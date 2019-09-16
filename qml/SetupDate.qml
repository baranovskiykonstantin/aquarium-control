import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: setupDate
    color: "transparent"

    onOpacityChanged: {
        if (opacity == 1) {
            var matchRes = aquarium.date.match(
                new RegExp("(\\d{2}).(\\d{2}).(\\d{2})", "m")
            )
            itemDaySpinbox.value = matchRes[1]
            itemMonthSpinbox.value = matchRes[2]
            itemYearSpinbox.value = matchRes[3]
            itemDayOfWeekSpinbox.value = daysOfWeek.indexOf(aquarium.dayOfWeek) + 1
        }
    }

    property var daysOfWeek: [
        qsTr("Monday"),
        qsTr("Tuesday"),
        qsTr("Wednesday"),
        qsTr("Thursday"),
        qsTr("Friday"),
        qsTr("Saturday"),
        qsTr("Sunday")
    ]

    function dayOfWeekToInt(name) {
        switch (name) {
            case "Monday": return 1
            case "Tuesday": return 2
            case "Wednesday": return 3
            case "Thursday": return 4
            case "Friday": return 5
            case "Saturday": return 6
            case "Sunday": return 7
        }
    }

    function cancel() {
        mainWindow.state = "gui"
    }

    function setupCurrent() {
        var currentDate = new Date().toLocaleString(Qt.locale("en_US"), "dd.MM.yy")
        var currentDayOfWeek = new Date().toLocaleString(Qt.locale("en_US"), "dddd")
        mainWindow.sendToAquarium(
            "date %1 %2"
            .arg(currentDate)
            .arg(dayOfWeekToInt(currentDayOfWeek))
            )
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr(
            "Date %1 %2 has been set successfully.")
            .arg(currentDate)
            .arg(daysOfWeek[dayOfWeekToInt(currentDayOfWeek) - 1])
        )
        cancel()
    }

    function setup() {
        mainWindow.sendToAquarium(
            "date %1.%2.%3 %4"
            .arg(("00" + itemDaySpinbox.value).slice(-2))
            .arg(("00" + itemMonthSpinbox.value).slice(-2))
            .arg(("00" + itemYearSpinbox.value).slice(-2))
            .arg(itemDayOfWeekSpinbox.value)
        )
        mainWindow.sendToAquarium("status")
        messageBox.setText(qsTr(
            "Date %1.%2.%3 %4 has been set successfully.")
            .arg(("00" + itemDaySpinbox.value).slice(-2))
            .arg(("00" + itemMonthSpinbox.value).slice(-2))
            .arg(("00" + itemYearSpinbox.value).slice(-2))
            .arg(daysOfWeek[itemDayOfWeekSpinbox.value - 1])
        )
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
            text: qsTr("Date setup")
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
                id: itemDay
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemDayBackgound
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemDayLabelText
                    text: qsTr("Day")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemDaySpinbox.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemDaySpinbox
                    from: 1
                    to: 31
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemDay.height
                }
            }

            Item {
                id: itemMonth
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemMonthBackgound
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemMonthLabelText
                    text: qsTr("Month")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemMonthSpinbox.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemMonthSpinbox
                    from: 1
                    to: 12
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemMonth.height
                }
            }

            Item {
                id: itemYear
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemYearBackgound
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemYearLabelText
                    text: qsTr("Year")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemYearSpinbox.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemYearSpinbox
                    from: 0
                    to: 99
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemYear.height
                }
            }

            Item {
                id: itemDayOfWeek
                width: parent.width
                height: mmTOpx(10)

                Rectangle {
                    id: itemDayOfWeekBackgound
                    anchors.fill: parent
                    color: colors.itemBackground
                }

                Text {
                    id: itemDayOfWeekLabelText
                    text: qsTr("Day of the week")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemDayOfWeekSpinbox.right
                    anchors.leftMargin: mmTOpx(1)
                    color: colors.itemText
                    font.pixelSize: mmTOpx(3.5)
                    wrapMode: Text.Wrap
                }

                SpinCtrl {
                    id: itemDayOfWeekSpinbox
                    value: 1
                    from: 1
                    to: 7
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: itemDayOfWeek.height

                    textFromValue: function (value) {
                        return daysOfWeek[value - 1]
                    }

                    valueFromText: function (text) {
                        for (var i = 0; i < daysOfWeek.length; i++) {
                            if (daysOfWeek[i].indexOf(text) === 0) {
                                return i + 1
                            }
                        }
                        return 1 // default
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
                    text: qsTr("Set current date")
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
