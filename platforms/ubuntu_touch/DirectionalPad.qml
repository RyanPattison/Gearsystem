import QtQuick 2.3
import Ubuntu.Components 1.3

Item {
    id: root
    property var direction: null
    property int dead_zone: 0

    signal rightPressed
    signal leftPressed
    signal upPressed
    signal downPressed

    signal rightReleased
    signal leftReleased
    signal upReleased
    signal downReleased

    property color red: "#980e0d"
    property color black: "#000000"
    property color gray: "#242424"
    property color white: "#c4c4c4"

    Rectangle {
        id: back
        anchors.fill: parent
        border.color: red
        border.width: units.gu(0.5)
        color: black
        radius: units.gu(3)

        Rectangle {
            id: inner
            color: gray
            radius: units.gu(2)
            anchors {
                fill: parent
                margins: units.gu(1)
            }

            border.color: white
            border.width: units.gu(0.25)
            anchors.centerIn: parent

            Rectangle {
                id: directions
                color: red
                width: back.width / 2
                height: width
                rotation: 45
                anchors.centerIn: parent
            }

            Rectangle {
                id: highlight
                color: white
                width: inner.width / 2
                height: width
                anchors.centerIn: parent

                Rectangle {
                    width: directions.width + units.gu(1)
                    height: width
                    radius: width / 2
                    color: gray
                    anchors.centerIn: parent

                    Rectangle {
                        width: parent.width * 0.667
                        height: width
                        border.color: black
                        border.width: units.gu(0.25)
                        anchors.centerIn: parent
                        color: gray
                        radius: width / 2
                    }
                }
            }
        }
    }

    function release() {
        if (direction) {
            if (direction == "left") {
                leftReleased()
            } else if (direction == "right") {
                rightReleased()
            } else if (direction == "up") {
                upReleased()
            } else if (direction == "down") {
                downReleased()
            }
            direction = null
        }
    }

    function press(dir) {
        if (dir != direction) {
            release()
            direction = dir
            if (direction == "left") {
                leftPressed()
            } else if (direction == "right") {
                rightPressed()
            } else if (direction == "up") {
                upPressed()
            } else if (direction == "down") {
                downPressed()
            }
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent

        onReleased: release()

        onCanceled: release()

        onTouchUpdated: {
            for (var i = 0; i < touchPoints.length; ++i) {
                var p = touchPoints[i]
                var dx = p.x - (width / 2)
                var dy = p.y - (height / 2)
                var xmag = dx * dx
                var ymag = dy * dy
                var deadmag = dead_zone * dead_zone

                if (xmag < deadmag && ymag < deadmag) {
                    release()
                    return
                }

                if (xmag > ymag) {
                    if (dx > 0) {
                        press("right")
                    } else {
                        press("left")
                    }
                } else {
                    if (dy > 0) {
                        press("down")
                    } else {
                        press("up")
                    }
                }
            }
        }
    }
}
