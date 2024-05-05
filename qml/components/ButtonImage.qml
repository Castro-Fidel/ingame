import QtQuick
import QtQuick.Controls as C
import "."

C.Button {
    property string imageUrl: "../images/generic.svg"
    id: button

    contentItem: Image {
        source: button.imageUrl
        fillMode: Image.PreserveAspectFit  // ensure it fits
    }
}
