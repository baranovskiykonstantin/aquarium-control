import QtQuick 2.6
import QtBluetooth 5.3
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import "."

Item {
    id: mainWindow

    property real guiScale: 1

    Component.onCompleted: {
        // If size of icons on screen less then 6mm (48x48px)
        if (Screen.pixelDensity > 10)
            guiScale = 2

        mainWindow.state = "search"
        // If settings has address from previous session - try to use it
        if (btService.deviceAddress != "00:00:00:00:00:00") {
            searchBox.setText(qsTr("Connecting to aquarium:\n%1").arg(btService.deviceAddress))
            btSocket.setService(btService)
            btSocket.connected = true
        }
        // Otherwise - search for another one
        else {
            startSearching()
        }
    }

    function startSearching() {
        mainWindow.state = "search"
        searchBox.setText(qsTr("Searching for aquarium..."))
        btSocket.connected = false
        btService.deviceAddress = "00:00:00:00:00:00"
        btDiscovery.running = false
        btDiscovery.running = true
    }

    function sendToAquarium(data) {
        if (btSocket.connected == true)
            btSocket.stringData = data
    }

    Settings {
        property alias aquariumAddress: btService.deviceAddress
    }

    Aquarium {
        id: aquarium
    }

    Colors {
        id: colors
    }

    BluetoothService {
        id: btService
        //deviceName: "aquarium"
        deviceAddress: "00:00:00:00:00:00" // Value restores from settings automatically
        serviceProtocol: BluetoothService.RfcommProtocol
        serviceUuid: "00001101-0000-1000-8000-00805F9B34FB" // RFCOMM
    }

    BluetoothDiscoveryModel {
        id: btDiscovery
        uuidFilter: btService.serviceUuid
        discoveryMode: BluetoothDiscoveryModel.MinimalServiceDiscovery
        running: false

        onRunningChanged : {
            if (!btDiscovery.running && mainWindow.state == "search" && btService.deviceAddress == "00:00:00:00:00:00") {
                messageBox.setTitle(qsTr("Aquarium not found"))
                messageBox.setText(qsTr("Please ensure aquarium is available."))
                messageBox.show()
                mainWindow.state = "gui"
            }
        }

        onErrorChanged: {
            if (error != BluetoothDiscoveryModel.NoError && btDiscovery.running) {
                btDiscovery.running = false
                searchBox.animationRunning = false
                messageBox.setTitle(qsTr("Aquarium not found"))
                messageBox.setText(qsTr("Please ensure Bluetooth is available."))
                messageBox.error = true
                messageBox.show()
            }
        }

        onServiceDiscovered: {
            if (service.deviceName == "aquarium") {
                btService.deviceAddress = service.deviceAddress
                btSocket.setService(btService)
                btSocket.connected = true
                btDiscovery.running = false
                searchBox.setText(qsTr("Connecting to aquarium:\n%1").arg(btService.deviceAddress))
                messageBox.setTitle(qsTr("Aquarium found"))
                messageBox.setText(qsTr("Adress: %1").arg(btService.deviceAddress))
                messageBox.show()
            }
        }
    }

    BluetoothSocket {
        id: btSocket
        connected: false

        onErrorChanged: {
            if (error != BluetoothSocket.NoError) {
                messageBox.setTitle(qsTr("Can't connect to aquarium"))
                messageBox.setText(qsTr("Please ensure aquarium is available."))
                messageBox.show()
                guiBox.setHeader(qsTr("Aquarium (not connected)"))
                if (mainWindow.state != "cmd")
                    mainWindow.state = "gui"
            }
        }

        onSocketStateChanged: {
            if (btSocket.connected == true) {
                aquarium.connected = true
                mainWindow.state = "gui"
                cmdBox.setText("aquarium (%1):\n".arg(service.deviceAddress))
                guiBox.setHeader(qsTr("Aquarium (%1)").arg(service.deviceAddress))
                guiBox.updateGui()
            }
            else {
                if (aquarium.connected == true)
                    cmdBox.appendText(qsTr("\naquarium not connected!\n"))
                guiBox.setHeader(qsTr("Aquarium (not connected)"))
                aquarium.connected = false
            }
        }

        onStringDataChanged: {
            var data = btSocket.stringData
            var matchRes, state, mode

            cmdBox.appendText(data)
            cmdBox.scrollToEnd()

            if (data.match("Date: ")) {
                matchRes = data.toString().match(new RegExp("Date: (\\d{2}.\\d{2}.\\d{2}) ([A-Za-z]+)", "m"))
                aquarium.date = matchRes[1]
                aquarium.dayOfWeek = setupDateBox.daysOfWeek[setupDateBox.dayOfWeekToInt(matchRes[2]) - 1]
                guiBox.setValue("date", qsTr("%1 %2").arg(aquarium.date).arg(aquarium.dayOfWeek))
            }
            if (data.match("Time: ")) {
                matchRes = data.toString().match(new RegExp("Time: (\\d{2}:\\d{2}:\\d{2}) \\(([+-]\\d+) sec at (\\d{2}:\\d{2}:\\d{2})\\)", "m"))
                aquarium.time = matchRes[1]
                aquarium.correction = matchRes[2]
                aquarium.correctionAt = matchRes[3]
                guiBox.setValue("time", qsTr("%1 (time corrects on %2 sec. everyday at %3)").arg(aquarium.time).arg(aquarium.correction).arg(aquarium.correctionAt))
            }
            if (data.match("Temp: ")) {
                matchRes = data.toString().match(new RegExp("Temp: (.+)", "m"))
                aquarium.temp = matchRes[1]
                guiBox.setValue("temp", qsTr("Water temperature %1 °C").arg(aquarium.temp))
            }
            if (data.match("Heat: ")) {
                matchRes = data.toString().match(new RegExp("Heat: (ON|OFF) (auto|manual) \\((\\d+-\\d+)\\)", "m"))
                aquarium.heatState = matchRes[1]
                aquarium.heatMode = matchRes[2]
                aquarium.heat= matchRes[3]
                state = aquarium.heatState == "ON" ? qsTr("on") : qsTr("off")
                mode = aquarium.heatMode == "auto" ? qsTr("automatic") : qsTr("manual")
                guiBox.setValue("heat", qsTr("Heater is %1 in %2 mode (%3)").arg(state).arg(mode).arg(aquarium.heat))
            }
            if (data.match("Light: ")) {
                matchRes = data.toString().match(new RegExp("Light: (ON|OFF) (auto|manual) \\((\\d{2}:\\d{2}:\\d{2}-\\d{2}:\\d{2}:\\d{2})\\) (\\d+)%", "m"))
                aquarium.lightState = matchRes[1]
                aquarium.lightMode = matchRes[2]
                aquarium.light = matchRes[3]
                aquarium.lightLevel = matchRes[4]
                switch (aquarium.lightState) {
                    case "ON": state = qsTr("on"); break
                    case "OFF": state = qsTr("off"); break
                    default: state = qsTr("in unknown state")
                }
                switch (aquarium.lightMode) {
                    case "auto": mode = qsTr("automatic"); break
                    case "manual": mode = qsTr("manual"); break
                    default: mode = qsTr("unknown")
                }
                guiBox.setValue("light", qsTr("Light is %1 in %2 mode (%3), brightness %4%").arg(state).arg(mode).arg(aquarium.light).arg(aquarium.lightLevel))
            }
            if (data.match("Display: ")) {
                matchRes = data.toString().match(new RegExp("Display: (time|temp)", "m"))
                aquarium.display = matchRes[1]
                var displayMode = qsTr("none")
                switch (aquarium.display) {
                    case "time" : displayMode = qsTr("time"); break
                    case "temp" : displayMode = qsTr("temperature"); break
                }
                guiBox.setValue("display", qsTr("Display shows the %1").arg(displayMode))
            }
            if (data.match("OK") && mainWindow.state != "cmd") {
                messageBox.show()
            }
            if (data.match("ERROR") && mainWindow.state != "cmd") {
                messageBox.setText(qsTr("Error occurred while send the command!"))
                messageBox.show()
            }
        }
    }

    Rectangle {
        id: guiBackground
        z: 1
        anchors.fill: mainWindow
        color: colors.background

        // MouseArea is need for hiding mouse events from items under background
        MouseArea {
            anchors.fill: parent
        }
    }

    Message {
        id:messageBox
        anchors.fill: mainWindow
    }

    Search {
        id: searchBox
        anchors.centerIn: mainWindow
    }

    Gui {
        id: guiBox
        anchors.fill: mainWindow
    }

    SetupDate {
        id: setupDateBox
        anchors.fill: mainWindow
    }

    SetupTime {
        id: setupTimeBox
        anchors.fill: mainWindow
    }

    SetupHeat {
        id: setupHeatBox
        anchors.fill: mainWindow
    }

    SetupLight {
        id: setupLightBox
        anchors.fill: mainWindow
    }

    SetupLightTime {
        id: setupLightTimeBox
        anchors.fill: mainWindow
    }

    Cmd {
        id: cmdBox
        anchors.fill: mainWindow
    }

    states: [
        State {
            name: "search"
            PropertyChanges { target: searchBox; opacity: 1; z: 2 }
            PropertyChanges { target: guiBox; opacity: 0; z: 0}
            PropertyChanges { target: setupDateBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupHeatBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: cmdBox; opacity: 0; z: 0}
        },
        State {
            name: "gui"
            PropertyChanges { target: searchBox; opacity: 0; z: 0 }
            PropertyChanges { target: guiBox; opacity: 1; z: 2}
            PropertyChanges { target: setupDateBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupHeatBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: cmdBox; opacity: 0; z: 0}
        },
        State {
            name: "setupDate"
            PropertyChanges { target: searchBox; opacity: 0; z: 0 }
            PropertyChanges { target: guiBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupDateBox; opacity: 1; z: 2 }
            PropertyChanges { target: setupTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupHeatBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: cmdBox; opacity: 0; z: 0 }
        },
        State {
            name: "setupTime"
            PropertyChanges { target: searchBox; opacity: 0; z: 0 }
            PropertyChanges { target: guiBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupDateBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupTimeBox; opacity: 1; z: 2 }
            PropertyChanges { target: setupHeatBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: cmdBox; opacity: 0; z: 0 }
        },
        State {
            name: "setupHeat"
            PropertyChanges { target: searchBox; opacity: 0; z: 0 }
            PropertyChanges { target: guiBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupDateBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupHeatBox; opacity: 1; z: 2 }
            PropertyChanges { target: setupLightBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: cmdBox; opacity: 0; z: 0 }
        },
        State {
            name: "setupLight"
            PropertyChanges { target: searchBox; opacity: 0; z: 0 }
            PropertyChanges { target: guiBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupDateBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupHeatBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightBox; opacity: 1; z: 2 }
            PropertyChanges { target: setupLightTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: cmdBox; opacity: 0; z: 0 }
        },
        State {
            name: "setupLightTime"
            PropertyChanges { target: searchBox; opacity: 0; z: 0 }
            PropertyChanges { target: guiBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupDateBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupHeatBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightTimeBox; opacity: 1; z: 2 }
            PropertyChanges { target: cmdBox; opacity: 0; z: 0 }
        },
        State {
            name: "cmd"
            PropertyChanges { target: searchBox; opacity: 0; z: 0 }
            PropertyChanges { target: guiBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupDateBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupHeatBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: cmdBox; opacity: 1; z: 2 }
        }
    ]
}
