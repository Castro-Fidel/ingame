import QtQuick
import QtQuick.Controls

import "../components"

Rectangle {
    id: container
    x: 0
    y: 0
    width: 640
    height: 480

    Rectangle {
        id: rectangle
        color: "#2b2b2b"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Text {
            id: text1
            color: "#ffffff"
            text: qsTr("Game is now running...")
            anchors.fill: parent
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
        }
    }

}
