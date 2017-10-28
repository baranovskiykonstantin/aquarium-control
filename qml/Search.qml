import QtQuick 2.0
import QtQuick.Window 2.0

Rectangle {
    id: searchBox
    width: searchText.width;
    height: searchText.height + bluetoothImage.height;
    color: "transparent"

    function setText(newText) {
        searchText.text = newText
    }

    Behavior on height {
        NumberAnimation { duration: 300 }
    }

    Image {
        id: bluetoothImage
        focus: true
        source: "../icons/bt.svg"
        width: mmTOpx(8)
        height: width
        fillMode: Image.Stretch

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        RotationAnimation on rotation{
            id: ranimation
            target: bluetoothImage
            easing.type: Easing.InOutBack
            property: "rotation"
            from: 0
            to: 360
            duration: 2000
            loops: Animation.Infinite
            alwaysRunToEnd: true
            running: true
        }
    }

    Text {
        id: searchText

        anchors.top: bluetoothImage.bottom
        anchors.topMargin: mmTOpx(5)
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Aquarium control"
        horizontalAlignment: Text.AlignHCenter
        color: colors.itemText
        font.pixelSize: mmTOpx(4)
    }
}

