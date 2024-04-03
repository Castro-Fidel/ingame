import QtQuick

Rectangle {
    id: rectangle
    width: 150
    height: 50
    radius: 5
    color: "#ffffff"

    Text {
        id: text1
        text: qsTr("Text")
        anchors.fill: parent
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
