import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root

    property string homeDir: Quickshell.env("HOME")
    property color bg: "#202124"
    property color bgAlt: "#2b2c31"
    property color fg: "#e8eaed"
    property color muted: "#9aa0a6"
    property color border: "#5f6368"
    property color primary: "#fdd663"
    property var weather: ({})
    property var daily: []
    property var hourly: []
    property string locationName: "Weather"
    property string countryName: ""
    property string currentTemp: "--"
    property string currentIcon: "☁"
    property string currentDesc: "Loading"
    property string currentTime: ""
    property string precipitation: "--"
    property string humidity: "--"
    property string wind: "--"

    WlrLayershell.namespace: "theme-weather-panel"
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    focusable: true
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    function sampleHours() {
        if (!hourly || hourly.length === 0) return []
        let out = []
        let step = Math.max(1, Math.floor(hourly.length / 8))
        for (let i = 0; i < hourly.length && out.length < 8; i += step) out.push(hourly[i])
        return out
    }

    function applyWeather(data) {
        if (data.error) {
            currentDesc = data.error
            return
        }

        weather = data
        locationName = data.location ? data.location.name || "Weather" : "Weather"
        countryName = data.location ? data.location.country || "" : ""
        daily = data.daily || []
        hourly = data.hourly || []

        if (data.current) {
            currentTemp = data.current.temp || "--"
            currentIcon = data.current.icon || "☁"
            currentDesc = data.current.description || ""
            currentTime = data.current.time || ""
            precipitation = String(data.current.precipitation || 0) + " mm"
            humidity = String(data.current.humidity || 0) + "%"
            wind = String(data.current.wind || 0) + " mph"
        }

        chart.requestPaint()
    }

    Process {
        id: themeProc
        command: ["bash", "-c", "cat ~/.config/theme-switcher/current.json 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let t = JSON.parse(this.text)
                    if (t.base) root.bg = t.base
                    if (t.base_alt) root.bgAlt = t.base_alt
                    if (t.text) root.fg = t.text
                    if (t.text_muted) root.muted = t.text_muted
                    if (t.border) root.border = t.border
                    if (t.yellow) root.primary = t.yellow
                    else if (t.primary) root.primary = t.primary
                } catch (e) {}
            }
        }
    }

    Process {
        id: weatherProc
        command: [root.homeDir + "/.local/bin/theme-weather-data"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.applyWeather(JSON.parse(this.text))
                } catch (e) {
                    root.currentDesc = "Could not load forecast"
                }
            }
        }
    }

    Component.onCompleted: {
        panel.forceActiveFocus()
        themeProc.running = true
        weatherProc.running = true
    }

    Shortcut { sequence: "Escape"; onActivated: Qt.quit() }

    Rectangle {
        anchors.fill: parent
        color: "#99000000"

        MouseArea {
            anchors.fill: parent
            onClicked: Qt.quit()
        }
    }

    Rectangle {
        id: panel
        width: 700
        height: 455
        anchors.centerIn: parent
        color: root.bg
        border.color: Qt.rgba(root.border.r, root.border.g, root.border.b, 0.35)
        border.width: 1
        radius: 0
        focus: true

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 14

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "󰍎  " + root.locationName + (root.countryName ? ", " + root.countryName : "")
                    color: root.fg
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    font.bold: true
                }

                Text {
                    Layout.fillWidth: true
                    text: "•  Choose area"
                    color: "#8ab4f8"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                }

                Text {
                    text: "⋮"
                    color: root.muted
                    font.pixelSize: 20
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 18

                Text {
                    text: root.currentIcon
                    font.pixelSize: 48
                    color: root.fg
                }

                Row {
                    spacing: 4
                    Text {
                        text: root.currentTemp.replace("°", "")
                        color: root.fg
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 44
                        font.weight: Font.Light
                    }
                    Text {
                        text: "°C | °F"
                        color: root.muted
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Column {
                    Layout.fillWidth: true
                    spacing: 2
                    Text {
                        text: "Precipitation: " + root.precipitation
                        color: root.muted
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                    }
                    Text {
                        text: "Humidity: " + root.humidity
                        color: root.muted
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                    }
                    Text {
                        text: "Wind: " + root.wind
                        color: root.muted
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                    }
                }

                Column {
                    spacing: 2
                    Text {
                        anchors.right: parent.right
                        text: "Weather"
                        color: root.fg
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 20
                    }
                    Text {
                        anchors.right: parent.right
                        text: root.currentTime
                        color: root.muted
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                    }
                    Text {
                        anchors.right: parent.right
                        text: root.currentDesc
                        color: root.muted
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 16
                    }
                }
            }

            Row {
                spacing: 18
                Text { text: "Temperature"; color: root.fg; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14 }
                Text { text: "Precipitation"; color: root.fg; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14 }
                Text { text: "Wind"; color: root.fg; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 14 }
            }

            Rectangle {
                width: 79
                height: 3
                color: root.primary
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 112

                Canvas {
                    id: chart
                    anchors.fill: parent
                    onPaint: {
                        let ctx = getContext("2d")
                        ctx.reset()
                        let points = root.sampleHours()
                        if (!points || points.length < 2) return

                        let minTemp = Math.min.apply(Math, points.map((p) => p.tempValue))
                        let maxTemp = Math.max.apply(Math, points.map((p) => p.tempValue))
                        let spread = Math.max(1, maxTemp - minTemp)
                        let left = 10
                        let right = width - 10
                        let top = 18
                        let bottom = height - 34

                        ctx.fillStyle = Qt.rgba(root.primary.r, root.primary.g, root.primary.b, 0.22)
                        ctx.beginPath()
                        for (let i = 0; i < points.length; i++) {
                            let x = left + (right - left) * (i / (points.length - 1))
                            let y = bottom - ((points[i].tempValue - minTemp) / spread) * (bottom - top)
                            if (i === 0) ctx.moveTo(x, y)
                            else ctx.lineTo(x, y)
                        }
                        ctx.lineTo(right, bottom + 10)
                        ctx.lineTo(left, bottom + 10)
                        ctx.closePath()
                        ctx.fill()

                        ctx.strokeStyle = root.primary
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        for (let j = 0; j < points.length; j++) {
                            let lx = left + (right - left) * (j / (points.length - 1))
                            let ly = bottom - ((points[j].tempValue - minTemp) / spread) * (bottom - top)
                            if (j === 0) ctx.moveTo(lx, ly)
                            else ctx.lineTo(lx, ly)
                        }
                        ctx.stroke()
                    }
                }

                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    Repeater {
                        model: root.sampleHours()

                        Column {
                            required property var modelData
                            width: (chart.width - 16) / Math.max(1, root.sampleHours().length)
                            spacing: 18

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.temp
                                color: root.fg
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                                font.bold: true
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.time
                                color: root.muted
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 11
                            }
                        }
                    }
                }
            }

            Row {
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: root.daily.slice(0, 8)

                    Rectangle {
                        required property var modelData
                        required property int index
                        width: 76
                        height: 90
                        color: index === 0 ? Qt.rgba(root.border.r, root.border.g, root.border.b, 0.22) : "transparent"
                        radius: 0

                        Column {
                            anchors.centerIn: parent
                            spacing: 4

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.day
                                color: root.fg
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 14
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.icon
                                font.pixelSize: 28
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.high + " " + modelData.low
                                color: root.fg
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(root.border.r, root.border.g, root.border.b, 0.35)
            }

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: ""
                }
                Text {
                    text: "Open-Meteo"
                    color: root.muted
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    font.underline: true
                }
                Text {
                    text: " • "
                    color: root.muted
                    font.pixelSize: 11
                }
                Text {
                    text: "Close"
                    color: root.muted
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    font.underline: true
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.quit()
                    }
                }
            }
        }
    }
}
