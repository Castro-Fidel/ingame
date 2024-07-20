import QtQuick
// import QtQuick.VirtualKeyboard

// Import all components from folder
import "scenes"
import "constants/scene.js" as SceneConstants


Window {
    property string scene: SceneConstants.homeScene

    Loader {
        id: ld
        anchors.fill: parent;
    }
    FontLoader {
        id: globalFont;
        source: "./fonts/OpenSans-VariableFont.ttf"
    }
    QtObject {
        id: systemSettings;
        property string fullscreen: '1';
    }

    Connections {
        target: core_app
        function onGameStarted(done) {
            // console.log("core_app: gameStarted");
            window.scene = SceneConstants.runningScene;
        }
        function onGameEnded(done) {
            // console.log("core_app: gameEnded");
            window.scene = SceneConstants.gameInfoScene;
        }
        function onGotGameData(result) {
            // console.log(JSON.stringify(result))
            gameInfoScene.setGameData(result)
        }
        function onGamepadClickedLB(done){
            window._trigger("onGamepadClickedLB", done);
        }
        function onGamepadClickedRB(done){
            window._trigger("onGamepadClickedRB", done);
        }
        function onGamepadAxisLeft(done){
            window._trigger("onGamepadAxisLeft", done);
        }
        function onGamepadAxisRight(done){
            window._trigger("onGamepadAxisRight", done);
        }
        function onGamepadAxisUp(done){
            window._trigger("onGamepadAxisUp", done);
        }
        function onGamepadAxisDown(done){
            window._trigger("onGamepadAxisDown", done);
        }
        function onGamepadClickedApply(done){
            window._trigger("onGamepadClickedApply", done);
        }
        function onGamepadClickedBack(done){
            window._trigger("onGamepadClickedBack", done);
        }
        function onGameListDetailsRetrievingProgress(progress){
            homeScene.onGameListDetailsRetrievingProgress([progress]);
        }
    }

    function _trigger(_method, ...args){
        let scenes = {};
        scenes[SceneConstants.homeScene] = homeScene;
        scenes[SceneConstants.gameInfoScene] = gameInfoScene;
        scenes[SceneConstants.runningScene] = runningScene;

        let d = scenes[scene];

        // console.log("CALLUP " + _method);

        if(d !== null && d[_method] !== undefined && d[_method] !== null)
            d[_method](args);
    }

    function applySettings(){
        if (systemSettings.fullscreen=='1')
            visibility = Window.FullScreen
        else
            visibility = Window.Windowed
        let newSettings = {
           fullscreen: systemSettings.fullscreen
        }
        core_app.commit_settings(newSettings)
    }

    function updateSettings(settings){
        systemSettings.fullscreen = settings['fullscreen']
        applySettings()
    }

    Component.onDestruction: {
        // console.log("Desctructing window");
    }

    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Launcher")

    Component.onCompleted: {
        let settings = core_app.get_settings()
        updateSettings(settings)
    }

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
