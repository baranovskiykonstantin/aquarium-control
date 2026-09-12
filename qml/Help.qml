import QtQuick

Rectangle {
    id: helpBox
    color: "transparent"
    opacity: 0

    onOpacityChanged: {
        if (opacity === 1) {
            helpFlickable.contentY = 0
        }
    }

    function close() {
        mainWindow.state = "gui"
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
            text: qsTr("Aquarium control %1").arg(Qt.application.version)
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: colors.headerText
            font.pixelSize: mmTOpx(4)
        }
    }

    Flickable {
        id: helpFlickable
        width: parent.width - mmTOpx(2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom
        anchors.bottom: buttonBox.top
        contentWidth: width
        contentHeight: helpText.height
        boundsBehavior: Flickable.OvershootBounds
        clip: true

        Text {
            id: helpText
            width: parent.width
            wrapMode: Text.WordWrap
            textFormat: Text.StyledText
            color: colors.itemText
            font.pixelSize: mmTOpx(3.5)
            onLinkActivated: function(link) {
                Qt.openUrlExternally(link)
            }
            text: qsTr("<b>About</b><br/><br/>This application is designed to control the aquarium controller described at <a href=\"https://github.com/baranovskiykonstantin/aquarium\">https://github.com/baranovskiykonstantin/aquarium</a>. It lets you find a nearby aquarium over Bluetooth, view its current state, and change date, time, heating, lighting, and display settings.")
                + "<br/><br/>"
                + qsTr("<b>Finding an aquarium</b><br/><br/>When the app starts, it searches for Bluetooth devices whose name begins with \"aquarium\". Wait until the search finishes. If no aquarium is found, make sure the controller is available, Bluetooth is turned on, and the app is allowed to access nearby devices. The Cancel button stops the search and returns to the main window.")
                + "<br/><br/>"
                + qsTr("<b>Selecting an aquarium</b><br/><br/>If several aquariums are found, a list is shown. Each row shows the device name and its Bluetooth address. Tap a row to connect. Cancel returns to the main window without connecting.")
                + "<br/><br/>"
                + qsTr("<b>Main window</b><br/><br/>The header shows the connected aquarium name and address, or that the aquarium is disconnected. Tap the header to search for aquariums again. The help icon on the right opens this screen.<br/><br/>Tap a status row to open its settings:<br/><br/>• Date — current date and day of the week<br/>• Time — current time and daily time correction<br/>• Temp — water temperature; opens Heat setup<br/>• Heat — heater state, mode, and temperature range<br/>• Light — light state, mode, schedule, brightness, and rise time<br/>• Display — tap to switch what the aquarium display shows: time or temperature. There is no separate display settings screen.<br/><br/>Terminal opens text-command control of the controller. It is an alternative to the graphical interface.<br/><br/>Exit closes the application.")
                + "<br/><br/>"
                + qsTr("<b>Date setup</b><br/><br/>Set the day, month, year, and day of the week. Set current date sends the date from this device. Set applies the values you chose. Back returns to the main window without saving.")
                + "<br/><br/>"
                + qsTr("<b>Time setup</b><br/><br/>Set hours, minutes, seconds, and time correction. Time correction is the number of seconds added or subtracted every day to compensate for clock drift. Set current time sends the time from this device together with the correction. Set applies the values you chose. Back returns to the main window without saving.")
                + "<br/><br/>"
                + qsTr("<b>Heat setup</b><br/><br/>Set the minimal and maximal water temperature (18–35 °C). Set saves this range for automatic temperature control and returns to the main window.<br/><br/>Turn on and Turn off immediately switch the heater and put the controller into manual mode. The 35 °C temperature limit still applies in manual mode. To return to automatic temperature maintenance, press Auto.<br/><br/>Back returns to the main window without saving the temperature range.")
                + "<br/><br/>"
                + qsTr("<b>Light setup</b><br/><br/>Tap Turn on time or Turn off time to edit the lighting schedule. Brightness sets the target light level (0–100%). Rise time is how many minutes the light takes to fade in or out. Set saves the schedule and automatic-mode parameters and returns to the main window.<br/><br/>Turn on and Turn off immediately switch the light and put the controller into manual mode. To return to automatic lighting by schedule, press Auto.<br/><br/>Back returns to the main window without saving.")
                + "<br/><br/>"
                + qsTr("<b>Terminal</b><br/><br/>Terminal is an alternative to the graphical interface: you control the aquarium controller with text commands. Type a command and tap Send (or press Enter). Replies from the controller are shown in the output area. The controller command help prints a description of all supported commands and the format of their arguments.<br/><br/>The GUI icon returns to the main window. The local command clear clears the output. The local command exit closes the application.")
        }
    }

    Rectangle {
        id: buttonBox
        color: colors.background
        anchors.bottom: parent.bottom
        width: parent.width
        height: mmTOpx(12)

        Rectangle {
            id: okButton
            color: colors.buttonBackground
            anchors.margins: mmTOpx(1)
            anchors.fill: parent

            Text {
                text: qsTr("Back")
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: colors.buttonText
                font.pixelSize: mmTOpx(3.5)
                wrapMode: Text.WordWrap
            }

            MouseArea {
                anchors.fill: parent
                onClicked: close()
                onPressed: okButton.color = colors.buttonPressed
                onReleased: okButton.color = colors.buttonBackground
            }
        }
    }
}
