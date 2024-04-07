import QtQuick
import "../constants/scene.js" as SceneConstants

Rectangle {
    property string title: "Generic title"
    property string icon: ""
    property string exec: ""

    id: game
    width: 256
    height: 256
    color: "#efefef"
    radius: 5
    border.width: 1

    MouseArea {
        anchors.fill: parent

        onClicked: function(){
            // console.log(game.title);
            gameInfoScene.title = game.title;
            gameInfoScene.icon = game.icon;
            gameInfoScene.exec = game.exec;

            window.scene = SceneConstants.gameInfoScene;
        }
    }

    Image {
        id: image
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        source: game.icon
        anchors.rightMargin: 8
        anchors.bottomMargin: 47
        anchors.leftMargin: 8
        anchors.topMargin: 8
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: title
        y: 439
        height: 33
        text: game.title
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        anchors.rightMargin: 8
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
    }

    
}
