import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../delegates"
import "../constants/tabs.js" as TabConstants
import "../constants/style.js" as Style
import "../components" as TopMenuBut



Rectangle {
    property string currentTab: TabConstants.gamesTab
    property var activeButtonTab: buttonGames


    id: tabs
    x: 0
    y: 0
    width: 640
    height: 480
    color: Style.backgroundColor
    Component.onCompleted:{tabButtons.changeButtonActiveTab(tabs.activeButtonTab);tabButtons.x = tabButtons.tempX;}
    onWidthChanged: function(){tabButtons.changeButtonActiveTab(tabs.activeButtonTab);tabButtons.x = tabButtons.tempX;}
    onHeightChanged: function(){tabButtons.changeButtonActiveTab(tabs.activeButtonTab);tabButtons.x = tabButtons.tempX;}

    Image {
            id: bg
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source: '../images/bg3.svg'
        }
    // Кнопки навигации
    ColumnLayout{
        id:topNavigation
        width: parent.width
        RowLayout {
            id: tabButtons
            property int tempX: 0
            property bool toggle: false
            height: 400
            //anchors.leftMargin: parent.width / 10
            //anchors.rightMargin: parent.width / 10
            Layout.bottomMargin: buttonSystemManagement.height
            Layout.topMargin: buttonSystemManagement.height

            //x: topNavigation.width / 2 //- tabButtons.children[1].width / 2 - (spacing + tabButtons.children[0].width )
            // Состояния
            states: [
                State {name: "ClickTabButton";when:tabButtons.toggle;PropertyChanges {target: tabButtons;x:tempX}},
                State {name: "";when:1 == 1}
            ]
            // Анимации при изменениях состояний
            transitions:
                Transition  {
                    from: ""; to: "ClickTabButton"
                    PropertyAnimation{
                        id:clickTabButtonAnimation
                        //from: tempX
                        duration: 200
                        property:"x"
                        //анимациюю можно будет поменять в любое время
                        easing.type: Easing.InOutCirc
                    }
                }
            // Функция перемещения кнопок
            function changeButtonActiveTab(ButtonId){
                let index = 0
                let left_distance = 0
                for(var i = 0; i < tabButtons.children.length; ++i)
                    if(children[i]===ButtonId){
                       index = i
                       break
                    }
                for(i = 0; i < index; ++i)
                    left_distance += spacing + children[i].width
                tempX = topNavigation.width / 2 - tabButtons.children[index].width / 2 - left_distance
                tabs.activeButtonTab = ButtonId
            }

            TopMenuBut.TextButton {
                id: buttonSystemManagement
                text: TabConstants.systemManagementTab
                width: 400
                onClicked: function(){
                    tabButtons.x = tabButtons.tempX
                    tabButtons.changeButtonActiveTab(this)
                    tabButtons.toggle = true
                    tabs.currentTab = TabConstants.systemManagementTab;
                    // tabs.changeTab();
                    // console.log(tabs.urrentTab);
                }
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
                    // console.log(tabs.currentTab);
                }
                onReleased: tabButtons.toggle = false

            }
            TopMenuBut.TextButton {
                id: testbut1
                text: "Test"
                onClicked: function(){
                    tabButtons.x = tabButtons.tempX
                    tabButtons.changeButtonActiveTab(this)
                    tabButtons.toggle = true
               }
               onReleased: tabButtons.toggle = false

            }
            TopMenuBut.TextButton {
                id: testbut2
                text: "Test2"
                //font.pixelSize: 60
                //height:Math.ceil(tabs.height/100 * 10)

                onClicked: function(){
                    tabButtons.x = tabButtons.tempX
                    tabButtons.changeButtonActiveTab(this)
                    tabButtons.toggle = true
               }
                onReleased: tabButtons.toggle = false

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

        Rectangle { color: "red"; width: 50; height: 50 }
        Rectangle { color: "green"; width: 20; height: 50 }
        Rectangle { color: "blue"; width: 50; height: 20 }
        Rectangle { color: "cyan"; width: 50; height: 50 }
        Rectangle { color: "magenta"; width: 10; height: 10 }
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
            opacity:0
            position:0

            property double fromAnim: 0.0
            property double toAnim: 0.0
        }

        function scrollToY(y,HItem) {
            scrolV.fromAnim = scrolV.position
            scrolV.position = (1.0 - scrolV.size) * y/gamesScroller.height
            scrolV.toAnim = (1.0 - scrolV.size) * y/gamesScroller.height
            if(scrolV.toAnim != scrolV.fromAnim)scrollAnimation.start()
        }
        // Анимация авто скролла
        PropertyAnimation {to:scrolV.toAnim;from:scrolV.fromAnim;target:scrolV;id:scrollAnimation; property: "position" ;duration: 200 }

        GridLayout {
            id: gamesGrid
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            columns: 6
            rows: Math.max(Math.ceil(children.length / columns), 1)

            anchors.rightMargin: rowSpacing * 2
            anchors.leftMargin: rowSpacing * 2
            anchors.bottomMargin : 90
            anchors.topMargin: Math.floor( gamesScroller.width / 100 * 1.5)
            rowSpacing:Math.floor( gamesScroller.width / 100 * 1.5)
            columnSpacing: rowSpacing

            // Повторитель
            Repeater {
                model: core_app.games
                // Карточка игры
                Game {
                    gameTitle: model.name
                    gameExec: model.exec
                    gameIcon: model.icon
                    Layout.bottomMargin : (index - index % gamesGrid.columns)/ gamesGrid.columns === gamesGrid.rows-1 ? gamesGrid.rowSpacing*2 : 0
                    onFocusChanged: if(focus) { gamesScroller.scrollToY(y); }
                    Layout.preferredWidth: (gamesScroller.width - (gamesGrid.columns -1) * gamesGrid.rowSpacing - gamesGrid.anchors.rightMargin- gamesGrid.anchors.leftMargin) / gamesGrid.columns
                    Layout.preferredHeight: Layout.preferredWidth / 2 * 3
                }
            }
        }
    }





    // LOGIC
    property int focusedTabs: 0;
    property int focusedItems: 0;

    function applyTabsFocus(inc){
        if(!visible)
            return;

        let c = row.children;

        tabs.focusedTabs += inc;
        if(tabs.focusedTabs >= c.length)
            tabs.focusedTabs = 0;

        if(tabs.focusedTabs < 0)
            tabs.focusedTabs = c.length - 1;

        c[tabs.focusedTabs].forceActiveFocus();
        c[tabs.focusedTabs].clicked();

        /* if (c[i].focus) {
            console.log("focus found");
            c[i].nextItemInFocusChain().forceActiveFocus()
            break
        } */
    }

    function applyItemsFocus(inc){
        if(!gamesScroller.visible)
            return;

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

    Connections {
        target: core_app
        function onGamepadClickedLB(done){
            if(!visible) return;
            tabs.applyTabsFocus(-1)
        }
        function onGamepadClickedRB(done){
            if(!visible) return;
            tabs.applyTabsFocus(1)
        }
        function onGamepadAxisLeft(done){
            if(!visible) return;
            tabs.applyItemsFocus(-1)
        }
        function onGamepadAxisRight(done){
            if(!visible) return;
            tabs.applyItemsFocus(1)
        }
        function onGamepadClickedApply(done){
            if(!visible) return;
            let c = gamesGrid.children;
            c[tabs.focusedItems].clicked();
        }
    }

}



/*##^##
Designer {
    D{i:0}D{i:1;invisible:true}
}
##^##*/
