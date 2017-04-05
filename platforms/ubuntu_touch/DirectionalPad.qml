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

    property color red: "#c1393c"
    property color black: "#000000"
    property color gray: "#969ca4"
    property color white: "#c4c4c4"

    property real displacement: units.gu(0.75)

    Rectangle {
        id: outline
        anchors.fill: parent
        border.color: red
        border.width: units.gu(0.33)
        radius: units.gu(1)
        color: "transparent"

        Rectangle {
            id: back
            color: gray
            anchors.fill: parent
            anchors.margins: units.gu(0.5)

            Rectangle {
                id: forwardSlash
                color: "#1b1b21"
                width: parent.width * Math.sqrt(2)
                height: units.gu(0.5)
                rotation: 45
                anchors.centerIn: parent
            }

            Rectangle {
                id: backSlash
                color: "#1b1b21"
                width: parent.width * Math.sqrt(2)
                height: units.gu(0.5)
                rotation: -45
                anchors.centerIn: parent
            }

            Label {
                text: "▲"
                color: "white"
                anchors {
                    verticalCenter: back.verticalCenter
                    left: back.left
                    leftMargin: units.gu(0.1)
                }
                fontSize: "x-small"
                rotation: -90
            }

            Label {
                text: "▲"
                color: "white"
                anchors {
                    verticalCenter: back.verticalCenter
                    right: back.right
                    rightMargin: units.gu(0.1)
                }
                fontSize: "x-small"
                rotation: 90
            }

            Label {
                text: "▲"
                color: "white"
                anchors {
                    horizontalCenter: back.horizontalCenter
                    top: back.top
                    topMargin: -units.gu(0.1)
                }
                fontSize: "x-small"
                rotation: 0
            }

            Label {
                text: "▲"
                color: "white"
                anchors {
                    horizontalCenter: back.horizontalCenter
                    bottom: back.bottom
                    bottomMargin: -units.gu(0.1)
                }
                fontSize: "x-small"
                rotation: 180
            }

            Rectangle {
                id: bezel
                color: "black"
                border.color: "#373737"
                radius: units.gu(2)
                border.width: units.gu(0.5)
                anchors.fill: parent
                anchors.margins: units.gu(1.5)

                Rectangle {
                    id: inner
                    color: "#3c3c3c"
                    radius: units.gu(1)
                    anchors.fill: parent
                    anchors.margins: units.gu(0.75)
                    border.color: "#555555"
                    border.width: units.gu(0.25)
                    anchors.centerIn: parent

                    Item {
                        id: moveGroup
                        width: parent.width
                        height: parent.height

                        Rectangle {
                            id: hbar
                            color: "#505050"
                            width: back.width * 0.60
                            height: units.gu(0.67)
                            anchors.centerIn: parent
                        }

                        Rectangle {
                            id: vbar
                            color: "#505050"
                            height: back.width * 0.60
                            width: units.gu(0.67)
                            anchors.centerIn: parent
                        }

                        Rectangle {
                            id: highlight
                            color: "#323232"
                            anchors.fill: parent
                            anchors.margins: units.gu(2.5)
                            radius: width / 2

                            Rectangle {
                                id: cover
                                anchors {
                                    fill: parent
                                    margins: units.gu(2)
                                }

                                border.color: "#282828"
                                border.width: units.gu(0.25)
                                anchors.centerIn: parent
                                color: "#3c3c3c"
                                radius: width / 2
                            }
                        }
                    }
                }
            }
        }
    }

    onLeftPressed: {
        moveGroup.x -= displacement
    }

    onRightPressed: {
        moveGroup.x += displacement
    }

    onUpPressed: {
        moveGroup.y -= displacement
    }

    onDownPressed: {
        moveGroup.y += displacement
    }

    onLeftReleased: {
        moveGroup.x += displacement
    }

    onRightReleased: {
        moveGroup.x -= displacement
    }

    onUpReleased: {
        moveGroup.y += displacement
    }

    onDownReleased: {
        moveGroup.y -= displacement
    }

    function release() {
        if (direction) {
            if (direction === "left") {
                leftReleased()
            } else if (direction === "right") {
                rightReleased()
            } else if (direction === "up") {
                upReleased()
            } else if (direction === "down") {
                downReleased()
            }
            direction = null
        }
    }

    function press(dir) {
        if (dir !== direction) {
            release()
            direction = dir
            if (direction === "left") {
                leftPressed()
            } else if (direction === "right") {
                rightPressed()
            } else if (direction === "up") {
                upPressed()
            } else if (direction === "down") {
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
