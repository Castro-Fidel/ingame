import QtQuick
import "../constants/scene.js" as SceneConstants
import "../components/" as C

C.Button {
    property string gameTitle: "Generic title"
    property string gameIcon: ""
    property string gameExec: ""

    id: game
    width: 256
    height: 256
    implicitWidth: 256
    implicitHeight: 256
    text: ""
    // color: "#efefef"
    //radius: 5
    // border.width: 1

    onClicked: function(){
        // console.log(game.title);
        gameInfoScene.title = game.gameTitle;
        gameInfoScene.icon = game.gameIcon;
        gameInfoScene.exec = game.gameExec;

        window.scene = SceneConstants.gameInfoScene;
    }

    Image {
        id: image
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        source: game.gameIcon
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
        text: game.gameTitle
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
