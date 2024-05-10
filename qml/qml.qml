import QtQuick
// import QtQuick.VirtualKeyboard

// Import all components from folder
import "scenes"
import "constants/scene.js" as SceneConstants

Window {
    property string scene: SceneConstants.homeScene

    Loader{
         id : ld
         anchors.fill: parent;
    }
    FontLoader { id: globalFont; source: "./fonts/OpenSans-VariableFont_wdth.ttf" }


    Connections {
        target: core_app
        function onGameStarted(done) {
            console.log("core_app: gameStarted");
            window.scene = SceneConstants.runningScene;
        }
        function onGameEnded(done) {
            console.log("core_app: gameEnded");
            window.scene = SceneConstants.gameInfoScene;
        }
        function onGamepadClickedLB(done){
            // console.log("core_app: onGamepadClickedLB");
        }
        function onGamepadClickedRB(done){
            // console.log("core_app: onGamepadClickedRB");
        }
        function onGamepadAxisLeft(done){
            // console.log("core_app: onGamepadAxisLeft");
        }
        function onGamepadAxisRight(done){
            // console.log("core_app: onGamepadAxisRight");
        }
        function onGamepadClickedApply(done){
            // console.log("core_app: onGamepadClickedApply");
        }
    }

    Component.onDestruction: {
        console.log("Desctructing window");
    }

    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Launcher")

    Image {
        id: bg
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: './images/bg3.svg'
    }

    // Решение бага с изменением положений кнопок вкладок через opacity и enabled - ЭТО КОСТЫЛЬ!!!
    HomeScene {
        // visible: scene == SceneConstants.homeScene
        opacity: scene == SceneConstants.homeScene
        enabled: scene == SceneConstants.homeScene

        id: homeScene
        anchors.fill: parent

        Behavior on opacity {
            NumberAnimation {
                target: homeScene;
                property: "opacity";
                duration: 300;
            }
        }
    }

    GameInfoScene {
        // visible: scene == SceneConstants.gameInfoScene
        opacity: scene == SceneConstants.gameInfoScene
        enabled: scene == SceneConstants.gameInfoScene

        id: gameInfoScene
        anchors.fill: parent

        Behavior on opacity {
            NumberAnimation {
                target: gameInfoScene;
                property: "opacity";
                duration: 300;
            }
        }
    }

    RunningScene {
        // visible: scene == SceneConstants.runningScene
        opacity: scene == SceneConstants.runningScene
        enabled: scene == SceneConstants.runningScene

        id: runningScene
        anchors.fill: parent
    }



    /* InputPanelHomeScene {
        id: inputPanel
        z: 99
        x: 0
        y: window.height
        width: window.width

        states: StateHomeScene {
            name: "visible"
            when: inputPanel.active
            PropertyChangesHomeScene {
                target: inputPanel
                y: window.height - inputPanel.height
            }
        }
        transitions: TransitionHomeScene {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimationHomeScene {
                NumberAnimationHomeScene {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    } */
}
