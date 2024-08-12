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

    onVisibleChanged: updateTabs()

    Component.onCompleted: updateTabs()

    onWidthChanged: updateTabs()

    onHeightChanged: updateTabs()

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

                Component.onCompleted: updateTabs()

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
                function changeButtonActiveTab(ButtonId){
                    let index = 0;
                    let left_distance = 0;

                    index = tabButtons.children.findIndex(child => child === ButtonId)
                    left_distance = (spacing + children[index].width) * index

                    tempX = topNavigation.width / 2 - tabButtons.children[index].width / 2 - left_distance;
                    tabs.activeButtonTab.isActive = false;
                    tabs.activeButtonTab = ButtonId;
                    tabs.activeButtonTab.isActive = true;
                }

                // TODO: поменять всё на Repeater
                // слишком много дубликатов кода

                //TODO: задуматься о системе обращения к кнопкам
                // лучшее, что я могу предложить, это вынести функцию отдельно....

                TopMenuBut.TextButton {
                    id: buttonSystemManagement;
                    text: TabConstants.systemManagementTab;
                    onClicked: onClickedTabBut(this, TabConstants.systemManagementTab)
                    onReleased: tabButtons.toggle = false
                }
                TopMenuBut.TextButton {
                    id: buttonGames
                    text: TabConstants.gamesTab
                    onClicked: onClickedTabBut(this, TabConstants.gamesTab)
                    onReleased: tabButtons.toggle = false
                }

                TopMenuBut.TextButton {
                    id: nativeGamesButton
                    text: TabConstants.nativeGamesTab
                    onClicked: onClickedTabBut(this, TabConstants.nativeGamesTab)
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
    // System tab
    EntriesTab {
        id: systemManagementGrid
        visible: tabs.currentTab == TabConstants.systemManagementTab
        // model: core_app.system_tab ?? [] // no action here for some reason, see Component.onComplete
        // TODO: extra check here?
    }

    // PortProton Games
    GamesTab {
        id: portProtonGamesTab
        visible: tabs.currentTab == TabConstants.gamesTab
        model: core_app.games // TODO: fix TypeError: Cannot read property 'games' of null (on application closed)
    }

    // Native games
    GamesTab {
        id: nativeGamesTab
        visible: tabs.currentTab == TabConstants.nativeGamesTab
        model: core_app.native_games // TODO: fix TypeError: Cannot read property 'native_games' of null (on application closed)
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

    function updateTabs(){
        tabButtons.changeButtonActiveTab(tabs.activeButtonTab);
        tabButtons.x = tabButtons.tempX;
    }

    function onClickedTabBut(button, tabName){
        tabButtons.x = tabButtons.tempX;
        tabButtons.changeButtonActiveTab(button);
        tabButtons.toggle = true;
        tabs.currentTab = tabName;
        tabs.currentTabInstance = nativeGamesTab;
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
