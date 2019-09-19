import QtQuick 2.0

Item {
    property bool connected: false
    property string portName: ""
    property string date: "01.01.01"
    property string dayOfWeek: "Monday"
    property string time: "12:00:00"
    property string correction: "+00"
    property string correctionAt: "12:00:00"
    property string temp: "--"
    property string heat: "22-25"
    property string heatState: "OFF"
    property string heatMode: "auto"
    property string light: "08:00:00-18:00:00"
    property string lightState: "OFF"
    property string lightMode: "auto"
    property string lightLevel: "50"
    property string riseTime: "15"
    property string display: "time"
}
