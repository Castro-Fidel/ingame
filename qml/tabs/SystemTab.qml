import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../delegates"
import "../constants/tabs.js" as TabConstants
import "../constants/style.js" as Style
import "../components" as TopMenuBut
import "../constants/scene.js" as S

ScrollView {
    property var model: buttonGames


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

    function scrollToY(y, HItem) {
        scrolV.fromAnim = scrolV.position;
        scrolV.position = (1.0 - scrolV.size) * y / gamesScroller.height;
        scrolV.toAnim = (1.0 - scrolV.size) * y / gamesScroller.height;
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
        id: gamesGrid
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        columns: 1
        rows: Math.max(Math.ceil(children.length / columns), 1)

        anchors.rightMargin: rowSpacing * 2
        anchors.leftMargin: rowSpacing * 2
        anchors.bottomMargin : 90
        anchors.topMargin: Math.floor( gamesScroller.width / 100 * 3)
        rowSpacing: Math.floor( gamesScroller.width / 100 * 3)
        columnSpacing: rowSpacing

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
                checked: systemSettings.fullscreen === "1"
                onCheckedChanged: {
                    let newFullscreenValue = checked ? "1" : "0"
                    if (systemSettings.fullscreen !== newFullscreenValue) {
                        systemSettings.fullscreen = newFullscreenValue
                        window.applySettings()
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
                text: "СЭМПЛЕ ТЕКЕСТ:"
                color: 'white'
                opacity: 0.8
            }
            CheckBox {
                onCheckedChanged: {
                    if (checked) {
                        console.log("checked")
                    } else {
                        console.log("NOT checked")
                    }
                }
            }
        }
    }


    // LOGIC
    property int focusedItems: 0;
    function applyItemsFocus(inc){
        if(window.scene !== S.homeScene) return;

        let c = gamesGrid.children;
        let l = c.length - 1; // exclude QQuickRepeater

        if(gamesScroller.focusedItems + inc >= l) {
            gamesScroller.focusedItems = (gamesScroller.focusedItems + inc === l - 1) ? 0 : l - 1;
        } else if(gamesScroller.focusedItems + inc < 0) {
            gamesScroller.focusedItems = (gamesScroller.focusedItems + inc === 0) ? l - 1 : 0; //;
        } else {
            gamesScroller.focusedItems += inc;
        }

        if(c[gamesScroller.focusedItems] !== undefined) {
            c[gamesScroller.focusedItems].forceActiveFocus();
        }
    }

    function applyItemsFocusByLine(inc){
        gamesScroller.applyItemsFocus(inc * gamesGrid.columns);
    }

    function pressFocusedItem(){
        let c = gamesGrid.children;
        if(c[gamesScroller.focusedItems] !== undefined) {
            c[gamesScroller.focusedItems].press();
        }
    }

    function refreshItems(data){
        gamesGridRepeater.model = [];
        gamesGridRepeater.model = data;
    }

}
