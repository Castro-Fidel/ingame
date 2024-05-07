import QtQuick
import QtQuick.Controls

import "../components"
import "../constants/scene.js" as S

Rectangle {
    id: container
    x: 0
    y: 0
    width: 640
    height: 480


    property string title: "Generic title"
    property string icon: ""
    property string exec: ""
    // поля для анимации при открытии
    property double startX: 0
    property double startY: 0
    // поля свойств изображения
    property double imgWight: 0
    property double imgHight: 0

     function startAnimation(){



         startPos.x = startX
         startPos.y = startY
         gameRect.anchors.left = startPos.left
         gameRect.anchors.top = startPos.top


         container.state = "completed"



    }
     states:[
        State {
            name: "finish"
            AnchorChanges {
                target: gameRect;
                anchors.left: startPos.left
                anchors.top: startPos.top
            }
        },
        State {
            name: "completed"
            AnchorChanges {
                target: gameRect;
                anchors.left: finishPos.left
                anchors.top: finishPos.top
            }
         }
     ]

         transitions: Transition {
             // smoothly reanchor myRect and move into new position
             AnchorAnimation { duration: 300 }
         }



    onVisibleChanged: function(){
        // if(visible){
        if(window.scene !== S.gameInfoScene) return;
        container.setItemsFocus(0);
        // }
    }

    Keys.onEscapePressed: function(){
        if(window.scene !== S.gameInfoScene) return;
        back.clicked();
    }




    // Start pos
    Item {
        id: startPos
        x: startX
        y: startY

    }
    // finish pos
    Item {
        id: finishPos
        anchors.left: gameRect.parent.left
        anchors.top: gameRect.parent.top

        anchors.leftMargin: 8
        anchors.topMargin: 70
    }



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
            //gameRect.anchors.leftMargin= 0
            //gameRect.anchors.topMargin= 0

            container.state = "finish"

        }
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
            if(window.scene !== S.gameInfoScene) return;
            if(core_app === undefined) return;
            core_app.start_game(container.exec);
        }
    }

    // LOGIC

    property int focusedItems: 0;

    function focusElements(){
        return [
            runGameButton,
            back
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
            if(window.scene !== S.gameInfoScene) return;
            container.applyItemsFocus(-1)
        }
        function onGamepadAxisRight(done){
            if(window.scene !== S.gameInfoScene) return;
            container.applyItemsFocus(1)
        }
        function onGamepadClickedApply(done){
            if(window.scene !== S.gameInfoScene) return;
            let c = focusElements();
            c[container.focusedItems].clicked();
        }
        function onGamepadClickedBack(done){
            if(window.scene !== S.gameInfoScene) return;
            back.clicked();
        }
    }




    Rectangle{
        id:gameRect
        width: imgWight
        height: imgHight
        color:"#000000"





        Image {
            id: gameImage
            anchors.fill: parent

            source: container.icon
            fillMode: Image.PreserveAspectFit

        }


        Behavior on x {
            NumberAnimation {
                target: gameRect;
                property: "x";
                duration: 300;
            }
        }
        Behavior on y {
            NumberAnimation {
                target: gameRect;
                property: "y";
                duration: 300;
            }
        }

    }

}
