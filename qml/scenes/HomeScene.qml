import QtQuick
import QtQuick.Controls

import "../components"

Rectangle {
    id: container
    x: 0
    y: 0
    width: 640
    height: 480

    onVisibleChanged: {tabs.visible = container.visible}

    // Rectangle {
    //     id: rectangle
    //     height: parent.height/100 * 5
    //     color: "black"
    //     anchors.left: parent.left
    //     anchors.right: parent.right
    //     anchors.top: parent.top
    //     anchors.rightMargin: 0
    //     anchors.leftMargin: 0
    //     anchors.topMargin: 0
    // }

    Tabs {
        id: tabs
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        //anchors.topMargin: rectangle.height
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0
    }
}
