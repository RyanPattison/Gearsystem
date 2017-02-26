import QtQuick 2.3
import Ubuntu.Components 1.3

MultiPointTouchArea {
    id: root
    property int unit: width / 19
    property int bsize: unit * 9

    property color red: "#980e0d"
    property color black: "#000000"
    property color gray: "#242424"
    property color white: "#c4c4c4"

    property real outline: units.gu(0.375)

    Rectangle {
        id: a
        width: bsize
        height: width
        radius: bsize / 2
        color: black
        border.width: 10
        border.color: red

        Rectangle {
            width: parent.width - units.gu(1)
            height: width
            radius: width / 2
            color: gray
            anchors.centerIn: parent
            border.width: units.gu(0.5)
            border.color: white
            Label {
                anchors.centerIn: parent
                color: white
                text: "1"
                fontSize: "x-large"
                font.bold: true
                font.italic: true
            }
        }
    }

    Rectangle {
        id: b
        x: root.width / 2
        width: bsize
        height: width
        radius: bsize / 2
        color: black
        border.width: 10
        border.color: red

        Rectangle {
            width: parent.width - units.gu(1)
            height: width
            radius: width / 2
            color: gray
            anchors.centerIn: parent
            border.width: units.gu(0.5)
            border.color: white
            Label {
                anchors.centerIn: parent
                color: white
                text: "2"
                fontSize: "x-large"
                font.bold: true
                font.italic: true
            }
        }
    }

    onAPressed: {

        //  a.border.color = gb_purple_pressed;
        // a.color = gb_purple_accent;
    }

    onAReleased: {

        //    a.border.color = gb_purple_accent;
        //   a.color = gb_purple;
    }

    onBPressed: {

        //      b.border.color = gb_purple_pressed;
        //     b.color = gb_purple_accent;
    }

    onBReleased: {

        //        b.border.color = gb_purple_accent;
        //       b.color = gb_purple;
    }

    property bool aIsDown: false
    property bool bIsDown: false

    signal aPressed
    signal bPressed
    signal aReleased
    signal bReleased

    onTouchUpdated: {
        var r = a.radius
        var ax = a.x + r
        var bx = b.x + r
        var by = b.y + r
        var ay = a.y + r
        var r2 = r * r

        var aDown = false
        var bDown = false

        for (var i in touchPoints) {
            var pt = touchPoints[i]
            if (pt.pressed) {
                var dax = ax - pt.x
                var day = ay - pt.y
                var dbx = bx - pt.x
                var dby = by - pt.y

                if (dax * dax + day * day <= r2) {
                    aDown = true
                }

                if (dbx * dbx + dby * dby <= r2) {
                    bDown = true
                }
            }
        }

        if (aDown != aIsDown) {
            if (!aDown) {
                aReleased()
            } else if (!aIsDown) {
                aPressed()
            }
            aIsDown = aDown
        }

        if (bDown != bIsDown) {
            if (!bDown) {
                bReleased()
            } else if (!bIsDown) {
                bPressed()
            }
            bIsDown = bDown
        }
    }
}
