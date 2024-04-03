import QtQuick

Rectangle {
    id: tabs
    x: 0
    y: 0
    width: 640
    height: 480
    color: "#ffffff"

    Grid {
        id: grid
        y: 60
        height: 420
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
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
                id: button1
            }

            Button {
                id: button2
            }

            Button {
                id: button3
            }
        }
    }
}
