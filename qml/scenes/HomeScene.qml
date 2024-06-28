import QtQuick
import QtQuick.Controls

import "../components"

Rectangle {
    id: container
    x: 0
    y: 0
    anchors.fill: parent

    color: "#00000000"


    onVisibleChanged: {
        tabs.visible = container.visible;
    }

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
        color: "#00000000"

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

    function onGamepadClickedLB(args){
        tabs.onGamepadClickedLB(args)
    }
    function onGamepadClickedRB(args){
        tabs.onGamepadClickedRB(args)
    }
    function onGamepadAxisLeft(args){
        tabs.onGamepadAxisLeft(args)
    }
    function onGamepadAxisRight(args){
        tabs.onGamepadAxisRight(args)
    }
    function onGamepadClickedApply(args){
        tabs.onGamepadClickedApply(args)
    }
    function onGameListDetailsRetrievingProgress(args){
        tabs.onGameListDetailsRetrievingProgress(args)
    }

}
