import QtQuick 2.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.0
import SerialPort 1.0

Item {
    id: mainWindow

    Component.onCompleted: {
        if (aquarium.portName == "") {
            searchPorts()
        }
        else {
            connectToAquarium(aquarium.portName)
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

    function quit() {
        if (aquarium.connected == false) {
            aquarium.portName = ""
        }
        Qt.quit()
    }

    function searchPorts() {
        mainWindow.state = "portList"
        serialPort.closePort()
        reset()
        portListBox.removeItems()
        serialPort.searchPorts()
    }

    function closePort() {
        serialPort.closePort()
        if (mainWindow.state != "cmd") {
            mainWindow.state = "gui"
        }
    }

    function connectToAquarium(portName) {
        aquarium.portName = portName
        searchBox.setText(qsTr("Connecting to aquarium (%1)").arg(portName))
        mainWindow.state = "search"
        serialPort.openPort(portName)
        sendToAquarium("status")
    }

    function sendToAquarium(data) {
        serialPort.sendLine(data)
    }

    function reset() {
        aquarium.portName = ""
        aquarium.connected = false
        guiBox.setHeader(qsTr("aquarium (disconnected)"))
        guiBox.setValue("date", qsTr("no data"))
        guiBox.setValue("time", qsTr("no data"))
        guiBox.setValue("temp", qsTr("no data"))
        guiBox.setValue("heat", qsTr("no data"))
        guiBox.setValue("light", qsTr("no data"))
        guiBox.setValue("display", qsTr("no data"))
        cmdBox.setPrompt(aquarium.portName)
    }

    Aquarium {
        id: aquarium
    }

    Settings {
        id: settings

        property alias aquariumName: aquarium.portName
    }

    Colors {
        id: colors
    }

    SerialPort {
        id: serialPort

        onPortFound: {
            portListBox.addItem(name)
        }

        onPortError: {
            if (error != "NoError") {
                if (mainWindow.state == "search")
                {
                    searchBox.stopAnimation()
                    searchBox.setText(qsTr(
                        "Connection with aquarium has been terminated!\n" +
                        "Please ensure aquarium is available."
                    ))
                }
                else if (mainWindow.state == "gui")
                {
                    messageBox.setText(qsTr(
                        "Connection with aquarium has been terminated!\n" +
                        "Please ensure aquarium is available."
                    ))
                    messageBox.show()
                }
                reset()
            }
        }

        onLineReceived: {
            var matchRes, state, mode, currentLightLevel

            if (aquarium.connected == false) {
                // First data has been successfully received after connection.
                aquarium.connected = true
                mainWindow.state = "gui"
                cmdBox.setPrompt(aquarium.portName)
                guiBox.setHeader(qsTr(
                    "aquarium (%1)")
                    .arg(aquarium.portName)
                )
                guiBox.updateGui()
            }

            if (mainWindow.state == "cmd") {
                cmdBox.appendLine(line)
            }
            else {
                if (line.startsWith("Date: ")) {
                    matchRes = line.match(
                        new RegExp("Date: (\\d{2}.\\d{2}.\\d{2}) ([A-Za-z]+)", "m")
                    )
                    aquarium.date = matchRes[1]
                    aquarium.dayOfWeek = setupDateBox.daysOfWeek[setupDateBox.dayOfWeekToInt(matchRes[2]) - 1]
                    guiBox.setValue("date",
                        "%1 %2"
                        .arg(aquarium.date)
                        .arg(aquarium.dayOfWeek)
                    )
                }
                else if (line.startsWith("Time: ")) {
                    matchRes = line.match(
                        new RegExp("Time: (\\d{2}:\\d{2}:\\d{2}) \\(([+-]\\d+) sec at (\\d{2}:\\d{2}:\\d{2})\\)", "m")
                    )
                    aquarium.time = matchRes[1]
                    aquarium.correction = matchRes[2]
                    aquarium.correctionAt = matchRes[3]
                    guiBox.setValue("time", qsTr(
                        "%1 (time is adjusted for %2 sec. everyday at %3)")
                        .arg(aquarium.time)
                        .arg(aquarium.correction)
                        .arg(aquarium.correctionAt)
                    )
                }
                else if (line.startsWith("Temp: ")) {
                    matchRes = line.match(
                        new RegExp("Temp: (.+)", "m")
                    )
                    aquarium.temp = matchRes[1]
                    guiBox.setValue("temp", qsTr(
                        "Water temperature %1 °C")
                        .arg(aquarium.temp)
                    )
                }
                else if (line.startsWith("Heat: ")) {
                    matchRes = line.match(
                        new RegExp("Heat: (ON|OFF) (auto|manual) \\((\\d+-\\d+)\\)", "m")
                    )
                    aquarium.heatState = matchRes[1]
                    aquarium.heatMode = matchRes[2]
                    aquarium.heat= matchRes[3]
                    state = aquarium.heatState == "ON" ? qsTr("on") : qsTr("off")
                    mode = aquarium.heatMode == "auto" ? qsTr("automatic") : qsTr("manual")
                    guiBox.setValue("heat", qsTr(
                        "Heater is %1 in %2 mode (%3)")
                        .arg(state)
                        .arg(mode)
                        .arg(aquarium.heat)
                    )
                }
                else if (line.startsWith("Light: ")) {
                    matchRes = line.match(
                        new RegExp("Light: (ON|OFF) (auto|manual) \\((\\d{2}:\\d{2}:\\d{2}-\\d{2}:\\d{2}:\\d{2})\\) (\\d+)/(\\d+)% (\\d+)min", "m")
                    )
                    aquarium.lightState = matchRes[1]
                    aquarium.lightMode = matchRes[2]
                    aquarium.light = matchRes[3]
                    currentLightLevel = matchRes[4]
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
                    guiBox.setValue("light", qsTr(
                        "Light is %1 in %2 mode (%3, %4/%5%, %6 min.)")
                        .arg(state)
                        .arg(mode)
                        .arg(aquarium.light)
                        .arg(currentLightLevel)
                        .arg(aquarium.lightLevel)
                        .arg(aquarium.riseTime)
                    )
                }
                else if (line.startsWith("Display: ")) {
                    matchRes = line.match(
                        new RegExp("Display: (time|temp)", "m")
                    )
                    aquarium.display = matchRes[1]
                    var displayMode = qsTr("none")
                    switch (aquarium.display) {
                        case "time" : displayMode = qsTr("time"); break
                        case "temp" : displayMode = qsTr("temperature"); break
                    }
                    guiBox.setValue("display", qsTr(
                        "Display shows the %1")
                        .arg(displayMode)
                    )
                }
                else if (line == "OK") {
                    messageBox.show()
                }
                else if (line == "ERROR") {
                    messageBox.setText(qsTr(
                        "Error has been occurred while send the command!"
                    ))
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

    PortList {
        id: portListBox
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
            PropertyChanges { target: portListBox; opacity: 0; z: 0 }
            PropertyChanges { target: guiBox; opacity: 0; z: 0}
            PropertyChanges { target: setupDateBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupHeatBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightBox; opacity: 0; z: 0 }
            PropertyChanges { target: setupLightTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: cmdBox; opacity: 0; z: 0}
        },
        State {
            name: "portList"
            PropertyChanges { target: searchBox; opacity: 0; z: 0 }
            PropertyChanges { target: portListBox; opacity: 1; z: 2 }
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
            PropertyChanges { target: portListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: portListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: portListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: portListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: portListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: portListBox; opacity: 0; z: 0 }
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
            PropertyChanges { target: portListBox; opacity: 0; z: 0 }
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
