import QtQuick 2.4
import QtQuick.Controls 2.0

SpinBox {
    id: control
    value: 50
    editable: false
    font.pixelSize: mmTOpx(3.5)

    contentItem: Text {
        id: textValue
        z: 2
        text: control.textFromValue(control.value, control.locale)
        height: control.height

        font: control.font
        color: colors.itemText
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
            if (control.width < (control.height * 3)) {
                control.width = control.height * 3
            }
            if (control.value == control.to) {
                upIndicatorText.color = colors.background
            }
            else {
                upIndicatorText.color = colors.itemText
            }
            if (control.value == control.from) {
                downIndicatorText.color = colors.background
            }
            else {
                downIndicatorText.color = colors.itemText
            }
        }
    }

    up.indicator: Rectangle {
        id: upIndicator
        x: control.mirrored ? 0 : parent.width - width
        height: control.height
        width: control.height
        color: up.pressed ? colors.itemPressed : colors.itemBackground

        Text {
            id: upIndicatorText
            text: "+"
            font.pixelSize: control.font.pixelSize * 2
            color: colors.buttonText
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
        color: down.pressed ? colors.itemPressed : colors.itemBackground

        Text {
            id: downIndicatorText
            text: "−"
            font.pixelSize: control.font.pixelSize * 2
            color: colors.buttonText
            anchors.fill: parent
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        color: colors.background
        height: mmTOpx(8)
        width: mmTOpx(0.5)
        anchors.verticalCenter: downIndicator.verticalCenter
        anchors.left: downIndicator.right
    }

    Rectangle {
        color: colors.background
        height: mmTOpx(8)
        width: mmTOpx(0.5)
        anchors.verticalCenter: upIndicator.verticalCenter
        anchors.right: upIndicator.left
    }

    background: Rectangle {
        color: colors.itemBackground
    }
}
