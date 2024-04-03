import QtQuick
// import QtQuick.VirtualKeyboard

// Import all components from folder
import "scenes"

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Launcher")

    HomeScene {
        id: grid
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
