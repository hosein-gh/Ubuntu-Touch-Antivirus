import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 1.3
import QtQuick.Window 2.2

Page {
    id: page1

    property int scaleFactoer: 1

    property string chars: ""
    property string password: ""
    property int ii: 0
    property int xx: 0

    function randomPassword(length) {

        chars = ""

        if (checkbox1.checked) {

            chars += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }

        if (checkbox2.checked) {

            chars += "abcdefghijklmnopqrstuvwxyz"
        }

        if (checkbox3.checked) {

            chars += "1234567890"
        }

        if (checkbox4.checked) {

            chars += "!@#$%^&*()_+"
        }

        if (checkbox1.checked || checkbox2.checked || checkbox3.checked || checkbox4.checked) {

            for (xx = 0; xx < length; xx++) {
                ii = Math.floor(Math.random() * 100)
                password += chars.charAt(ii)
            }
        } else {

            PopupUtils.open(alertPopup)

        }

        return password
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


    Component {
        id: alertPopup
        Dialog {
            id: alertDialog
            title: i18n.tr("Message")
            text: i18n.tr("Please Select At The Least One Mode")

            Button {
                text: i18n.tr("OK")
                color: UbuntuColors.green
                onClicked: {
                    PopupUtils.close(alertDialog)
                }
            }
        }
    }

    Label {
        id: label1
        y: 21*scaleFactoer
        text: "include :"
        anchors.left: parent.left
        anchors.leftMargin: 19*scaleFactoer
        font.pointSize: 12
    }

    Label {
        id: label2
        y: 60*scaleFactoer
        text: "Uppercase "
        anchors.left: parent.left
        anchors.leftMargin: 40*scaleFactoer
        font.pointSize: 12
    }

    Label {
        id: label3
        y: 100*scaleFactoer
        text: "Lowercase "
        anchors.left: parent.left
        anchors.leftMargin: 40*scaleFactoer
        font.pointSize: 12
    }

    Label {
        id: label4
        y: 140*scaleFactoer
        text: "Numbers "
        anchors.left: parent.left
        anchors.leftMargin: 40*scaleFactoer
        font.pointSize: 12
    }

    Label {
        id: label5
        y: 180*scaleFactoer
        text: "Special "
        anchors.left: parent.left
        anchors.leftMargin: 40*scaleFactoer
        font.pointSize: 12
    }

    CheckBox {

        id: checkbox1
        y: 57*scaleFactoer
        anchors.left: label2.right
        anchors.leftMargin: 21*scaleFactoer
        checked: true
    }

    CheckBox {

        id: checkbox2
        y: 97*scaleFactoer
        anchors.left: label3.right
        anchors.leftMargin: 21*scaleFactoer
        checked: true
    }

    CheckBox {

        id: checkbox3
        y: 138*scaleFactoer
        anchors.left: label4.right
        anchors.leftMargin: 30*scaleFactoer
        checked: true
    }

    CheckBox {

        id: checkbox4
        y: 176*scaleFactoer
        anchors.left: label5.right
        anchors.leftMargin: 43*scaleFactoer
        checked: true
    }

    Button {
        id: ramdon
        x: 281*scaleFactoer
        y: 322*scaleFactoer
        text: "Generate"
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {

            txtArea.text = randomPassword(10)
        }
    }
    TextArea {
        id: txtArea
        y: 217*scaleFactoer
        anchors.leftMargin: 45*scaleFactoer
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
    }


}
