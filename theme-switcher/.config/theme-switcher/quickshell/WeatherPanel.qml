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
    property color cyan: "#7dcfff"
    property color green: "#9ece6a"
    property var daily: []
    property var hourly: []
    property string locationName: "Weather"
    property string countryName: ""
    property string currentTemp: "--"
    property string currentIcon: ""
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

    function displayHours() {
        if (!hourly || hourly.length === 0) return []

        let nowHour = new Date().getHours()
        let start = 0
        for (let i = 0; i < hourly.length; i++) {
            if (hourly[i].hour >= nowHour) {
                start = i
                break
            }
        }

        let out = hourly.slice(start, start + 8)
        if (out.length < 8) out = hourly.slice(Math.max(0, hourly.length - 8))
        return out
    }

    function tempNumber(temp) {
        return String(temp || "--").replace("°", "")
    }

    function applyWeather(data) {
        if (data.error) {
            currentDesc = data.error
            return
        }

        locationName = data.location ? data.location.name || "Weather" : "Weather"
        countryName = data.location ? data.location.country || "" : ""
        daily = data.daily || []
        hourly = data.hourly || []

        if (data.current) {
            currentTemp = data.current.temp || "--"
            currentIcon = data.current.icon || ""
            currentDesc = data.current.description || ""
            currentTime = data.current.time || ""
            precipitation = String(data.current.precipitation || 0) + " mm"
            humidity = String(data.current.humidity || 0) + "%"
            wind = String(data.current.wind || 0) + " mph"
        }
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
                    if (t.primary) root.primary = t.primary
                    if (t.cyan) root.cyan = t.cyan
                    if (t.green) root.green = t.green
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
        width: Math.min(root.width - 96, 920)
        height: 660
        anchors.centerIn: parent
        color: root.bg
        border.color: Qt.rgba(root.border.r, root.border.g, root.border.b, 0.34)
        border.width: 1
        radius: 0
        focus: true

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 18

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Text {
                    text: "󰍎"
                    color: root.fg
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                }

                Text {
                    text: root.locationName + (root.countryName ? ", " + root.countryName : "")
                    color: root.fg
                    elide: Text.ElideRight
                    Layout.maximumWidth: 420
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 15
                    font.bold: true
                }

                Text {
                    text: "Choose area"
                    color: "#8ab4f8"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Quickshell.execDetached([root.homeDir + "/.local/bin/theme-weather-location"])
                            Qt.quit()
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: root.currentTime
                    color: root.muted
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 24

                Text {
                    text: root.currentIcon
                    color: root.fg
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 54
                }

                Row {
                    spacing: 5
                    Text {
                        text: root.tempNumber(root.currentTemp)
                        color: root.fg
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 52
                        font.weight: Font.Light
                    }
                    Text {
                        text: "°C"
                        color: root.muted
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                    }
                }

                Column {
                    Layout.fillWidth: true
                    spacing: 5
                    Text {
                        text: root.currentDesc
                        color: root.fg
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 22
                    }
                    Row {
                        spacing: 12
                        WeatherPill { label: "Precip"; value: root.precipitation; accent: root.primary }
                        WeatherPill { label: "Humidity"; value: root.humidity; accent: root.cyan }
                        WeatherPill { label: "Wind"; value: root.wind; accent: root.green }
                    }
                }
            }

            ForecastCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                cardBg: root.bgAlt
                cardBorder: root.border

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    Repeater {
                        model: root.displayHours()

                        HourCard {
                            required property var modelData
                            required property int index

                            Layout.fillWidth: true
                            hourText: index === 0 ? "Now" : modelData.time
                            iconText: modelData.icon
                            tempText: modelData.temp
                            descText: modelData.description
                            fg: root.fg
                            muted: root.muted
                            accent: root.primary
                        }
                    }
                }
            }

            ForecastCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 292
                Layout.minimumHeight: 292
                cardBg: root.bgAlt
                cardBorder: root.border

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 10

                    Repeater {
                        model: root.daily.slice(0, 5)

                        DayRow {
                            required property var modelData
                            required property int index

                            Layout.fillWidth: true
                            dayText: index === 0 ? "Today" : modelData.day
                            iconText: modelData.icon
                            lowText: modelData.low
                            highText: modelData.high
                            minTemp: modelData.tempMin
                            maxTemp: modelData.tempMax
                            fg: root.fg
                            muted: root.muted
                            accent: root.primary
                            cool: root.cyan
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 18

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

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached(["xdg-open", "https://open-meteo.com/"])
                    }
                }

                Text {
                    text: "  •  "
                    color: root.muted
                    font.family: "JetBrainsMono Nerd Font"
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

    component ForecastCard: Rectangle {
        property color cardBg: "#2b2c31"
        property color cardBorder: "#5f6368"

        color: Qt.rgba(cardBg.r, cardBg.g, cardBg.b, 0.86)
        border.color: Qt.rgba(cardBorder.r, cardBorder.g, cardBorder.b, 0.26)
        border.width: 1
        radius: 0
    }

    component WeatherPill: Rectangle {
        required property string label
        required property string value
        required property color accent

        width: 132
        height: 46
        radius: 0
        color: Qt.rgba(accent.r, accent.g, accent.b, 0.12)
        border.color: Qt.rgba(accent.r, accent.g, accent.b, 0.32)
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: label
                color: root.muted
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 10
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: value
                color: root.fg
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
                font.bold: true
            }
        }
    }

    component HourCard: Item {
        required property string hourText
        required property string iconText
        required property string tempText
        required property string descText
        required property color fg
        required property color muted
        required property color accent

        Layout.minimumWidth: 82
        Layout.preferredHeight: 104

        ColumnLayout {
            anchors.fill: parent
            spacing: 7

            Text {
                Layout.fillWidth: true
                text: hourText
                color: muted
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                font.bold: true
            }

            Text {
                Layout.fillWidth: true
                text: iconText
                color: accent
                horizontalAlignment: Text.AlignHCenter
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 24
            }

            Text {
                Layout.fillWidth: true
                text: tempText
                color: fg
                horizontalAlignment: Text.AlignHCenter
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 15
                font.bold: true
            }

            Text {
                Layout.fillWidth: true
                text: descText
                color: muted
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 10
            }
        }
    }

    component DayRow: Item {
        required property string dayText
        required property string iconText
        required property string lowText
        required property string highText
        required property int minTemp
        required property int maxTemp
        required property color fg
        required property color muted
        required property color accent
        required property color cool

        Layout.preferredHeight: 42

        RowLayout {
            anchors.fill: parent
            spacing: 14

            Text {
                Layout.preferredWidth: 92
                text: dayText
                color: fg
                elide: Text.ElideRight
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 15
                font.bold: true
            }

            Text {
                Layout.preferredWidth: 38
                text: iconText
                color: accent
                horizontalAlignment: Text.AlignHCenter
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 21
            }

            Text {
                Layout.preferredWidth: 48
                text: lowText
                color: muted
                horizontalAlignment: Text.AlignRight
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
                font.bold: true
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 12

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 3
                    color: Qt.rgba(muted.r, muted.g, muted.b, 0.22)
                    radius: 0
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    x: parent.width * 0.24
                    width: Math.max(44, parent.width * Math.min(0.58, Math.max(0.22, (maxTemp - minTemp) / 18)))
                    height: 4
                    color: accent
                    radius: 0
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    x: parent.width * 0.24
                    width: 18
                    height: 4
                    color: cool
                    radius: 0
                }
            }

            Text {
                Layout.preferredWidth: 48
                text: highText
                color: fg
                horizontalAlignment: Text.AlignLeft
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
                font.bold: true
            }
        }
    }
}
