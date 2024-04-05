import QtQuick
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

    Grid {
        id: gamesGrid
        visible: tabs.currentTab == TabConstants.gamesTab

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

        Text {
            id: text2
            text: qsTr("Text")
            font.pixelSize: 12
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
                onClicked: function(){
                    tabs.currentTab = TabConstants.systemManagementTab;
                    // tabs.changeTab();
                    // console.log(tabs.currentTab);
                }
            }

            Button {
                id: buttonGames
                text: "Games"
                onClicked: function(){
                    tabs.currentTab = TabConstants.gamesTab;
                    if(app === undefined) return;
                    app.get_games();
                    // tabs.changeTab();
                    // console.log(tabs.currentTab);
                }
            }
        }
    }


}
