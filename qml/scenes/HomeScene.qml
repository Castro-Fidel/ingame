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
        height: 50
        color: "#2b2b2b"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
    }

    Tabs {
        id: tabs
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 48
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0
    }
}
