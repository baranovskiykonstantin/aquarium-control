import QtQuick 2.0
import QtBluetooth 5.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0

Item {
    id: mainWindow

    Component.onCompleted: {
        if (aquarium.address == "00:00:00:00:00:00") {
            startSearching()
        }
        else {
            connectToAquarium(aquarium.name, aquarium.address)
        }
    }

    // Screen size in inches
    readonly property real screenSize: Math.sqrt(Math.pow(Screen.height, 2) + Math.pow(Screen.width, 2)) / (Screen.pixelDensity * 25.4)

    // Calculate pixel count per millimeter of the screen
    function mmTOpx(mm) {
        var px = Screen.pixelDensity * mm
        // Make size of items bit less on small screens
        if (screenSize < 6.8) {
            px *= 0.7
        }
        return Math.round(px)
    }

    function startSearching() {
        mainWindow.state = "search"
        searchBox.setText(qsTr("Search of aquariums..."))
        deviceListBox.removeItems()
        btSocket.connected = false
        btService.deviceAddress = "00:00:00:00:00:00"
        btDiscovery.running = true
    }

    function stopSearching() {
        btSocket.connected = false
        btService.deviceAddress = "00:00:00:00:00:00"
        btDiscovery.running = false
        mainWindow.state = "gui"
    }

    function connectToAquarium(name, address) {
        aquarium.name = name
        // aquarium.address will be set when the connection is established
        btService.deviceAddress = address
        btSocket.connected = true
        searchBox.setText(qsTr("Connecting to\n%1 (%2)").arg(name).arg(address))
        mainWindow.state = "search"
    }

    function sendToAquarium(data) {
        if (btSocket.connected == true) {
            btSocket.stringData = data
        }
    }

    function resetGui() {
        aquarium.name = ""
        aquarium.address = "00:00:00:00:00:00"
        guiBox.setHeader(qsTr("aquarium (disconnected)"))
        guiBox.setValue("date", qsTr("no data"))
        guiBox.setValue("time", qsTr("no data"))
        guiBox.setValue("temp", qsTr("no data"))
        guiBox.setValue("heat", qsTr("no data"))
        guiBox.setValue("light", qsTr("no data"))
        guiBox.setValue("display", qsTr("no data"))
        cmdBox.setText(qsTr("<font color=\"tomato\">aquarium (disconnected):</font><br>"))
    }

    Aquarium {
        id: aquarium
    }

    Settings {
        id: settings

        property alias aquariumName: aquarium.name
        property alias aquariumAddress: aquarium.address
    }

    Colors {
        id: colors
    }

    BluetoothService {
        id: btService
        deviceAddress: "00:00:00:00:00:00"
        serviceProtocol: BluetoothService.RfcommProtocol
        serviceUuid: "00001101-0000-1000-8000-00805F9B34FB" // RFCOMM
    }

    BluetoothDiscoveryModel {
        id: btDiscovery
        uuidFilter: btService.serviceUuid
        discoveryMode: BluetoothDiscoveryModel.MinimalServiceDiscovery
        running: false

        onRunningChanged : {
            if (!btDiscovery.running) {
                if (deviceListBox.getItemCount() == 0) {
                    searchBox.stopAnimation()
                    searchBox.setText(qsTr(
                        "No aquarium was found!\n" +
                        "Please ensure aquarium is available."))
                }
                else {
                    mainWindow.state = "deviceList"
                }
            }
        }

        onErrorChanged: {
            if (error == BluetoothDiscoveryModel.PoweredOffError) {
                searchBox.stopAnimation()
                searchBox.setText(qsTr(
                    "Bluetooth is powered off!\n" +
                    "Please power on Bluetooth and try again."))
            }
            else if (error != BluetoothDiscoveryModel.NoError && btDiscovery.running) {
                btDiscovery.running = false
                searchBox.stopAnimation()
                searchBox.setText(qsTr(
                    "No aquarium was found!\n" +
                    "Please ensure Bluetooth is available."))
            }
        }

        onServiceDiscovered: {
            if (service.deviceName.startsWith("aquarium")) {
                deviceListBox.addItem(service.deviceName, service.deviceAddress)
            }
        }
    }

    BluetoothSocket {
        id: btSocket
        service: btService
        connected: false

        onErrorChanged: {
            if (error != BluetoothSocket.NoError) {
                searchBox.stopAnimation()
                searchBox.setText(qsTr(
                    "Cannot connect to aquarium!\n" +
                    "Please ensure aquarium is available."))
                resetGui()
            }
        }

        onSocketStateChanged: {
            if (btSocket.connected == true) {
                aquarium.connected = true
                aquarium.address = service.deviceAddress
                mainWindow.state = "gui"
                cmdBox.setText("<font color=\"%1\">%2 (%3):</font><br>"
                               .arg(colors.headerText)
                               .arg(aquarium.name)
                               .arg(aquarium.address))
                guiBox.setHeader("%1 (%2)"
                                 .arg(aquarium.name)
                                 .arg(aquarium.address))
                guiBox.updateGui()
            }
            else {
                resetGui()
                aquarium.connected = false
            }
        }

        onStringDataChanged: {
            var data = btSocket.stringData.toString()
            var matchRes, state, mode

            if (mainWindow.state == "cmd") {
                cmdBox.appendText(data)
            }
            else {

                if (data.match("Date: ")) {
                    matchRes = data.match(new RegExp("Date: (\\d{2}.\\d{2}.\\d{2}) ([A-Za-z]+)", "m"))
                    aquarium.date = matchRes[1]
                    aquarium.dayOfWeek = setupDateBox.daysOfWeek[setupDateBox.dayOfWeekToInt(matchRes[2]) - 1]
                    guiBox.setValue("date", "%1 %2".arg(aquarium.date).arg(aquarium.dayOfWeek))
                }
                if (data.match("Time: ")) {
                    matchRes = data.match(new RegExp("Time: (\\d{2}:\\d{2}:\\d{2}) \\(([+-]\\d+) sec at (\\d{2}:\\d{2}:\\d{2})\\)", "m"))
                    aquarium.time = matchRes[1]
                    aquarium.correction = matchRes[2]
                    aquarium.correctionAt = matchRes[3]
                    guiBox.setValue("time", qsTr("%1 (time is adjusted for %2 sec. everyday at %3)")
                                                 .arg(aquarium.time)
                                                 .arg(aquarium.correction)
                                                 .arg(aquarium.correctionAt))
                }
                if (data.match("Temp: ")) {
                    matchRes = data.match(new RegExp("Temp: (.+)", "m"))
                    aquarium.temp = matchRes[1]
                    guiBox.setValue("temp", qsTr("Water temperature %1 °C").arg(aquarium.temp))
                }
                if (data.match("Heat: ")) {
                    matchRes = data.match(new RegExp("Heat: (ON|OFF) (auto|manual) \\((\\d+-\\d+)\\)", "m"))
                    aquarium.heatState = matchRes[1]
                    aquarium.heatMode = matchRes[2]
                    aquarium.heat= matchRes[3]
                    state = aquarium.heatState == "ON" ? qsTr("on") : qsTr("off")
                    mode = aquarium.heatMode == "auto" ? qsTr("automatic") : qsTr("manual")
                    guiBox.setValue("heat", qsTr("Heater is %1 in %2 mode (%3)").arg(state).arg(mode).arg(aquarium.heat))
                }
                if (data.match("Light: ")) {
                    matchRes = data.match(new RegExp("Light: (ON|OFF) (auto|manual) \\((\\d{2}:\\d{2}:\\d{2}-\\d{2}:\\d{2}:\\d{2})\\) (\\d+)/(\\d+)% (\\d+)min", "m"))
                    aquarium.lightState = matchRes[1]
                    aquarium.lightMode = matchRes[2]
                    aquarium.light = matchRes[3]
                    aquarium.lightLevel = matchRes[5]
                    aquarium.riseTime = matchRes[6]
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
                    guiBox.setValue("light", qsTr("Light is %1 in %2 mode (%3, %4%, %5 min.)")
                                                  .arg(state)
                                                  .arg(mode)
                                                  .arg(aquarium.light)
                                                  .arg(aquarium.lightLevel)
                                                  .arg(aquarium.riseTime))
                }
                if (data.match("Display: ")) {
                    matchRes = data.match(new RegExp("Display: (time|temp)", "m"))
                    aquarium.display = matchRes[1]
                    var displayMode = qsTr("none")
                    switch (aquarium.display) {
                        case "time" : displayMode = qsTr("time"); break
                        case "temp" : displayMode = qsTr("temperature"); break
                    }
                    guiBox.setValue("display", qsTr("Display shows the %1").arg(displayMode))
                }
                if (data.match("OK")) {
                    messageBox.show()
                }
                if (data.match("ERROR")) {
                    messageBox.setText(qsTr("Error has been occurred while send the command!"))
                    messageBox.show()
                }
            }
        }
    }

    Rectangle {
        id: guiBackground
        z: 1
        anchors.fill: mainWindow
        color: colors.background

        // MouseArea is needed to hide mouse events from items under background
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
        anchors.fill: mainWindow
    }

    DeviceList {
        id: deviceListBox
        anchors.fill: mainWindow
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
            PropertyChanges { target: deviceListBox; opacity: 0; z: 0 }
            PropertyChanges { target: guiBox; opacity: 0; z: 0}
            PropertyChanges { target: setupDateBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupHeatBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: cmdBox; opacity: 0; z: 0}
        },
        State {
            name: "deviceList"
            PropertyChanges { target: searchBox; opacity: 0; z: 0 }
            PropertyChanges { target: deviceListBox; opacity: 1; z: 2 }
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
            PropertyChanges { target: deviceListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: deviceListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: deviceListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: deviceListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: deviceListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: deviceListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: deviceListBox; opacity: 0; z: 0 }
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
