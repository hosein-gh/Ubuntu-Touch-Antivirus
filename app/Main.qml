import QtQuick 2.4
import Ubuntu.Components 1.2
import QtQuick.Window 2.2
import Ubuntu.Components.Popups 1.3

//import Antivirus 1.0
/*!
    \brief MainView with a Label and Button elements.
    */
MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "antivirus.iprogramer"

    width: units.gu(40)
    height: units.gu(70)

    anchorToKeyboard: true

    Rectangle {
        id: rect
        height: 0
        width: 0
        Component.onCompleted: {

            start_timer.start()
        }

    }

    Timer {
        id: start_timer
        interval: 10
        onTriggered: {

            PopupUtils.open(tabbss)

        }
    }

    Component {
        id: tabbss

    Tabs {
        id: tabs
        Tab {
            id: scan
            title: i18n.tr("Scan")
            page: Loader {
                parent: scan
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                source: (tabs.selectedTab === scan) ? Qt.resolvedUrl(
                                                          "scan.qml") : ""
            }
        }

        Tab {
            id: firewall
            title: i18n.tr("Firewall")
            page: Loader {
                parent: firewall
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                source: (tabs.selectedTab === firewall) ? Qt.resolvedUrl(
                                                          "firewall.qml") : ""
            }
        }

        Tab {
            id: activeServices
            title: i18n.tr("Active Services")
            page: Loader {
                parent: activeServices
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                source: (tabs.selectedTab === activeServices) ? Qt.resolvedUrl(
                                                                    "ActiveServices.qml") : ""
            }
        }

        Tab {
            id: malicious
            title: i18n.tr("IP/Site Checker")
            page: Loader {
                parent: malicious
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                source: (tabs.selectedTab === malicious) ? Qt.resolvedUrl(
                                                                   "ipchecker.qml") : ""
            }
        }

        Tab {
            id: passGenerator
            title: i18n.tr("Password Generator")
            page: Loader {
                parent: passGenerator
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                source: (tabs.selectedTab === passGenerator) ? Qt.resolvedUrl(
                                                                   "PassGen.qml") : ""
            }
        }

        Tab {
            id: submit
            title: i18n.tr("Submit")
            page: Loader {
                parent: submit
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                source: (tabs.selectedTab === submit) ? Qt.resolvedUrl(
                                                            "submit.qml") : ""
            }
        }

        Tab {
            id: about
            title: i18n.tr("About")
            page: Loader {
                parent: about
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                source: (tabs.selectedTab === about) ? Qt.resolvedUrl(
                                                           "about.qml") : ""
            }
        }
    }

    }
}
