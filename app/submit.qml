import QtQuick 2.4
import Ubuntu.Components 1.2
import QtQuick.Window 2.2


Page {

    id: page1

    property int scaleFactoer: 1

    Rectangle {
        id: rect
        height: 0
        width: 0
        Component.onCompleted: {

            if(Screen.pixelDensity >= 1.0 && Screen.pixelDensity <=2.5) {

                scaleFactoer = 0.7

            }else if(Screen.pixelDensity >= 2.6 && Screen.pixelDensity <= 3.5) {

                scaleFactoer = 1.0

            }else if(Screen.pixelDensity >= 3.6 && Screen.pixelDensity <= 5.5) {

                scaleFactoer = 1.5

            }else if(Screen.pixelDensity >= 5.6 && Screen.pixelDensity <= 7.5) {

                scaleFactoer = 2.1

            }else if(Screen.pixelDensity >= 7.6 && Screen.pixelDensity <= 9.5) {

                scaleFactoer = 2.4

            }else if(Screen.pixelDensity >= 9.6 && Screen.pixelDensity <= 11.5) {

                scaleFactoer = 2.6

            }else if(Screen.pixelDensity >= 11.6 && Screen.pixelDensity <= 13.5) {

                scaleFactoer = 2.8

            }else if(Screen.pixelDensity >= 13.6 && Screen.pixelDensity <= 15.5) {

                scaleFactoer = 3.0

            }else if(Screen.pixelDensity >= 15.6) {

                scaleFactoer = 3.5

            }

        }
    }

    Label {
        id: label
        y: 91 * scaleFactoer
        height: 71 * scaleFactoer
        text: "Please Send Any Malicious App Activity Or False Detection To:\n\nHosein.iProgrammer@Gmail.com\n\nTo Improve This App"
        anchors.right: parent.right
        anchors.rightMargin: 14 * scaleFactoer
        anchors.left: parent.left
        anchors.leftMargin: 14 * scaleFactoer
        anchors.verticalCenterOffset: -45 * scaleFactoer
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 16 * scaleFactoer
        anchors.verticalCenter: parent.verticalCenter
        wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter
    }

}
