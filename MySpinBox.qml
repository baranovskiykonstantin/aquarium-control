import QtQuick 2.6
import QtQuick.Controls 2.1

SpinBox {
    id: control
    value: 50
    editable: false
    font.pointSize: 11

    contentItem: Text {
        id: textValue
        z: 2
        text: control.textFromValue(control.value, control.locale)
        height: control.height

        font: control.font
        color: "#1e1e1e"
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        TextMetrics {
            id: textMetrics
            font: control.font
        }

        onTextChanged: {
            // To calculate correct text width needs to add an wide character (W).
            textMetrics.text = textValue.text + "W"
            control.width = textMetrics.width + control.height * 2
            if (control.width < (control.height * 3))
                control.width = control.height * 3
            if (control.value == control.to) {
                upIndicatorText.color = "#0096ff"
            }
            else {
                upIndicatorText.color = "#1e1e1e"
            }
            if (control.value == control.from) {
                downIndicatorText.color = "#0096ff"
            }
            else {
                downIndicatorText.color = "#1e1e1e"
            }
        }
    }

    up.indicator: Rectangle {
        id: upIndicator
        x: control.mirrored ? 0 : parent.width - width
        height: control.height
        width: control.height
        color: up.pressed ? "#f0f0f0" : "#33aaff"

        Text {
            id: upIndicatorText
            text: "+"
            font.pointSize: control.font.pointSize * 2
            font.family: "Droid Sans Mono"
            color: "#1e1e1e"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    down.indicator: Rectangle {
        id: downIndicator
        x: control.mirrored ? parent.width - width : 0
        height: control.height
        width: control.height
        color: down.pressed ? "#f0f0f0" : "#33aaff"

        Text {
            id: downIndicatorText
            text: "−"
            font.pointSize: control.font.pointSize * 2
            font.family: "Droid Sans Mono"
            color: "#1e1e1e"
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        color: "#0096ff"
        height: 36 * guiScale
        width: 2 * guiScale
        anchors.verticalCenter: downIndicator.verticalCenter
        anchors.left: downIndicator.right
    }

    Rectangle {
        color: "#0096ff"
        height: 36 * guiScale
        width: 2 * guiScale
        anchors.verticalCenter: upIndicator.verticalCenter
        anchors.right: upIndicator.left
    }

    background: Rectangle {
        color: "#33aaff"
    }
}
