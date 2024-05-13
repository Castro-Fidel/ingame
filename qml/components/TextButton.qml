import QtQuick
import QtQuick.Controls as C

C.Button {
    id: root
    property bool isActive: false
    hoverEnabled: true

    // width: parent.width / 100 * 1.5
    // height: 200
    // text: "Size me!"

    contentItem: Text {
        id: text
        text: root.text

        font.family: globalFont.font
        font.weight: 400
        font.styleName: globalFont.font.styleName
        font.pointSize: 16
        //font.bold : true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        // fontSizeMode: Text.Fit
        color: 'white'
        opacity: 0.8
    }

    background.opacity: 0.0
    background.anchors.margins: 0

    Rectangle {
        id: line
        color: 'white'
        height: 2
        width: 0
        anchors.horizontalCenter: root.horizontalCenter
        anchors.top: root.top
        // anchors.bottom:root.bottom
    }

    // Состояния
    states: [
        // Карточка в фокуске
        State {
            name: "active";
            when: isActive
            PropertyChanges {
                target: line;
                width: parent.width;
            }
            PropertyChanges {
                target: text;
                opacity: 1;
            }
            PropertyChanges {
                target: text;
                font.weight: 800;
            }
        },
        // На карточку навели курсор мыши
        State {
            name: "hover";
            when: hovered && !isActive
            //PropertyChanges { target: line; width: parent.width;}
            PropertyChanges {
                target: text;
                opacity: 1;
            }
        }
    ]

    // Анимации при изменениях состояний
    transitions: [
        Transition  {
            to: "active"
            reversible: true
            id:activeAnim
            ParallelAnimation {
                NumberAnimation {
                    target: line;
                    property: "width"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: text;
                    property: "opacity";
                    duration: 100
                }
            }
        },

        Transition {
            from: "";
            to: "hover"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    target: line;
                    property: "width"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: text;
                    property: "opacity";
                    duration: 100
                }
            }
        }
    ]


}
