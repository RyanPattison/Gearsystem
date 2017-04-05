import QtQuick 2.3
import Ubuntu.Components 1.3

MultiPointTouchArea {
    id: root
    property int unit: width / 19
    property int bsize: unit * 9

    PushButton {
        id: a
        width: bsize
        height: bsize
    }

    PushButton {
        id: b
        width: bsize
        height: bsize
        anchors.left: a.right
        anchors.leftMargin: units.gu(0.75)
    }

    onAPressed: a.press()

    onAReleased: a.release()

    onBPressed: b.press()

    onBReleased: b.release()

    property bool aIsDown: false
    property bool bIsDown: false

    signal aPressed
    signal bPressed
    signal aReleased
    signal bReleased

    onTouchUpdated: {
        var r = a.width / 2
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
