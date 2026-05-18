import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: root

    property string homeDir: Quickshell.env("HOME")
    property string wallpaperDir: Quickshell.env("THEME_SWITCHER_WALLPAPER_DIR") || (homeDir + "/Pictures/Wallpapers")
    property string currentName: ""
    property color bg: "#0c0d17"
    property color bgAlt: "#1e1f29"
    property color fg: "#e2e1ef"
    property color fgMuted: "#908f9c"
    property color border: "#908f9c"
    property color primary: "#bcc2ff"
    property int selectedIndex: 0
    readonly property int totalChoices: wallpapers.count + 1

    function fileUrl(path) {
        return "file://" + path.split("/").map(encodeURIComponent).join("/")
    }

    function shellQuote(value) {
        return "'" + String(value).replace(/'/g, "'\\''") + "'"
    }

    function applyWallpaper(path) {
        Quickshell.execDetached([homeDir + "/.local/bin/apply-wallpaper-theme", path])
        Qt.quit()
    }

    function applyTokyoNight() {
        Quickshell.execDetached([homeDir + "/.local/bin/theme-switcher", "tokyonight-night"])
        Qt.quit()
    }

    function clampSelected() {
        selectedIndex = Math.max(0, Math.min(selectedIndex, totalChoices - 1))
    }

    function moveSelection(delta) {
        if (totalChoices <= 0) return
        selectedIndex = (selectedIndex + delta + totalChoices) % totalChoices
        ensureSelectedVisible()
    }

    function ensureSelectedVisible() {
        Qt.callLater(function() {
            if (!scroller || totalChoices <= 0) return

            let item = selectedIndex === 0 ? tokyoCard : wallpaperRepeater.itemAt(selectedIndex - 1)
            if (!item) return

            let left = item.x
            let right = item.x + item.width
            let pad = 12

            if (left < scroller.contentX) {
                scroller.contentX = Math.max(0, left - pad)
            } else if (right > scroller.contentX + scroller.width) {
                scroller.contentX = Math.min(scroller.contentWidth - scroller.width, right - scroller.width + pad)
            }
        })
    }

    function applySelected() {
        if (selectedIndex === 0) {
            applyTokyoNight()
            return
        }

        let item = wallpaperRepeater.itemAt(selectedIndex - 1)
        if (item && item.fileName) applyWallpaper(wallpaperDir + "/" + item.fileName)
    }

    WlrLayershell.namespace: "theme-wallpaper-picker"
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

    visible: true

    FolderListModel {
        id: wallpapers
        folder: root.fileUrl(root.wallpaperDir)
        showDirs: false
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.bmp"]
        sortField: FolderListModel.Name
    }

    Process {
        id: themeReader
        command: ["bash", "-c", "cat ~/.config/theme-switcher/current.json 2>/dev/null; printf '\\n---name---\\n'; cat ~/.local/state/theme-switcher/current-name 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                let parts = this.text.split("\n---name---\n")
                if (parts.length > 1) root.currentName = parts[1].trim()

                try {
                    let theme = JSON.parse(parts[0])
                    if (theme.base) root.bg = theme.base
                    if (theme.base_alt) root.bgAlt = theme.base_alt
                    if (theme.text) root.fg = theme.text
                    if (theme.text_muted) root.fgMuted = theme.text_muted
                    if (theme.border) root.border = theme.border
                    if (theme.primary) root.primary = theme.primary
                } catch (e) {}
            }
        }
    }

    Component.onCompleted: {
        forceActiveFocus()
        themeReader.running = true
    }

    Shortcut { sequence: "Escape"; onActivated: Qt.quit() }
    Shortcut { sequence: "Left"; onActivated: root.moveSelection(-1) }
    Shortcut { sequence: "Right"; onActivated: root.moveSelection(1) }
    Shortcut { sequence: "Home"; onActivated: { root.selectedIndex = 0; root.ensureSelectedVisible() } }
    Shortcut { sequence: "End"; onActivated: { root.selectedIndex = Math.max(0, root.totalChoices - 1); root.ensureSelectedVisible() } }
    Shortcut { sequence: "Return"; onActivated: root.applySelected() }
    Shortcut { sequence: "Enter"; onActivated: root.applySelected() }
    Shortcut { sequence: "Space"; onActivated: root.applySelected() }

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
        width: Math.min(parent.width - 80, 1500)
        height: 420
        anchors.centerIn: parent
        color: root.bg
        border.color: root.border
        border.width: 2
        radius: 0
        focus: true

        Keys.onLeftPressed: root.moveSelection(-1)
        Keys.onRightPressed: root.moveSelection(1)
        Keys.onReturnPressed: root.applySelected()
        Keys.onEnterPressed: root.applySelected()
        Keys.onSpacePressed: root.applySelected()

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                spacing: 14

                Text {
                    text: "Theme"
                    color: root.primary
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    font.bold: true
                }

                Text {
                    Layout.fillWidth: true
                    text: root.currentName ? ("Current: " + root.currentName) : ""
                    color: root.fgMuted
                    elide: Text.ElideRight
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                }

                Text {
                    text: wallpapers.count + " wallpapers"
                    color: root.fgMuted
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                }
            }

            Flickable {
                id: scroller
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: cards.width
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Row {
                    id: cards
                    spacing: 12

                    ThemeCard {
                        id: tokyoCard
                        title: "Tokyo Night"
                        subtitle: "crafted"
                        bg: root.bgAlt
                        fg: root.fg
                        muted: root.fgMuted
                        accent: root.primary
                        selected: root.currentName === "Tokyo Night"
                        focused: root.selectedIndex === 0
                        choiceIndex: 0
                        onSelectedChanged: if (selected) root.selectedIndex = 0
                        onClicked: root.applyTokyoNight()

                        Rectangle {
                            anchors.fill: preview
                            color: "#1a1b26"
                            border.color: "#7aa2f7"
                            border.width: 2

                            Column {
                                anchors.centerIn: parent
                                spacing: 8

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "Tokyo"
                                    color: "#c0caf5"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 26
                                    font.bold: true
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "Night"
                                    color: "#bb9af7"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 22
                                    font.bold: true
                                }
                            }
                        }
                    }

                    Repeater {
                        id: wallpaperRepeater
                        model: wallpapers

                        ThemeCard {
                            required property string fileName
                            required property int index

                            title: fileName.replace(/\.[^.]+$/, "")
                            subtitle: "wallpaper"
                            bg: root.bgAlt
                            fg: root.fg
                            muted: root.fgMuted
                            accent: root.primary
                            selected: root.currentName === ("Wallpaper: " + fileName)
                            focused: root.selectedIndex === index + 1
                            choiceIndex: index + 1
                            onSelectedChanged: if (selected) root.selectedIndex = index + 1
                            onClicked: root.applyWallpaper(root.wallpaperDir + "/" + fileName)

                            Image {
                                anchors.fill: preview
                                source: root.fileUrl(root.wallpaperDir + "/" + fileName)
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: true
                            }
                        }
                    }
                }
            }
        }
    }

    component ThemeCard: Rectangle {
        id: card

        signal clicked()

        property alias preview: imageSlot
        property string title: ""
        property string subtitle: ""
        property color bg: "#1e1f29"
        property color fg: "#e2e1ef"
        property color muted: "#908f9c"
        property color accent: "#bcc2ff"
        property bool selected: false
        property bool focused: false
        property int choiceIndex: 0

        width: 260
        height: 318
        color: mouse.containsMouse || selected || focused ? Qt.lighter(bg, 1.18) : bg
        border.color: focused || selected ? accent : Qt.rgba(muted.r, muted.g, muted.b, 0.45)
        border.width: focused ? 3 : (selected ? 2 : 1)
        radius: 0

        Rectangle {
            id: imageSlot
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            height: 208
            color: Qt.darker(card.bg, 1.2)
            clip: true
            radius: 0
        }

        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: imageSlot.bottom
            anchors.topMargin: 12
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            text: card.title
            color: card.fg
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
            font.bold: true
        }

        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            text: card.subtitle
            color: card.muted
            horizontalAlignment: Text.AlignHCenter
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: root.selectedIndex = card.choiceIndex
            onClicked: card.clicked()
        }
    }
}
