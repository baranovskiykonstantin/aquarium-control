import QtQuick 2.6
import QtBluetooth 5.3
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2

Item {
    id: mainItem

    Component.onCompleted: {

        state = "search"

        if (Screen.pixelDensity > 10)
            guiScale = 2
    }

    property real guiScale: 1

    property string aquriumName: "aquarium"
    property bool serviceFound: false

    property string date: "01.01.01"
    property string dayOfWeek: "Monday"
    property string time: "12:00:00"
    property string correction: "+00"
    property string correctionAt: "12:00:00"
    property string temp: "--"
    property string heat: "22-25"
    property string heatState: "OFF"
    property string heatMode: "auto"
    property string light: "10:00:00-18:00:00"
    property string lightState: "OFF"
    property string lightMode: "auto"
    property string lightLevel: "60"
    property string display: "time"

    BluetoothDiscoveryModel {
        id: btModel
        discoveryMode: BluetoothDiscoveryModel.MinimalServiceDiscovery
        running: true

        onRunningChanged : {
            if (!btModel.running && mainItem.state == "search" && !serviceFound) {
                searchBox.animationRunning = false;
                searchBox.appendText(qsTr("\nAquarium not found. \n\nPlease ensure that aquarium\nis available and restart app."))
            }
        }

        onErrorChanged: {
            if (error != BluetoothDiscoveryModel.NoError && !btModel.running) {
                searchBox.animationRunning = false
                searchBox.appendText(qsTr("\n\nDiscovery failed.\nPlease ensure Bluetooth is available."))
            }
        }

        onServiceDiscovered: {
            if (!serviceFound && service.deviceName == aquriumName) {
                serviceFound = true
                searchBox.appendText(qsTr("\nFound device %1.").arg(service.deviceAddress))
                searchBox.appendText(qsTr("\nConnecting to aquarium..."))
                socket.setService(service)
            }
        }

        uuidFilter: "00001101-0000-1000-8000-00805F9B34FB" //rfcomm
    }

    BluetoothSocket {
        id: socket
        connected: true

        onSocketStateChanged: {
            mainItem.state = "gui"
            cmdBox.setText("aquarium (%1):\n".arg(service.deviceAddress))
            guiBox.setHeader(qsTr("Aquarium (%1)").arg(service.deviceAddress))
            guiBox.updateGui()
        }

        onStringDataChanged: {
            var data = socket.stringData
            var matchRes, state, mode

            cmdBox.appendText(data)
            cmdBox.scrollToEnd()

            if (data.match("Date: ")) {
                matchRes = data.toString().match(new RegExp("Date: (\\d{2}.\\d{2}.\\d{2}) ([A-Za-z]+)", "m"))
                date = matchRes[1]
                dayOfWeek = setupDateBox.daysOfWeek[setupDateBox.dayOfWeekToInt(matchRes[2]) - 1]
                guiBox.setValue("date", qsTr("%1 %2").arg(date).arg(dayOfWeek))
            }
            if (data.match("Time: ")) {
                matchRes = data.toString().match(new RegExp("Time: (\\d{2}:\\d{2}:\\d{2}) \\(([+-]\\d+) sec at (\\d{2}:\\d{2}:\\d{2})\\)", "m"))
                time = matchRes[1]
                correction = matchRes[2]
                correctionAt = matchRes[3]
                guiBox.setValue("time", qsTr("%1 (time corrects on %2 sec. everyday at %3)").arg(time).arg(correction).arg(correctionAt))
            }
            if (data.match("Temp: ")) {
                matchRes = data.toString().match(new RegExp("Temp: (.+)", "m"))
                temp = matchRes[1]
                guiBox.setValue("temp", qsTr("%1 °C").arg(temp))
            }
            if (data.match("Heat: ")) {
                matchRes = data.toString().match(new RegExp("Heat: (ON|OFF) (auto|manual) \\((\\d+-\\d+)\\)", "m"))
                heatState = matchRes[1]
                heatMode = matchRes[2]
                heat= matchRes[3]
                state = heatState == "ON" ? qsTr("on") : qsTr("off")
                mode = heatMode == "auto" ? qsTr("automatic") : qsTr("manual")
                guiBox.setValue("heat", qsTr("Heater is %1 in %2 mode (%3)").arg(state).arg(mode).arg(heat))
            }
            if (data.match("Light: ")) {
                matchRes = data.toString().match(new RegExp("Light: (ON|OFF) (auto|manual) \\((\\d{2}:\\d{2}:\\d{2}-\\d{2}:\\d{2}:\\d{2})\\) (\\d+)%", "m"))
                lightState = matchRes[1]
                lightMode = matchRes[2]
                light = matchRes[3]
                lightLevel = matchRes[4]
                switch (lightState) {
                case "ON": state = qsTr("on"); break
                case "OFF": state = qsTr("off"); break
                default: state = qsTr("in unknown state")
                }
                switch (lightMode) {
                case "auto": mode = qsTr("automatic"); break
                case "manual": mode = qsTr("manual"); break
                default: mode = qsTr("unknown")
                }
                guiBox.setValue("light", qsTr("Light is %1 in %2 mode (%3), brightness %4%").arg(state).arg(mode).arg(light).arg(lightLevel))
            }
            if (data.match("Display: ")) {
                matchRes = data.toString().match(new RegExp("Display: (time|temp)", "m"))
                display = matchRes[1]
                var displayMode = qsTr("none")
                switch (display) {
                case "time" : displayMode = qsTr("time"); break
                case "temp" : displayMode = qsTr("temperature"); break
                }
                guiBox.setValue("display", qsTr("Display shows the %1").arg(displayMode))
            }
            if (data.match("OK") && mainItem.state != "cmd") {
                messageBox.show()
            }
            if (data.match("ERROR") && mainItem.state != "cmd") {
                messageBox.setText(qsTr("Error occurred while send the command!"))
                messageBox.show()
            }
        }
    }

    Rectangle {
        id: guiBackground
        z: 1
        anchors.fill: parent
        color: "#0096ff"

        // MouseArea needs to hide mouse events from items under background
        MouseArea {
            anchors.fill: parent
        }
    }

    Rectangle {
        id: messageBox
        z: 0
        anchors.fill: parent
        color: "transparent"

        function show () {
            messageBox.z = 3
        }

        function setText (message) {
            messageText.text = message
        }

        MouseArea {
            anchors.fill: parent
        }

        Rectangle {
            id: messageBackground
            color: "#f0f0f0"
            width: parent.width * 0.6
            height: 150// * guiScale
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: messageText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: okButton.top
                anchors.margins: 5
                color: "#1e1e1e"
                font.pointSize: 11
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                id: okButton
                color: "#33aaff"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                height: 48// * guiScale

                Text {
                    text: qsTr("OK")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#1e1e1e"
                    font.pointSize: 11
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: messageBox.z = 0
                    onPressed: okButton.color = "#f0f0f0"
                    onReleased: okButton.color = "#33aaff"
                }
            }
        }
    }

    Search {
        id: searchBox
        anchors.centerIn: guiBackground
    }

    Gui {
        id: guiBox
        anchors.fill: parent
    }

    SetupDate {
        id: setupDateBox
        anchors.fill: parent
    }

    SetupTime {
        id: setupTimeBox
        anchors.fill: parent
    }

    SetupHeat {
        id: setupHeatBox
        anchors.fill: parent
    }

    SetupLight {
        id: setupLightBox
        anchors.fill: parent
    }

    SetupLightTime {
        id: setupLightTimeBox
        anchors.fill: parent
    }

    Cmd {
        id: cmdBox
        anchors.fill: parent
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
            PropertyChanges { target: setupLightTimeBox; opacity: 0; z: 0 }
            PropertyChanges { target: cmdBox; opacity: 1; z: 2 }
        }
    ]
}
