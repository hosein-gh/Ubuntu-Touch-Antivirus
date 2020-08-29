import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 1.3
import QtQuick.Window 2.2

import Antivirus 1.0

Page {

    id: page1

    property int scaleFactoer: 1

    property string result: ""
    property string status: ""
    property string country: ""
    property string description: ""
    clip: false

    MyType {
        id: getIpStatus

    }

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

    TextField {

        id: txtfield
        y: 46*scaleFactoer
        width: 288*scaleFactoer
        height: 32*scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
        anchors.leftMargin: 22*scaleFactoer

    }

    Button {
        id: btn1
        x: 114*scaleFactoer
        y: 102*scaleFactoer
        width: 114*scaleFactoer
        height: 32*scaleFactoer
        text: "Check"
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {

            activity.running = true
            result = getIpStatus.getIpStatus(txtfield.text)

            if(result == "Network unreachable") {

                PopupUtils.open(alertPopup);

            }else if(result == "Error While Getting Data") {

                PopupUtils.open(alertPopup2);

            }else if(result == "not contain") {

                label2.text = txtfield.text;
                label4.text = "Normal";
                label4.color = UbuntuColors.green;
                label6.text = "Not Found";
                label8.text = "No Any Malicious Activity Found";

            }else {

                var splited = result.split('-');
                label2.text = txtfield.text;
                label4.text = "Malicious";
                label4.color = UbuntuColors.red;
                label6.text = splited[0];
                label8.text = splited[1];

            }

            activity.running = false

        }
    }

    ActivityIndicator {
                    id:activity
                    x: 158*scaleFactoer
                    y: 158*scaleFactoer
                    anchors.horizontalCenter: parent.horizontalCenter
                    running: false
                    activeFocusOnPress: false

                }

    Label {
        id: label0
        y: 24*scaleFactoer
        text: "IP or Site Address"
        anchors.left: parent.left
        anchors.leftMargin: 22*scaleFactoer
        font.pointSize: 12
    }

    Label {
        id: label1
        y: 201*scaleFactoer
        width: 100*scaleFactoer
        height: 16*scaleFactoer
        text: "IP/Site Address :"
        anchors.left: parent.left
        anchors.leftMargin: 22*scaleFactoer
    }

    Label {
        id: label2
        y: 201*scaleFactoer
        width: 194*scaleFactoer
        height: 16*scaleFactoer
        anchors.horizontalCenterOffset: 60
        anchors.left: label1.right
        anchors.leftMargin: 6*scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: label3
        y: 230*scaleFactoer
        text: "Status :"
        anchors.left: parent.left
        anchors.leftMargin: 22*scaleFactoer
    }

    Label {
        id: label4
        y: 230*scaleFactoer
        width: 194*scaleFactoer
        height: 16*scaleFactoer
        anchors.horizontalCenterOffset: 60
        anchors.left: label3.right
        anchors.leftMargin: 60*scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter

    }

    Label {
        id: label5
        y: 259*scaleFactoer
        text: "Country :"
        anchors.left: parent.left
        anchors.leftMargin: 22*scaleFactoer
    }

    Label {
        id: label6
        y: 259*scaleFactoer
        width: 194*scaleFactoer
        height: 16*scaleFactoer
        anchors.horizontalCenterOffset: 60
        anchors.left: label5.right
        anchors.leftMargin: 49*scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: label7
        y: 290*scaleFactoer
        text: "Description :"
        anchors.left: parent.left
        anchors.leftMargin: 22*scaleFactoer
    }

    Label {
        id: label8
        y: 290*scaleFactoer
        width: 194*scaleFactoer
        height: 130*scaleFactoer
        anchors.horizontalCenterOffset: 60
        anchors.left: label7.right
        anchors.leftMargin: 28*scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
        wrapMode: Text.WordWrap
    }

    Component {
        id: alertPopup
        Dialog {
            id: alertDialog
            title: i18n.tr("Message")
            text: i18n.tr(
                      "Network is Unreachable")

            Button {
                text: i18n.tr("OK")
                color: UbuntuColors.green
                onClicked: {
                    PopupUtils.close(alertDialog)
                }
            }
        }
    }

    Component {
        id: alertPopup2
        Dialog {
            id: alertDialog2
            title: i18n.tr("Message")
            text: i18n.tr(
                      "Error While Getting Data")

            Button {
                text: i18n.tr("OK")
                color: UbuntuColors.green
                onClicked: {
                    PopupUtils.close(alertDialog2)
                }
            }
        }
    }

}
