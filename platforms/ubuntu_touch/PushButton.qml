import QtQuick 2.3
import Ubuntu.Components 1.3

Rectangle {
	id: root

	radius: units.gu(0.2)
	color: "#929eae"
	border.color: "#a2aab4"
	border.width: units.gu(0.25)
	anchors.left: a.right
	anchors.leftMargin: units.gu(0.75)

	Rectangle {
		id: base
		radius: width / 2
		anchors.fill: parent
		anchors.margins: units.gu(0.33)

		color: "black"
		border.width: units.gu(0.75)
		border.color: "#3c3c3c"

		Rectangle {
			id: button
			anchors.fill: parent
			anchors.margins: units.gu(1)
			color: "#464646"
			border.width: units.gu(0.33)
			border.color: "#5a5a5a"
			radius: width / 2
		}
	}

    function press() {
        button.color = Qt.darker(button.color, 1.1)
        button.scale = 0.96
    }

    function release() {
        button.color = Qt.lighter(button.color, 1.1)
        button.scale = 1
    }
}
