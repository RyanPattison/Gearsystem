import QtQuick 2.3
import Qt.labs.settings 1.0

import Ubuntu.Components 1.3
import Ubuntu.Content 1.3
import Ubuntu.Components.Popups 1.3

import GearSystem 1.0

MainView {
    id: root
    height: units.gu(80)
    width: units.gu(45)

    applicationName: "gearsystem.rpattison"

    property color red: "#980e0d"
    property color black: "#1b1b21"
    property color gray: "#242424"
    property color white: "#c4c4c4"
    property color blue: "#0632d0"

    property var activeTransfer: null

    property bool muted: false
    property bool haptics: true

    onMutedChanged: {
        emu.mute(muted)
    }

    function click() {
        if (root.haptics) {
            Haptics.play()
        }
    }

    ContentPeerModel {
        id: model
        contentType: ContentType.Documents
        handler: ContentHandler.Source
    }

    Connections {
        target: ContentHub
        onImportRequested: {
            root.importItems(transfer.items)
        }
    }

    GearSystemEmulator {
        id: emu
        color: "#1b1b21"
    }

    function importItems(items) {
        load(items[0].url)
    }

    function load(url) {
        var path = url.toString().replace("file://", "")
        console.log(path)
        if (path) {
            if (emu.loadRom(path)) {
                help.visible = false
                emu.play()
            } else {
                help.text = i18n.tr("ROM failed to load")
                help.visible = true
            }
        }
    }

    function requestROM() {
        var peer = null
        for (var i = 0; i < model.peers.length; ++i) {
            var p = model.peers[i]
            var s = p.appId
            if (s.indexOf("filemanager") !== -1) {
                peer = p
            }
        }
        if (peer != null) {
            root.activeTransfer = peer.request()
        } else if (model.peers.length > 0) {
            picker.visible = true // didn't find ubuntu's file manager, maybe they have another app
        } else {
            if (emu.requestRom()) {
                help.visible = false
                emu.play()
            } else {
                help.text = i18n.tr("ROM failed to load")
                help.visible = true
            }
        }
    }

    Component.onCompleted: {
        btns.aPressed.connect(emu.aPressed)
        btns.aReleased.connect(emu.aReleased)

        btns.bPressed.connect(emu.bPressed)
        btns.bReleased.connect(emu.bReleased)

        start.pressed.connect(emu.startPressed)
        start.released.connect(emu.startReleased)

        dpad.upPressed.connect(emu.upPressed)
        dpad.upReleased.connect(emu.upReleased)

        dpad.downPressed.connect(emu.downPressed)
        dpad.downReleased.connect(emu.downReleased)

        dpad.leftPressed.connect(emu.leftPressed)
        dpad.leftReleased.connect(emu.leftReleased)

        dpad.rightPressed.connect(emu.rightPressed)
        dpad.rightReleased.connect(emu.rightReleased)
    }

    Component.onDestruction: {
        console.log("shutdown")
        emu.shutdown()
    }

    Label {
        id: help
        text: i18n.tr("OPEN ROM…")
        font.pixelSize: units.gu(6)
        color: "#c6393c"
        anchors.centerIn: loaderArea
        font.bold: true
    }


    MouseArea {
        id: loaderArea
        width: emu.rect.width * 0.8
        height: emu.rect.height * 0.9 // keep some padding away from buttons
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        onClicked: requestROM()
    }

    Item {
        id: lefthand
        width: units.gu(19)
        height: units.gu(35)

        anchors.left: parent.left
        anchors.bottom: parent.bottom

        DirectionalPad {
            id: dpad
            x: 0
            y: 0
            width: units.gu(19)
            height: units.gu(19)
            onLeftPressed: click()
            onRightPressed: click()
            onUpPressed: click()
            onDownPressed: click()
        }
    }

    Item {
        id: righthand
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: units.gu(19)
        height: units.gu(35)

        ButtonPanel {
            id: start
            y: units.gu(2)
            width: parent.width
            height: units.gu(4)

            onPressed: click()
        }

        ButtonPad {
            id: btns
            y: units.gu(7)
            width: parent.width
            height: units.gu(18)

            onAPressed: click()
            onBPressed: click()
        }
    }

    Rectangle {
        id: picker
        anchors.fill: parent
        visible: false

        ContentPeerPicker {
            id: peerPicker
            visible: parent.visible
            handler: ContentHandler.Source
            contentType: ContentType.Documents

            onPeerSelected: {
                peer.contentType = ContentType.Documents
                peer.selectionType = ContentTransfer.Single
                root.activeTransfer = peer.request()
                picker.visible = false
            }

            onCancelPressed: {
                console.log("load canceled")
                picker.visible = false
                emu.play()
            }
        }
    }

    Connections {
        target: root.activeTransfer
        onStateChanged: {
            if (root.activeTransfer.state === ContentTransfer.Charged) {
                root.importItems(root.activeTransfer.items)
            } else if (root.activeTransfer.state === ContentTransfer.Aborted) {
                emu.play()
                picker.visible = false
                console.log("aborted transfer")
            }
        }
    }

    Settings {
        id: gameSettings
        property bool vibrate: root.haptics
        property bool sound: !root.muted
        onSoundChanged: {
            root.muted = !sound
        }
        onVibrateChanged: {
            root.haptics = vibrate
        }
    }

    Icon {
        name: gameSettings.sound ? "speaker" : "speaker-mute"
        color: "#e6e6e6"
        width: units.gu(4)
        height: units.gu(4)
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: units.gu(1.5)
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                click()
                gameSettings.sound = !gameSettings.sound
            }
        }
    }
}
