import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 1.3
import QtQuick.Window 2.2

import Antivirus 1.0

Page {

    id: page1

    property string status: ""
    property string command: ""
    property string config: ""
    property int scaleFactoer: 1

    MyType {
        id: checkFirewall
    }

    Rectangle {
        id: rect
        height: 0
        width: 0
        Component.onCompleted: {

            if (Screen.pixelDensity >= 1.0 && Screen.pixelDensity <= 2.5) {

                scaleFactoer = 0.7
            } else if (Screen.pixelDensity >= 2.6
                       && Screen.pixelDensity <= 3.5) {

                scaleFactoer = 1.0
            } else if (Screen.pixelDensity >= 3.6
                       && Screen.pixelDensity <= 5.5) {

                scaleFactoer = 1.5
            } else if (Screen.pixelDensity >= 5.6
                       && Screen.pixelDensity <= 7.5) {

                scaleFactoer = 2.1
            } else if (Screen.pixelDensity >= 7.6
                       && Screen.pixelDensity <= 9.5) {

                scaleFactoer = 2.4
            } else if (Screen.pixelDensity >= 9.6
                       && Screen.pixelDensity <= 11.5) {

                scaleFactoer = 2.6
            } else if (Screen.pixelDensity >= 11.6
                       && Screen.pixelDensity <= 13.5) {

                scaleFactoer = 2.8
            } else if (Screen.pixelDensity >= 13.6
                       && Screen.pixelDensity <= 15.5) {

                scaleFactoer = 3.0
            } else if (Screen.pixelDensity >= 15.6) {

                scaleFactoer = 3.5
            }

            console.log(Screen.pixelDensity);

            txtArea.text = "Tap ReLoad To Get Data"

            status = checkFirewall.checkFirewall()
            label1.text = status

            if (status == "Active") {

                label1.color = UbuntuColors.green
                btn2.enabled = false
                btn2.opacity = 0.0
            } else {

                label1.color = UbuntuColors.red
            }
        }
    }

    Label {
        id: label1
        y: 21 * scaleFactoer
        x: 168 * scaleFactoer
        text: "Firewall"
        enabled: true
        anchors.left: label2.right
        anchors.leftMargin: 7 * scaleFactoer
        font.pointSize: 12
    }

    Label {
        id: label2
        y: 21 * scaleFactoer
        x: 22 * scaleFactoer
        text: "Firewall (UFW) Status :"
        anchors.leftMargin: 22 * scaleFactoer
        anchors.left: parent.left
        font.pointSize: 12
    }

    TextArea {
        id: txtArea
        width: 290 * scaleFactoer
        anchors.bottomMargin: 69 * scaleFactoer
        anchors.bottom: parent.bottom
        anchors.top: label3.bottom
        anchors.topMargin: 21 * scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20 * scaleFactoer
    }

    Label {
        id: label3
        x: 22 * scaleFactoer
        y: 50 * scaleFactoer
        text: "Config :"
        font.pointSize: 12
    }

    Button {
        id: btn1
        x: 125

        width: 114 * scaleFactoer
        height: 32 * scaleFactoer
        text: "ReLoad"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15 * scaleFactoer
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {

            txtArea.text = ""
            PopupUtils.open(passwordPopup2)
        }
    }

    Button {
        id: btn2
        y: 21 * scaleFactoer
        width: 60 * scaleFactoer
        height: 18 * scaleFactoer
        text: "Enable"
        anchors.left: label1.right
        anchors.leftMargin: 8 * scaleFactoer
        color: UbuntuColors.green
        onClicked: {

            PopupUtils.open(passwordPopup)
        }
    }

    Component {
        id: passwordPopup
        Dialog {
            id: passwordDialog
            title: i18n.tr("Enter Password")
            text: i18n.tr("Your password is required for this action")

            signal accepted(string password)
            signal rejected

            TextField {
                id: passwordText
                echoMode: TextInput.Password
            }

            Button {
                text: i18n.tr("OK")
                color: UbuntuColors.green
                onClicked: {
                    passwordDialog.accepted(passwordText.text)
                    PopupUtils.close(passwordDialog)
                    command = "echo " + "'" + passwordText.text + "'" + " | sudo -S " + "ufw enable"
                    console.log(command)
                    console.log(checkFirewall.activeFirewall("echo " + "'" + passwordText.text + "'" + " | sudo -S " + "service ufw start"))

                    if (checkFirewall.activeFirewall(command) === "error") {

                        PopupUtils.open(alertPopup)
                    } else {

                        btn2.opacity = 0.0
                        label1.text = "Active"
                        label1.color = UbuntuColors.green
                    }
                }
            }

            Button {
                text: i18n.tr("Cancel")
                color: UbuntuColors.red
                onClicked: {
                    passwordDialog.rejected()
                    PopupUtils.close(passwordDialog)
                }
            }
        }
    }

    Component {
        id: passwordPopup2
        Dialog {
            id: passwordDialog2
            title: i18n.tr("Enter Password")
            text: i18n.tr("Your password is required for this action")

            signal accepted(string password)
            signal rejected

            TextField {
                id: passwordText
                echoMode: TextInput.Password
            }

            Button {
                text: i18n.tr("OK")
                color: UbuntuColors.green
                onClicked: {
                    passwordDialog2.accepted(passwordText.text)
                    PopupUtils.close(passwordDialog2)
                    command = "echo " + "'" + passwordText.text + "'" + " | sudo -S " + "ufw status"
                    console.log(command)

                    config = checkFirewall.getFirewallConfig(command)
                    console.log(config)

                    if(config === "error") {

                        PopupUtils.open(alertPopup)

                    }else {

                        txtArea.text = config

                        if(config === "Status: active\n") {

                            txtArea.text = config + "\nFirewall is in Default Config"

                        }

                    }

                }
            }

            Button {
                text: i18n.tr("Cancel")
                color: UbuntuColors.red
                onClicked: {
                    passwordDialog.rejected()
                    PopupUtils.close(passwordDialog2)
                }
            }
        }
    }

    Component {
        id: alertPopup
        Dialog {
            id: alertDialog
            title: i18n.tr("Message")
            text: i18n.tr("Incorrect Password")

            Button {
                text: i18n.tr("OK")
                color: UbuntuColors.green
                onClicked: {
                    PopupUtils.close(alertDialog)
                }
            }
        }
    }
}
