import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland

Variants {
    model: Quickshell.screens

    delegate: Component {
        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            property string homeDir: Quickshell.env("HOME")
            property color bg: "#0c0d17"
            property color bgAlt: "#1e1f29"
            property color fg: "#e2e1ef"
            property color muted: "#908f9c"
            property color primary: "#bcc2ff"
            property color cyan: "#7dcfff"
            property color green: "#9ece6a"
            property color yellow: "#e0af68"
            property color red: "#f7768e"
            property string timeText: Qt.formatDateTime(new Date(), "HH:mm:ss")
            property string dateText: Qt.formatDateTime(new Date(), "dddd, d MMMM")
            property string weatherTemp: "--"
            property string weatherIcon: ""
            property string weatherDesc: "Weather"
            property int activeWorkspace: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1
            property var occupiedWorkspaces: []
            property string mediaText: ""
            property string volumeText: "--"
            property string batteryText: ""

            WlrLayershell.namespace: "theme-bar"
            WlrLayershell.layer: WlrLayer.Top
            exclusionMode: ExclusionMode.Normal
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40
            margins { top: 0; bottom: 0; left: 0; right: 0 }
            exclusiveZone: 40

            function isLeftScreen() {
                return !bar.screen || bar.screen.name === "DP-4" || bar.screen.x === 0
            }

            function workspaceStart() {
                return isLeftScreen() ? 1 : 6
            }

            function workspaceActive(id) {
                return activeWorkspace === id
            }

            function workspaceOccupied(id) {
                return occupiedWorkspaces.indexOf(id) !== -1
            }

            Process {
                id: themeProc
                command: ["bash", "-c", "cat ~/.config/theme-switcher/current.json 2>/dev/null"]
                stdout: StdioCollector {
                    onStreamFinished: {
                        try {
                            let t = JSON.parse(this.text)
                            if (t.base) bar.bg = t.base
                            if (t.base_alt) bar.bgAlt = t.base_alt
                            if (t.text) bar.fg = t.text
                            if (t.text_muted) bar.muted = t.text_muted
                            if (t.primary) bar.primary = t.primary
                            if (t.cyan) bar.cyan = t.cyan
                            if (t.green) bar.green = t.green
                            if (t.yellow) bar.yellow = t.yellow
                            if (t.red) bar.red = t.red
                        } catch (e) {}
                    }
                }
            }

            Process {
                id: weatherProc
                command: [bar.homeDir + "/.local/bin/theme-weather-data"]
                stdout: StdioCollector {
                    onStreamFinished: {
                        try {
                            let w = JSON.parse(this.text)
                            if (w.current) {
                                bar.weatherTemp = w.current.temp || "--"
                                bar.weatherIcon = w.current.icon || ""
                                bar.weatherDesc = w.current.description || "Weather"
                            }
                        } catch (e) {}
                    }
                }
            }

            Process {
                id: workspacesProc
                command: ["bash", "-c", "hyprctl workspaces -j 2>/dev/null"]
                stdout: StdioCollector {
                    onStreamFinished: {
                        try {
                            let spaces = JSON.parse(this.text)
                            bar.occupiedWorkspaces = spaces.map((w) => w.id)
                        } catch (e) {}
                    }
                }
            }

            Process {
                id: statusProc
                command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null; printf '\\n---\\n'; cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1; printf '\\n---\\n'; playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null | head -c 80"]
                stdout: StdioCollector {
                    onStreamFinished: {
                        let parts = this.text.split("\n---\n")
                        let vol = parts[0] || ""
                        let match = vol.match(/([0-9.]+)/)
                        bar.volumeText = match ? Math.round(parseFloat(match[1]) * 100) + "%" : "--"
                        let bat = (parts[1] || "").trim()
                        bar.batteryText = bat ? bat + "%" : ""
                        bar.mediaText = (parts[2] || "").trim()
                    }
                }
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    bar.timeText = Qt.formatDateTime(new Date(), "HH:mm:ss")
                    bar.dateText = Qt.formatDateTime(new Date(), "dddd, d MMMM")
                }
            }

            Timer {
                interval: 2000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: workspacesProc.running = true
            }

            Timer {
                interval: 15000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    themeProc.running = true
                    statusProc.running = true
                }
            }

            Timer {
                interval: 900000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: weatherProc.running = true
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                spacing: 5

                BarBlock {
                    width: 44
                    blockBg: bar.bg
                    blockFg: bar.green
                    borderColor: bar.muted
                    Text {
                        anchors.centerIn: parent
                        text: ""
                        color: bar.green
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 16
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached(["rofi", "-show", "drun"])
                    }
                }

                BarBlock {
                    width: 208
                    blockBg: bar.bg
                    blockFg: bar.fg
                    borderColor: bar.muted

                    Row {
                        anchors.centerIn: parent
                        spacing: 5
                        Repeater {
                            model: 5
                            Rectangle {
                                required property int index
                                property int ws: bar.workspaceStart() + index
                                width: 32
                                height: 32
                                color: bar.workspaceActive(ws) ? bar.primary : "transparent"
                                border.color: bar.workspaceOccupied(ws) ? Qt.rgba(bar.muted.r, bar.muted.g, bar.muted.b, 0.45) : "transparent"
                                border.width: 1
                                radius: 0
                                Text {
                                    anchors.centerIn: parent
                                    text: parent.ws
                                    color: bar.workspaceActive(parent.ws) ? bar.bg : (bar.workspaceOccupied(parent.ws) ? bar.fg : bar.muted)
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 13
                                    font.bold: true
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Hyprland.dispatch("workspace " + parent.ws)
                                }
                            }
                        }
                    }
                }

                BarBlock {
                    Layout.preferredWidth: 360
                    Layout.fillWidth: true
                    visible: bar.mediaText.length > 0
                    blockBg: bar.bg
                    blockFg: bar.muted
                    borderColor: bar.muted
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        text: "󰎈  " + bar.mediaText
                        color: bar.muted
                        elide: Text.ElideRight
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached(["playerctl", "play-pause"])
                    }
                }

                Item { Layout.fillWidth: true }

                BarBlock {
                    width: 276
                    blockBg: bar.bg
                    blockFg: bar.fg
                    borderColor: bar.muted

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 14
                        spacing: 8

                        Column {
                            Layout.fillWidth: true
                            spacing: 0
                            Text {
                                text: bar.timeText
                                color: bar.primary
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 16
                                font.bold: true
                            }
                            Text {
                                text: bar.dateText
                                color: bar.muted
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 10
                                font.bold: true
                            }
                        }

                        Text {
                            text: bar.weatherIcon
                            color: bar.fg
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                        }

                        Text {
                            text: bar.weatherTemp
                            color: bar.cyan
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 16
                            font.bold: true
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.execDetached([bar.homeDir + "/.local/bin/theme-weather-panel"])
                    }
                }

                BarBlock {
                    width: 92
                    blockBg: bar.bg
                    blockFg: bar.cyan
                    borderColor: bar.muted
                    Text {
                        anchors.centerIn: parent
                        text: "󰕾  " + bar.volumeText
                        color: bar.cyan
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached(["pavucontrol"])
                    }
                }

                BarBlock {
                    width: 88
                    visible: bar.batteryText.length > 0
                    blockBg: bar.bg
                    blockFg: bar.green
                    borderColor: bar.muted
                    Text {
                        anchors.centerIn: parent
                        text: "󰁹  " + bar.batteryText
                        color: bar.green
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        font.bold: true
                    }
                }
            }

            component BarBlock: Rectangle {
                property color blockBg: "#0c0d17"
                property color blockFg: "#e2e1ef"
                property color borderColor: "#908f9c"
                Layout.preferredHeight: 40
                height: 40
                color: Qt.rgba(blockBg.r, blockBg.g, blockBg.b, 0.88)
                border.color: Qt.rgba(borderColor.r, borderColor.g, borderColor.b, 0.20)
                border.width: 1
                radius: 0
            }
        }
    }
}
