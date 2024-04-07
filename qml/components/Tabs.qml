import QtQuick
import QtQuick.Controls as C
import QtQuick.Layouts
import "../delegates"
import "../constants/tabs.js" as TabConstants


Rectangle {
    // PROPERTIES
    property string currentTab: TabConstants.systemManagementTab

    // FIELDS
    id: tabs
    x: 0
    y: 0
    width: 640
    height: 480
    color: "#ffffff"

    // onWidthChanged: { console.log("Window Width changed: " + width) }
    // onHeightChanged: { console.log("Window Height changed: " + height)}

    // COMPONENTS

    Grid {
        id: systemManagementGrid
        visible: tabs.currentTab == TabConstants.systemManagementTab

        columns: 3
        spacing: 2

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 60
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0

        Rectangle { color: "red"; width: 50; height: 50 }
        Rectangle { color: "green"; width: 20; height: 50 }
        Rectangle { color: "blue"; width: 50; height: 20 }
        Rectangle { color: "cyan"; width: 50; height: 50 }
        Rectangle { color: "magenta"; width: 10; height: 10 }
    }


    C.ScrollView {
        visible: tabs.currentTab == TabConstants.gamesTab
        id: gamesScroller
        anchors.fill: parent
        anchors.topMargin: 60
        clip : true

        GridLayout {
            id: gamesGrid
            readonly property int elementWidth: 256 + gamesGrid.rowSpacing*2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            // columns: Math.max(Math.floor(parent.width / elementWidth), 1)
            // rows: Math.max(Math.ceil(children.length / columns), 1)

            columns: Math.max(Math.floor(gamesScroller.width / elementWidth), 1)
            rows: Math.max(Math.ceil(children.length / columns), 1)

            anchors.rightMargin: 8
            anchors.leftMargin: 8
            anchors.bottomMargin: 8
            anchors.topMargin: 8
            rowSpacing: 8
            columnSpacing: rowSpacing

            Repeater {
                // Layout.fillHeight: true
                // Layout.fillWidth: true
                model: core_app.games

                Game {
                    title: model.name
                    exec: model.exec
                    icon: model.icon

                    width: 256
                    height: 256
                    // icon: core_app.games.icon
                    // exec: core_app.games.exec
                }
            }
        }
    }

    Rectangle {
        id: tabsBar
        height: 60
        color: "#4a4a4a"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0

        Row {
            id: row
            height: 60
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            spacing: 5
            padding: 0
            rightPadding: 5
            leftPadding: 5
            bottomPadding: 5
            topPadding: 5

            Button {
                id: buttonSystemManagement
                text: "System management"
                width: 150
                height: 50
                onClicked: function(){
                    tabs.currentTab = TabConstants.systemManagementTab;
                    // tabs.changeTab();
                    // console.log(tabs.currentTab);
                }
            }

            Button {
                id: buttonGames
                text: "Games"
                width: 150
                height: 50
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
    }


}


