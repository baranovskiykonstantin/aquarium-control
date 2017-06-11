import QtQuick 2.0
import QtQuick.Controls 2.1

Rectangle {
    id: setupDate
    color: "transparent"

    onOpacityChanged: {
        if (opacity == 1) {
            var matchRes = date.toString().match(new RegExp("(\\d{2}).(\\d{2}).(\\d{2})", "m"))
            itemDaySpinbox.value = matchRes[1]
            itemMonthSpinbox.value = matchRes[2]
            itemYearSpinbox.value = matchRes[3]
            itemDayOfWeekSpinbox.value = daysOfWeek.indexOf(dayOfWeek) + 1
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

    function dayOfWeekToInt (name) {
        switch (name) {
        case "Monday":
            return 1
        case "Tuesday":
            return 2
        case "Wednesday":
            return 3
        case "Thursday":
            return 4
        case "Friday":
            return 5
        case "Saturday":
            return 6
        case "Sunday":
            return 7
        }
    }

    function cancel () {
        mainItem.state = "gui"
    }

    function setupCurrent () {
        var currentDate = new Date().toLocaleString(Qt.locale("en_US"), "dd.MM.yy")
        var currentDayOfWeek = new Date().toLocaleString(Qt.locale("en_US"), "dddd")
        cmdBox.appendText('\n')
        socket.stringData = "date %1 %2\r"
        .arg(currentDate)
        .arg(dayOfWeekToInt(currentDayOfWeek))
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Date %1 %2 was set successfull.")
                           .arg(currentDate)
                           .arg(daysOfWeek[dayOfWeekToInt(currentDayOfWeek) - 1])
                           )
    }

    function setup () {
        cmdBox.appendText('\n')
        socket.stringData = "date %1.%2.%3 %4\r"
        .arg(("00" + itemDaySpinbox.value).slice(-2))
        .arg(("00" + itemMonthSpinbox.value).slice(-2))
        .arg(("00" + itemYearSpinbox.value).slice(-2))
        .arg(itemDayOfWeekSpinbox.value)
        socket.stringData = "status\r"
        messageBox.setText(qsTr("Date %1.%2.%3 %4 was set successfull.")
                           .arg(("00" + itemDaySpinbox.value).slice(-2))
                           .arg(("00" + itemMonthSpinbox.value).slice(-2))
                           .arg(("00" + itemYearSpinbox.value).slice(-2))
                           .arg(daysOfWeek[itemDayOfWeekSpinbox.value - 1])
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
                id: itemDay
                width: parent.width
                height: 52 * guiScale

                Rectangle {
                    id: itemDayBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemDayLabelText
                    text: qsTr("Day")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemDaySpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
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
                height: 52 * guiScale

                Rectangle {
                    id: itemMonthBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemMonthLabelText
                    text: qsTr("Month")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemMonthSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
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
                height: 52 * guiScale

                Rectangle {
                    id: itemYearBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemYearLabelText
                    text: qsTr("Year")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemYearSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
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
                height: 52 * guiScale

                Rectangle {
                    id: itemDayOfWeekBackgound
                    anchors.fill: parent
                    color: "#33aaff"
                }

                Text {
                    id: itemDayOfWeekLabelText
                    text: qsTr("Day of week")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: itemDayOfWeekSpinbox.right
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    color: "#1e1e1e"
                    font.pointSize: 11
                    wrapMode: Text.Wrap
                }

                MySpinBox {
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
                            if (daysOfWeek[i].indexOf(text) === 0)
                                return i + 1
                        }
                        return 1 // default
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
            text: qsTr("Date setup")
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
                    text: qsTr("Set current date")
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
