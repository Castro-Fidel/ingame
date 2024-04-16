import QtQuick
import QtQuick.Controls as C

C.Button {
    id: control
    text: qsTr("Button")
    font.bold: true
    //font.letterSpacing:  font.pixelSize / 100 * 30

    // font.pointSize:  Math.max(parent.width / 100,10)
    // contentItem: Text {
    //     text: control.text
    //     font: control.font
    //     //fontSizeMode: Text.Fit; minimumPixelSize: 10;
    //     opacity: enabled ? 1.0 : 0.3
    //     color: control.down ? "Black" : (control.activeFocus ? "#333333" : "#ffffff")
    //     horizontalAlignment: Text.AlignHCenter
    //     verticalAlignment: Text.AlignVCenter
    //     elide: Text.ElideRight
    //     leftPadding: font.pointSize / 100 * 20
    //     rightPadding: font.pointSize / 100 * 20
    //     topPadding: font.pointSize / 100 * 0
    //     bottomPadding: font.pointSize / 100 * 0

    // }

    // background: Rectangle {
    //     //implicitWidth: 100
    //     //implicitHeight: 40
    //     opacity: enabled ? 1 : 0.3
    //     color: control.down ? "#000000" : (control.activeFocus ? "#ffffff" : "#00000000")
    //     border.width: 0
    //     radius: 16

    // }


}
