import QtQuick
import QtQuick.Controls

import "../components"
import "../constants/scene.js" as S

Rectangle {
    property string title: "Generic title"
    property string icon: ""
    property string exec: ""

    onVisibleChanged: function(){
        // if(visible){
        if(!visible) return;
        container.setItemsFocus(1);
        // }
    }

    Keys.onEscapePressed: function(){
        if(!visible) return;
        back.clicked();
    }

    id: container
    x: 0
    y: 0
    width: 640
    height: 480

    Rectangle {
        id: rectangle
        height: 64
        color: "#2b2b2b"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
    }

    ButtonImage {
        id: back
        x: 0
        y: 0
        width: 64
        height: 64
        imageUrl: "../images/back.svg"

        onClicked: function(){
            window.scene = S.homeScene;
        }
    }

    Image {
        id: gameImage
        width: 128
        height: 128
        anchors.left: parent.left
        anchors.top: parent.top
        source: container.icon
        anchors.leftMargin: 8
        anchors.topMargin: 70
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: title
        height: 49
        text: container.title
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        font.pixelSize: 32
        anchors.leftMargin: 142
        anchors.topMargin: 70
        anchors.rightMargin: 8
    }

    Button {
        id: runGameButton
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 142
        anchors.topMargin: 125
        text: "Run game"

        onClicked: function(){
            if(core_app === undefined) return;
            core_app.start_game(container.exec);
        }
    }

    // LOGIC

    property int focusedItems: 0;

    function focusElements(){
        return [
            back,
            runGameButton
        ];
    }

    function applyItemsFocus(inc){
        let c = focusElements();
        let i = focusedItems;

        i += inc;
        if(i >= c.length)
            i = 0;

        if(i < 0)
            i = c.length - 1;

        setItemsFocus(i);
        // c[focusedItems].clicked();
    }

    function setItemsFocus(i){
        let c = focusElements();
        focusedItems = i;
        c[i].forceActiveFocus();
    }

    Connections {
        target: core_app
        function onGamepadAxisLeft(done){
            if(!visible) return;
            container.applyItemsFocus(-1)
        }
        function onGamepadAxisRight(done){
            if(!visible) return;
            container.applyItemsFocus(1)
        }
        function onGamepadClickedApply(done){
            if(!visible) return;
            let c = focusElements();
            c[container.focusedItems].clicked();
        }
        function onGamepadClickedBack(done){
            if(!visible) return;
            back.clicked();
        }
    }

}
