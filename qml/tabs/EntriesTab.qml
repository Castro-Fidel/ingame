import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../delegates"
import "../constants/tabs.js" as TabConstants
import "../constants/style.js" as Style
import "../components" as TopMenuBut
import "../constants/scene.js" as S

// TODO: set to be parent (root element) of GamesTab
// TODO: remove code duplication (!)

ScrollView {
    property var model: core_app.system_entries; // TODO: fix TypeError: Cannot read property 'system_entries' of null (on application closes)

    id: entriesScroller
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

    function scrollToY(y, HItem) {
        scrolV.fromAnim = scrolV.position;
        scrolV.position = (1.0 - scrolV.size) * y / entriesScroller.height;
        scrolV.toAnim = (1.0 - scrolV.size) * y / entriesScroller.height;
        if(scrolV.toAnim != scrolV.fromAnim) {
            scrollAnimation.start();
        }
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
        id: entriesGrid
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        columns: 5
        rows: Math.max(Math.ceil(children.length / columns), 1)+1

        anchors.rightMargin: rowSpacing * 2
        anchors.leftMargin: rowSpacing * 2
        anchors.bottomMargin : 90

        anchors.topMargin: Math.floor( entriesScroller.width / 100 * 3)
        rowSpacing: Math.floor( entriesScroller.width / 100 * 3)
        columnSpacing: rowSpacing

        // Повторитель
        Repeater {
            id: entriesGridRepeater
            model: entriesScroller.model

            Entry {
                id: game
                gameTitle: model.name
                gameExec: model.exec
                gameIcon: model.icon
                Layout.bottomMargin :
                    (index - index % entriesGrid.columns) /
                    entriesGrid.columns === entriesGrid.rows - 2 ? entriesGrid.rowSpacing * 2 : 0
                onFocusChanged: if(focus) {
                    entriesScroller.scrollToY(y);
                }
                Layout.preferredWidth:
                    (entriesScroller.width - (entriesGrid.columns -1) *
                    entriesGrid.rowSpacing - entriesGrid.anchors.rightMargin - entriesGrid.anchors.leftMargin)
                    / entriesGrid.columns
                Layout.preferredHeight: Layout.preferredWidth / 2 * 3

            }

        }
        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: 10
            color: "red"
            opacity: 0

        }
    }


    // LOGIC
    property int focusedItems: 0;
    function applyItemsFocus(inc){
        if(window.scene !== S.homeScene) return;

        let c = entriesGrid.children;
        let l = c.length - 1; // exclude QQuickRepeater

        if(entriesScroller.focusedItems + inc >= l) {
            entriesScroller.focusedItems = (entriesScroller.focusedItems + inc === l - 1) ? 0 : l - 1;
        } else if(entriesScroller.focusedItems + inc < 0) {
            entriesScroller.focusedItems = (entriesScroller.focusedItems + inc === 0) ? l - 1 : 0; //;
        } else {
            entriesScroller.focusedItems += inc;
        }

        if(c[entriesScroller.focusedItems] !== undefined) {
            c[entriesScroller.focusedItems].forceActiveFocus();
        }
    }

    function applyItemsFocusByLine(inc){
        entriesScroller.applyItemsFocus(inc * entriesGrid.columns);
    }

    function pressFocusedItem(){
        let c = entriesGrid.children;
        if(c[entriesScroller.focusedItems] !== undefined) {
            c[entriesScroller.focusedItems].press();
        }
    }

    function refreshItems(data){
        // entriesGridRepeater.model = [];
        // entriesGridRepeater.model = data;
    }

}
