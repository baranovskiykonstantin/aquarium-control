import QtQuick 2.6
import QtQuick.Controls 2.1

SpinBox {
    id: control
    value: 50
    editable: true
    font.pointSize: 11

    contentItem: TextInput {
        id: textInput
        z: 2
        text: control.textFromValue(control.value, control.locale)
        height: control.height

        font: control.font
        color: "#1e1e1e"
        selectionColor: "#1e1e1e"
        selectedTextColor: "#f0f0f0"
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: Qt.ImhFormattedNumbersOnly

        TextMetrics {
            id: textMetrics
            font: control.font
        }

        onTextChanged: {
            textMetrics.text = textInput.text + "W"
            control.width = textMetrics.width + control.height * 2 * guiScale
            if (control.width < (control.height * 3 * guiScale))
                control.width = control.height * 3 * guiScale
        }
    }

    up.indicator: Rectangle {
        id: upIndicator
        x: control.mirrored ? 0 : parent.width - width
        height: control.height
        width: control.height
        color: up.pressed ? "#f0f0f0" : "#e0e0e0"

        Text {
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
        color: down.pressed ? "#f0f0f0" : "#e0e0e0"

        Text {
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
}
