import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../delegates"
import '../tabs'
import "../constants/tabs.js" as TabConstants
import "../constants/style.js" as Style
import "../components" as TopMenuBut
import "../constants/scene.js" as S

// TODO: code refactor
Rectangle {
    property string currentTab: TabConstants.gamesTab
    property var currentTabInstance: portProtonGamesTab
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

                // TODO: поменять всё на Repeater
                // слишком много дубликатов кода

                TopMenuBut.TextButton {
                    id: buttonSystemManagement;
                    text: TabConstants.systemManagementTab;
                    width: 400;
                    onClicked: function(){
                        tabButtons.x = tabButtons.tempX;
                        tabButtons.changeButtonActiveTab(this);
                        tabButtons.toggle = true;
                        tabs.currentTab = TabConstants.systemManagementTab;
                        tabs.currentTabInstance = systemManagementGrid;
                    }
                    onReleased: tabButtons.toggle = false
                }
                TopMenuBut.TextButton {
                    id: buttonGames
                    text: TabConstants.gamesTab
                    onClicked: function(){
                        tabButtons.x = tabButtons.tempX;
                        tabButtons.changeButtonActiveTab(this);
                        tabButtons.toggle = true;
                        tabs.currentTab = TabConstants.gamesTab;
                        tabs.currentTabInstance = portProtonGamesTab;

                        //if(core_app === undefined) return;
                        //console.log("core_app found");

                        //app.get_games();
                        // tabs.changeTab();
                        // ;console.log(tabs.currentTab);

                        // ;console.log("1");
                    }
                    onReleased: tabButtons.toggle = false

                }

                TopMenuBut.TextButton {
                    id: nativeGamesButton
                    text: TabConstants.nativeGamesTab
                    //font.pixelSize: 60
                    //height:Math.ceil(tabs.height/100 * 10)

                    onClicked: function(){
                        tabButtons.x = tabButtons.tempX;
                        tabButtons.changeButtonActiveTab(this);
                        tabButtons.toggle = true;
                        tabs.currentTab = TabConstants.nativeGamesTab;
                        tabs.currentTabInstance = nativeGamesTab;
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
    // Заглушка Системных настроек
    Grid {
        id: systemManagementGrid
        visible: tabs.currentTab == TabConstants.systemManagementTab

        columns: 3
        spacing: 2

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        Layout.topMargin: 190
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 90

        Rectangle {
            color: "red";
            width: 50;
            height: 50;
        }
        Rectangle {
            color: "green";
            width: 20;
            height: 50;
        }
        Rectangle {
            color: "blue";
            width: 50;
            height: 20;
        }
        Rectangle {
            color: "cyan";
            width: 50;
            height: 50;
        }
        Rectangle {
            color: "magenta";
            width: 10;
            height: 10;
        }
    }

    // PortProton Games
    GamesTab {
        id: portProtonGamesTab
        visible: tabs.currentTab == TabConstants.gamesTab
        model: core_app.games
    }

    // Native games
    GamesTab {
        id: nativeGamesTab
        visible: tabs.currentTab == TabConstants.nativeGamesTab
        model: core_app.native_games
    }




    // LOGIC

    property int focusedTabs: 0;

    function getTabs(){
        return [
            buttonSystemManagement,
            buttonGames,
            // testbut1,
            nativeGamesButton
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



    /* SIGNALS */

    function onGamepadClickedLB(args){
        tabs.applyTabsFocus(-1);
    }
    function onGamepadClickedRB(args){
        tabs.applyTabsFocus(1);
    }

    function onGamepadAxisUp(done){
        currentTabInstance.applyItemsFocusByLine(-1);
    }
    function onGamepadAxisDown(done){
        currentTabInstance.applyItemsFocusByLine(1);
    }
    function onGamepadAxisLeft(done){
        currentTabInstance.applyItemsFocus(-1);
    }
    function onGamepadAxisRight(args){
        currentTabInstance.applyItemsFocus(1);
    }
    function onGamepadClickedApply(args){
        if(window.scene !== S.homeScene) return;
        currentTabInstance.pressFocusedItem();
    }
    function onGameListDetailsRetrievingProgress(args) {
        let progress = args[0];
        if(progress === 1.0){
            portProtonGamesTab.refreshItems(core_app.games);
            nativeGamesTab.refreshItems(core_app.native_games);
        }
    }

}



/*##^##
Designer {
    D{i:0}D{i:1;invisible:true}
}
##^##*/
