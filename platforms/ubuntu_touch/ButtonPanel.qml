import QtQuick 2.4
import Ubuntu.Components 1.3

Rectangle {
    id: root
    height: units.gu(5)

    color: red

    signal pressed
    signal released

    Label {
        x: units.gu(1)
        anchors {
            verticalCenter: parent.verticalCenter
        }

        text: "START"
        color: white
        fontSize: "medium"
        font {
            bold: true
            italic: true
        }
    }

    Rectangle {
        anchors {
            right: parent.right
            rightMargin: units.gu(1)
            verticalCenter: parent.verticalCenter
        }

        width: units.gu(8)
        height: units.gu(2)
        color: white
        border.color: gray
        border.width: units.gu(0.25)
        radius: units.gu(1)

        MouseArea {
            anchors {
                fill: parent
            }
            onPressed: root.pressed()
            onReleased: root.released()
        }
    }
}
