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
        id: label2
        width: 197*scaleFactoer
        height: 39*scaleFactoer
        text: "Please send Bugs to : Hosein.iProgrammer@Gmail.com"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
        anchors.leftMargin: 21*scaleFactoer
        anchors.top: image1.bottom
        anchors.topMargin: 21*scaleFactoer
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font.pointSize: 14
        style: Text.Normal
    }

    Label {
        id: label3
        y: 339*scaleFactoer
        width: 143*scaleFactoer
        height: 22*scaleFactoer
        text: "Twitter : h_iprogramer"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20*scaleFactoer
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font.pointSize: 14
        style: Text.Normal
    }

    Label {
        id: label4
        x: 21*scaleFactoer
        y: 518*scaleFactoer
        width: 179*scaleFactoer
        height: 22*scaleFactoer
        text: "Development By iProgramer"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20*scaleFactoer
        anchors.horizontalCenterOffset: 1*scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font.pointSize: 14
        style: Text.Normal
    }

    Image {
        id: image1
        source: Qt.resolvedUrl("../../../graphics/Antivirus.png")
        x: 61*scaleFactoer
        width: 199*scaleFactoer
        height: 199*scaleFactoer
        anchors.top: label5.bottom
        anchors.topMargin: 17*scaleFactoer
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: label5
        x: 151*scaleFactoer
        width: 276*scaleFactoer
        height: 22*scaleFactoer
        text: "Antivirus For Ubuntu Touch"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 17
        font.pixelSize: 21*scaleFactoer
        clip: true
        visible: true
        font.bold: false
        wrapMode: Text.NoWrap
        horizontalAlignment: Text.AlignHCenter
        style: Text.Normal
    }
}
