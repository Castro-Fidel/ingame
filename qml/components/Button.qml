import QtQuick
import QtQuick.Controls as C

C.Button {

    // control.down
    // control.activeFocus

    id: control
    width: 150
    height: 50
    text: qsTr("Button")

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "#000000" : (control.activeFocus ? "#ff0000" : "#555555")
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        border.color: control.down ? "#000000" : (control.activeFocus ? "#ff0000" : "#555555")
        border.width: 1
        radius: 8
    }
}
