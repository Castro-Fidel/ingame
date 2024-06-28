import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../delegates"
import "../constants/tabs.js" as TabConstants
import "../constants/style.js" as Style
import "../components" as TopMenuBut
import "../constants/scene.js" as S

// TODO: code refactor
Rectangle {
    property string currentTab: TabConstants.gamesTab
    property var activeButtonTab: buttonGames

    id: tabs
    x: 0
    y: 0
    anchors.fill: parent

    //color: Style.backgroundColor
    onVisibleChanged: {
        tabButtons.changeButtonActiveTab(tabs.activeButtonTab);
        tabButtons.x = tabButtons.tempX;
        // console.log("tabButtons.x = " + tabButtons.x);
    }

    Component.onCompleted: {
        tabButtons.changeButtonActiveTab(tabs.activeButtonTab);
        tabButtons.x = tabButtons.tempX;
        // console.log("Tabs completed!");
    }
    onWidthChanged: function(){
        tabButtons.changeButtonActiveTab(tabs.activeButtonTab);
        tabButtons.x = tabButtons.tempX;
    }
    onHeightChanged: function(){
        tabButtons.changeButtonActiveTab(tabs.activeButtonTab);
        tabButtons.x = tabButtons.tempX;
    }

    // Кнопки навигации
    ColumnLayout {
        id: topNavigation
        width: parent.width

        Rectangle {
            width: parent.width
            height: buttonSystemManagement.height
            color: "#00000000"
            Layout.bottomMargin: buttonSystemManagement.height / 2
            Layout.topMargin: buttonSystemManagement.height / 3

            Image {
                id: iconLB
                source: "../icons/XboxController/left-bumper.svg"
                fillMode: Image.Tile
                sourceSize.height: buttonGames.height * 0.75// / 10
                //sourceSize.height:
                //Layout.alignment: Qt.AlignLeft;
                anchors.leftMargin: window.width / 100 * 6
                anchors.left: parent.left
                anchors.verticalCenter: tabButtons.verticalCenter
                //Layout.leftMargin: Math.floor( parent.width / 100 * 6)
            }

            RowLayout {
                id: tabButtons
                property int tempX: 100
                property bool toggle: false

                Component.onCompleted: {
                    tabButtons.changeButtonActiveTab(tabs.activeButtonTab);
                    tabButtons.x = tabButtons.tempX;
                    // console.log("tabButtons completed!");
                }

                x: 0

                // Состояния
                states: [
                    State {
                        name: "ClickTabButton";
                        when: tabButtons.toggle;
                        PropertyChanges {
                            target: tabButtons;
                            x: tempX
                        }
                    },
                    State {
                        name: "";
                        when: 1 == 1
                    }
                ]
                // Анимации при изменениях состояний
                transitions:
                    Transition {
                        from: "";
                        to: "ClickTabButton";
                        PropertyAnimation {
                            id: clickTabButtonAnimation
                            // from: tempX
                            duration: 200
                            property: "x"
                            // анимацию можно будет поменять в любое время
                            easing.type: Easing.InOutCirc
                        }
                    }

                // Функция перемещения кнопок
                // TODO: OPTIMIZE (REDUCE EXTRA FOR LOOP)
                function changeButtonActiveTab(ButtonId){
                    let index = 0;
                    let left_distance = 0;
                    let i = 0;

                    for(i = 0; i < tabButtons.children.length; ++i) {
                        if (children[i] === ButtonId) {
                            index = i
                            break
                        }
                    }

                    for(i = 0; i < index; ++i) {
                        left_distance += spacing + children[i].width;
                    }

                    tempX = topNavigation.width / 2 - tabButtons.children[index].width / 2 - left_distance;
                    tabs.activeButtonTab.isActive = false;
                    tabs.activeButtonTab = ButtonId;
                    tabs.activeButtonTab.isActive = true;
                }

                TopMenuBut.TextButton {
                    id: buttonSystemManagement;
                    text: TabConstants.systemManagementTab;
                    width: 400;
                    /*
                    onClicked: function(){
                        tabButtons.x = tabButtons.tempX
                        tabButtons.changeButtonActiveTab(this)
                        tabButtons.toggle = true
                        tabs.currentTab = TabConstants.systemManagementTab;
                        // tabs.changeTab();
                        console.log(tabs.currentTab);
                    }
                    */
                    onReleased: tabButtons.toggle = false
                }
                TopMenuBut.TextButton {
                    id: buttonGames
                    text: TabConstants.gamesTab
                    onClicked: function(){
                        tabButtons.x = tabButtons.tempX
                        tabButtons.changeButtonActiveTab(this)
                        tabButtons.toggle = true
                        tabs.currentTab = TabConstants.gamesTab;
                        //if(core_app === undefined) return;
                        //console.log("core_app found");

                        //app.get_games();
                        // tabs.changeTab();
                        // ;console.log(tabs.currentTab);

                        // ;console.log("1");
                    }
                    onReleased: tabButtons.toggle = false

                }


            }
            Image {
                id: iconRB
                source: "../icons/XboxController/right-bumper.svg"
                fillMode: Image.Tile
                //sourceSize.width: text.font.pixelSize * 2
                sourceSize.height: buttonGames.height * 0.75// / 10
                //sourceSize.width: tabs.width / 100 * 5
                //Layout.alignment: Qt.AlignRight;
                anchors.verticalCenter: tabButtons.verticalCenter
                anchors.rightMargin: window.width / 100 * 6
                anchors.right: parent.right
            }

        }

    }
    // Заглушка Системных настроек !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    Grid {
        id: systemManagementGrid
        visible: tabs.currentTab == TabConstants.systemManagementTab

        columns: 1
        spacing: 2
        anchors.centerIn: parent

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        Layout.topMargin: 190
        // anchors.rightMargin: 0
        // anchors.leftMargin: 0
        // anchors.bottomMargin: 90

        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin : 90

        Row {
            Text {
                font.family: globalFont.font
                font.weight: 400
                font.styleName: globalFont.font.styleName
                font.pointSize: 16
                text: "Полный экран при запуске:"
                color: 'white'
                opacity: 0.8
            }
            CheckBox {
                onCheckedChanged: {
                    if (checked) {
                        window.visibility = Window.FullScreen
                    } else {
                        window.visibility = Window.Windowed
                    }
                }
            }
        }
        Row {
            Text {
                font.family: globalFont.font
                font.weight: 400
                font.styleName: globalFont.font.styleName
                font.pointSize: 16
                color: 'white'
                opacity: 0.8
                text: "Каталог PortProton"
            }
            TextField {
                id: pathTextField
                width: 150
                readOnly: true
                text: "Выберите каталог"
            }
            Button {
                width: 50
                text: "Выбрать"
                onClicked: fileDialog.open()
            }
        }
        FileDialog {
            id: fileDialog
            title: "Выберите каталог"
            currentFolder: "/"
            fileMode: FileDialog.Directory
            onAccepted: {
                pathTextField.text = fileDialog.currentFolder
            }
        }
    }

    // Сетка игр
    ScrollView {
        visible: tabs.currentTab == TabConstants.gamesTab
        id: gamesScroller
        anchors.fill: parent
        anchors.topMargin: topNavigation.height
        ScrollBar.vertical: ScrollBar {
            id: scrolV;
            height: parent.height
            opacity: 0
            position: 0

            property double fromAnim: 0.0
            property double toAnim: 0.0
        }

        function scrollToY(y,HItem) {
            scrolV.fromAnim = scrolV.position
            scrolV.position = (1.0 - scrolV.size) * y / gamesScroller.height
            scrolV.toAnim = (1.0 - scrolV.size) * y / gamesScroller.height
            if(scrolV.toAnim != scrolV.fromAnim)
                scrollAnimation.start()
        }
        // Анимация авто скролла
        PropertyAnimation {
            to: scrolV.toAnim;
            from: scrolV.fromAnim;
            target: scrolV;
            id: scrollAnimation;
            property: "position";
            duration: 200;
        }

        GridLayout {
            id: gamesGrid
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            columns: 5
            rows: Math.max(Math.ceil(children.length / columns), 1)

            anchors.rightMargin: rowSpacing * 2
            anchors.leftMargin: rowSpacing * 2
            anchors.bottomMargin : 90
            anchors.topMargin: Math.floor( gamesScroller.width / 100 * 3)
            rowSpacing: Math.floor( gamesScroller.width / 100 * 3)
            columnSpacing: rowSpacing

            // Повторитель
            Repeater {
                id: gamesGridRepeater
                model: core_app.games
                // Карточка игры
                Game {
                    id: game
                    gameTitle: model.name
                    gameExec: model.exec
                    gameIcon: model.icon
                    Layout.bottomMargin :
                        (index - index % gamesGrid.columns) /
                        gamesGrid.columns === gamesGrid.rows - 1 ? gamesGrid.rowSpacing * 2 : 0
                    onFocusChanged: if(focus) {
                        gamesScroller.scrollToY(y);
                    }
                    Layout.preferredWidth:
                        (gamesScroller.width - (gamesGrid.columns -1) *
                        gamesGrid.rowSpacing - gamesGrid.anchors.rightMargin - gamesGrid.anchors.leftMargin)
                        / gamesGrid.columns
                    Layout.preferredHeight: Layout.preferredWidth / 2 * 3

                    // Component.onCompleted: {a3.start()}

                    // SequentialAnimation  {
                    //     id:a3

                    //     NumberAnimation {
                    //         property:Layout.topMargin;
                    //         easing.type: Easing.InOutQuad;
                    //         duration: 300;
                    //         from: 100//Layout.preferredHeight;
                    //         to: 0;
                    //     }
                    //     NumberAnimation {
                    //         property:Layout.topMargin;
                    //         easing.type: Easing.InOutQuad;
                    //         duration: 300;
                    //         from: 0//Layout.preferredHeight;
                    //         to: 100;
                    //     }
                    //     loops: Animation.Infinite
                    // }

                    // Layout.topMargin: Layout.preferredHeight

                }
            }
        }
    }





    // LOGIC

    property int focusedItems: 0;
    property int focusedTabs: 0;

    function getTabs(){
        return [
            buttonSystemManagement,
            buttonGames,
            // testbut1,
            testbut2
        ];
    }

    function applyTabsFocus(inc){
        if(window.scene !== S.homeScene) return;

        let c = tabs.getTabs();

        tabs.focusedTabs += inc;
        if(tabs.focusedTabs >= c.length)
            tabs.focusedTabs = 0;

        if(tabs.focusedTabs < 0)
            tabs.focusedTabs = c.length - 1;

        let item = c[tabs.focusedTabs];
        item.released();
        item.clicked();
        // tabButtons.changeButtonActiveTab(item);
    }

    function applyItemsFocus(inc){
        if(window.scene !== S.homeScene) return;

        let c = gamesGrid.children;

        tabs.focusedItems += inc;
        if(tabs.focusedItems >= c.length)
            tabs.focusedItems = 0;

        if(tabs.focusedItems < 0)
            tabs.focusedItems = c.length - 1;

        c[tabs.focusedItems].forceActiveFocus();
        // gamesScroller.contentY = c[tabs.focusedItems].y; // not working
        // c[tabs.focusedItems].clicked();
    }

    /* SIGNALS */

    function onGamepadClickedLB(args){
        tabs.applyTabsFocus(-1)
    }
    function onGamepadClickedRB(args){
        tabs.applyTabsFocus(1)
    }
    function onGamepadAxisLeft(args){
        tabs.applyItemsFocus(-1)
    }
    function onGamepadAxisRight(args){
        tabs.applyItemsFocus(1)
    }
    function onGamepadClickedApply(args){
        if(window.scene !== S.homeScene) return;
        let c = gamesGrid.children;
        c[tabs.focusedItems].press();
    }
    function onGameListDetailsRetrievingProgress(args) {
        let progress = args[0];
        console.log(progress);
        if(progress === 1.0){
            gamesGridRepeater.model = [];
            gamesGridRepeater.model = core_app.games;
        }
    }

}



/*##^##
Designer {
    D{i:0}D{i:1;invisible:true}
}
##^##*/
