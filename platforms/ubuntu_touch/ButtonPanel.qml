import QtQuick 2.4
import Ubuntu.Components 1.3

Rectangle {
    id: root
    height: units.gu(5)
    radius: units.gu(0.2)
    color: "#c1393c"
    border.color: "#c64e51"
    border.width: units.gu(0.25)

    signal pressed
    signal released

    Label {
        id: label
        x: units.gu(2)
        anchors.verticalCenter: parent.verticalCenter
        text: "START"
        color: "#e6e6e6"
        fontSize: "normal"
        font.bold: true
    }

    MouseArea {
        Rectangle {
            id: button
            anchors.centerIn: parent
            color:  "#e6e6e6"
            border.color: "#cec6c6"
            border.width: units.gu(0.25)
            radius: units.gu(0.5)
            width: units.gu(7)
            height: units.gu(2)
        }
        anchors.right: parent.right
        width: parent.width / 2
        height: parent.height
        onPressed: {
            button.color = Qt.darker(button.color, 1.1)
            button.border.color = Qt.darker(button.border.color, 1.3)
            root.pressed()
        }
        onReleased: {
            button.color = Qt.lighter(button.color, 1.1)
            button.border.color = Qt.lighter(button.border.color, 1.3)
            root.released()
        }
    }
}
