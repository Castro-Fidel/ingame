import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../delegates"
import "../constants/tabs.js" as TabConstants
import "../constants/style.js" as Style
import "../components" as TopMenuBut



Rectangle {
    // PROPERTIES
    property string currentTab: TabConstants.gamesTab

    // FIELDS
    id: tabs
    x: 0
    y: 0
    width: 640
    height: 480
    color: Style.backgroundColor

    // onWidthChanged: { console.log("Window Width changed: " + width) }
    // onHeightChanged: { console.log("Window Height changed: " + height)}

    // COMPONENTS
    RowLayout {
        id: row
        spacing: 5
        //width: parent.width
        anchors.leftMargin: parent.width / 10
        anchors.rightMargin: parent.width / 10
        anchors.bottomMargin: buttonSystemManagement.height / 6
        anchors.topMargin: buttonSystemManagement.height / 6
        Layout.alignment: Qt.AlignHCenter

        height: buttonSystemManagement.height + anchors.bottomMargin + anchors.topMargin


        //padding: 0



        TopMenuBut.Button {

            id: buttonSystemManagement
            text: TabConstants.systemManagementTab
            //Layout.preferredHeight: 30
            onClicked: function(){
                tabs.currentTab = TabConstants.systemManagementTab;
                // tabs.changeTab();
                // console.log(tabs.currentTab);
            }
        }

        TopMenuBut.Button {
            //anchors.horizontalCenter: parent.horizontalCenter
            id: buttonGames
            text: TabConstants.gamesTab
            //Layout.preferredHeight: 30
            onClicked: function(){
                tabs.currentTab = TabConstants.gamesTab;
                //if(core_app === undefined) return;
                //console.log("core_app found");

                //app.get_games();
                // tabs.changeTab();
                // console.log(tabs.currentTab);
            }
        }
    }

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


    ScrollView {
        visible: tabs.currentTab == TabConstants.gamesTab
        id: gamesScroller
        anchors.fill: parent
        anchors.topMargin: row.height
        ScrollBar.vertical: ScrollBar {
            id: scrolV;
            height: parent.height
            opacity:0

            property double fromAnim: 0.0
            property double toAnim: 0.0
        }

        function scrollToY(y,HItem) {
            scrolV.fromAnim = scrolV.position
            scrolV.position = (1.0 - scrolV.size) * y/gamesScroller.height
            scrolV.toAnim = (1.0 - scrolV.size) * y/gamesScroller.height
            if(scrolV.toAnim != scrolV.fromAnim)scrollAnimation.start()
        }
        PropertyAnimation {to:scrolV.toAnim;from:scrolV.fromAnim;target:scrolV;id:scrollAnimation; property: "position" ;duration: 200 }


        GridLayout {
            id: gamesGrid
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            columns: 6
            rows: Math.max(Math.ceil(children.length / columns), 1)

            anchors.rightMargin: rowSpacing
            anchors.leftMargin: rowSpacing
            anchors.bottomMargin : 90
            anchors.topMargin: Math.floor( gamesScroller.width / 100 * 1.5)
            rowSpacing:Math.floor( gamesScroller.width / 100 * 1.5)
            columnSpacing: rowSpacing

            Repeater {
                model: core_app.games
                Game {

                    gameTitle: model.name
                    gameExec: model.exec
                    gameIcon: model.icon
                    Layout.bottomMargin : (index - index % gamesGrid.columns)/ gamesGrid.columns === gamesGrid.rows-1 ? gamesGrid.rowSpacing*2 : 0
                    onFocusChanged: if(focus) { gamesScroller.scrollToY(y); }
                    Layout.preferredWidth: (gamesScroller.width - (gamesGrid.columns +1)* gamesGrid.rowSpacing) / gamesGrid.columns
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
