import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 1.2
import QtQuick.Window 2.2

import Antivirus 1.0

Page {

    id: page1

    property string serviceName: ""
    property string command: ""
    property var splited: ""
    property int scaleFactoer: 1

    UbuntuListView {
        id: listview
        x: 0
        y: 0
        clip: true
        width: parent.width
        height: parent.height
        model: splited
        delegate: ListItem.Standard {
        iconSource: Qt.resolvedUrl("../../../graphics/gear.png")
        text: modelData
        onClicked: {

                serviceName = modelData.replace("[Stoped]", "")
                serviceName = serviceName.replace("[Running]", "")
                serviceName = serviceName.replace("[Can't Detect]", "")
                serviceName = serviceName.replace(" ", "")
                PopupUtils.open(passwordPopup)
            }
        }
    }

    MyType {
        id: getServiceList
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

            activity.running = true

            start_timer.start()
        }
    }

    Timer {
        id: start_timer
        interval: 10
        onTriggered: {

            PopupUtils.open(alertPopup)

            splited = getServiceList.getServiceList().split('==')

            activity.running = false
        }
    }

    ActivityIndicator {
        id: activity
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: false
        activeFocusOnPress: false
    }



    Component {
        id: alertPopup
        Dialog {
            id: alertDialog
            title: i18n.tr("Message")
            text: i18n.tr(
                      "if You Don't Need Some Services You should Stop Them , it's Help You To Save More Battry")

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
            text: i18n.tr("Service " + serviceName + "Has Been Stoped")

            Button {
                text: i18n.tr("OK")
                color: UbuntuColors.green
                onClicked: {
                    PopupUtils.close(alertDialog2)
                    splited = getServiceList.getServiceList().split('==')
                    listview.model.reload()
                }
            }
        }
    }

    Component {
        id: passwordPopup
        Dialog {
            id: passwordDialog
            title: i18n.tr("Enter password")
            text: i18n.tr("Your Password is Required To Stop " + serviceName)

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
                    command = "echo " + "'" + passwordText.text + "'"
                            + " | sudo -S " + "service " + serviceName + "stop"
                    console.log(command)

                    if (getServiceList.stopService(command) === "error") {

                        PopupUtils.open(alertPopup3)
                    } else {

                        PopupUtils.open(alertPopup2)
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
        id: alertPopup3
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
