import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


//import "../components"
import "../constants/controller.js" as ControllerButtons
import "../constants/scene.js" as S

Rectangle {
    id: root
    x: 0
    y: 0
    anchors.fill: parent
    color: "#00000000"

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
        runGameButton.focus = true
        root.state = "completed";


        let v = core_app.get_game_data(root.title);

        let _t = v['title'];
        let _d = v['desc'];
        let _l = v['languages'];
        let _r = v['reqs'];
        // console.log(_t, _d, _l, _r);
        let pretty_title = ((_t === undefined) ? "Нет информации об игре" : _t);
        let pretty_description = ((_d === undefined) ? "Нет информации об игре" : _d);
        description.text = "Наименование игры:\n" + pretty_title + "\n\nОписание игры:\n" + pretty_description;
    }

    states: [
        State {
            name: "finish"
            AnchorChanges {
                target: gameRect;
                anchors.left: startPos.left
                anchors.top: startPos.top
            }
            PropertyChanges {
                target: gameRect
                width: imgWight
                height: imgHight
            }
        },
        State {
            name: "completed"
            AnchorChanges {
                target: gameRect;
                anchors.left: finishPos.left
                anchors.top: finishPos.top
            }
            PropertyChanges {
                target: gameRect
                width: finishPos.width
                height: finishPos.height
            }
        }
    ]

    transitions: Transition {
        AnchorAnimation {
            duration: 300
        }
    }

    onVisibleChanged: function(){
        // if(visible){
        if(window.scene !== S.gameInfoScene) return;
        root.setItemsFocus(0);
        // console.log("Game data: ", v, _t, _d, _l, _r);

        // }
    }

    Keys.onEscapePressed: function(){
        if(window.scene !== S.gameInfoScene) return;
        back.clicked();
    }


    ColumnLayout{
        // anchors.fill:parent
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.fill: parent
        id: content

        anchors.leftMargin: parent.width / 100 * 3
        anchors.rightMargin: parent.width / 100 * 3
        anchors.topMargin: parent.height / 100 * 3

        spacing: 6
        ItemGroup{
            id: topPanel
            Button {
                id: back
                background.opacity: 0.0
                opacity: 0.8
                text: "Back"
                width: text.contentWidth + backImg.width + 5
                hoverEnabled: true
                contentItem: Text {
                    id: text
                    text: back.text
                    font.pixelSize: Math.max(19, root.height / 100 * 3.2)

                    font.family: globalFont.font
                    font.weight: 500
                    font.styleName: globalFont.font.styleName
                    color: 'white'
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: backImg.right
                }
                Image {
                    id: backImg
                    source: "../icons/back.svg"
                    fillMode: Image.Tile
                    sourceSize.width: text.font.pixelSize * 2
                    sourceSize.height: text.font.pixelSize * 2
                    anchors.verticalCenter: back.verticalCenter
                    anchors.rightMargin: 5
                }
                onClicked: function(){
                   window.scene = S.homeScene;
                   root.state = "finish"
                }
                // Состояния
                states: [
                    // Карточка в фокуске
                    State {
                        name: "focus";
                        when: back.activeFocus
                        PropertyChanges {
                            target: back;
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
                        when: back.hovered
                        PropertyChanges {
                            target: back;
                            opacity: 1;
                        }
                    }
                ]
                // Анимации при изменениях состояний
                transitions: Transition  {
                    //to: "focus"
                    reversible: true
                    NumberAnimation {
                        // target: back;
                        property: "opacity";
                        duration: 100
                    }
                }
            }
        }
        Rectangle{
            // Start pos
            Layout.fillWidth: true
            Layout.fillHeight: true
            color : "#00000000"

            //width: parent.width
            Item {
                id: startPos
                x: startX
                y: startY
            }
            // finish pos
            Rectangle {
                id: finishPos
                //enabled: false
                anchors.left: gameRect.parent.left
                anchors.top: gameRect.parent.top
                anchors.leftMargin: root.width / 100 * 3
                anchors.topMargin: root.width / 100 * 3
                width: height / 3 * 2 //root.width / 100 * 20
                height: root.height / 2   //width / 2 * 3
                color: "#00000000"
            }

            Rectangle {
                id: gameRect
                width: imgWight
                height: imgHight
                color: "#000000"
                Image {
                    id: gameImage
                    anchors.fill: parent
                    source: root.icon
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

            RowLayout {
                id: info
                width: parent.width - finishPos.width - root.width / 100 * 6
                anchors.left: finishPos.right
                anchors.top: finishPos.top
                anchors.leftMargin: root.width / 100 * 3
                ColumnLayout {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 40

                    Text {
                        id: title
                        Layout.maximumWidth: root.width / 100 * 30
                        font.weight: 600
                        wrapMode: Text.Wrap
                        text: root.title
                        font.pixelSize: Math.max(19, root.height / 100 * 4.2)
                        color: "white"
                    }

                    Button {
                        id: runGameButton
                        focus: true

                        //background.opacity: 0.2
                        leftPadding: textGame.font.pixelSize * 3
                        rightPadding: leftPadding
                        topPadding: leftPadding / 8
                        bottomPadding: leftPadding / 8

                        //opacity: 0.8
                        text: "Play"
                        width: textGame.contentWidth + 5
                        hoverEnabled: true
                        contentItem: Text {
                            id: textGame
                            text: runGameButton.text
                            font.pixelSize: Math.max(19, root.height / 100 * 3)

                            font.family: globalFont.font
                            font.weight: 800
                            font.styleName: globalFont.font.styleName
                            color: 'white'
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                        padding: 10

                        background: Rectangle {
                            id: runGameBg
                            color: "white" //control.down ? "#aaaaaa" : (control.activeFocus ? "#aaaaaa" : "#000000")
                            opacity: 0.1
                            radius: runGameButton.width * 0.3
                        }

                        onClicked: function(){
                            if(window.scene !== S.gameInfoScene) return;
                            if(core_app === undefined) return;
                            core_app.start_game(root.exec);
                        }
                        // Состояния
                        states: [
                            // Карточка в фокуске
                            State {
                                name: "focus";
                                when: runGameButton.activeFocus
                                PropertyChanges {
                                    target: runGameBg;
                                    opacity: 1;
                                }
                                PropertyChanges {
                                    target: textGame;
                                    font.weight: 800;
                                    color: "black"
                                }
                            },
                            // На карточку навели курсор мыши
                            State {
                                name: "hover";
                                when: runGameButton.hovered
                                PropertyChanges {
                                    target: runGameBg;
                                    opacity: 1;
                                }
                                PropertyChanges {
                                    target: textGame;
                                    color: "black"
                                }
                            }
                        ]
                        // Анимации при изменениях состояний
                        transitions: Transition  {
                            reversible: true
                            NumberAnimation {
                                property: "opacity";
                                duration: 300
                            }
                        }
                    }
                }

                Text {
                    horizontalAlignment: Text.AlignJustif
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    id: description
                    Layout.maximumWidth: root.width / 100 * 30
                    Layout.maximumHeight: root.height / 100 * 70
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    text:
                        "..."
                    font.pixelSize: Math.max(13, root.height / 100 * 2.2)
                    color: "white"
                }

            }

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


    function onGamepadAxisLeft(done){
        if(window.scene !== S.gameInfoScene) return;
        root.applyItemsFocus(-1)
    }
    function onGamepadAxisRight(done){
        if(window.scene !== S.gameInfoScene) return;
        root.applyItemsFocus(1)
    }
    function onGamepadClickedApply(done){
        if(window.scene !== S.gameInfoScene) return;
        let c = focusElements();
        c[root.focusedItems].clicked();
    }
    function onGamepadClickedBack(done){
        if(window.scene !== S.gameInfoScene) return;
        back.clicked();
    }






}
