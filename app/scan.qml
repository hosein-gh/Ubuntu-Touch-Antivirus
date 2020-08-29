import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 1.3
import QtQuick.Window 2.2

import Antivirus 1.0

Page {

    id: page1

    property int scaleFactoer: 1

    property string mode: ""
    property string clickList: ""
    property string clickMaliciousList: ""
    property string reasonList: ""
    property string listeningPorts: ""
    property string firewallStatus: ""
    property string ips: ""
    property string isHavePassword: ""
    property string rcLocalStatus: ""

    property int totalItemScaned: 0
    property string securityFIX: ""
    property string password: ""

    property string securityRisks: ""
    property string securityWarning: ""

    property var result: ""

    clip: false

    Timer {
        id: scanApps
        interval: 10000
        onTriggered: {


            //************************************************** scan apps *********************************************************
            txt1.text = "Scanning...\nInstalled Applications"

            clickList = getClickList.getClickList()
            var clickArray = clickList.split('\n')

            reasonList = getClickList.getReasonList()
            var reasonArray = reasonList.split('\n')

            clickMaliciousList = getClickList.getMaliciousClickList()
            var MaliciousArray = clickMaliciousList.split('\n')

            var counter = 0
            var counter2 = 0

            for (counter = 0; counter <= clickArray.length - 1; counter++) {

                totalItemScaned++
                txt5.text = totalItemScaned.toString()

                for (counter2 = 0; counter2 <= MaliciousArray.length - 2; counter2++) {

                    if (String(clickArray[counter]).indexOf(
                                String(MaliciousArray[counter2])) !== -1) {

                        var risks = txt7.text
                        risks++
                        txt7.text = risks.toString()

                        if (securityRisks === "") {

                            securityRisks = clickArray[counter]
                                    + " is Malicious and Must Be Removed\nReason: " + reasonArray[counter2]
                        } else {

                            securityRisks = securityRisks + "==" + clickArray[counter]
                                    + " is Malicious and Must Be Removed\nReason: " + reasonArray[counter2]
                        }

                        if (securityFIX === "") {

                            securityFIX = "click unregister --user=phablet " + clickArray[counter]
                        } else {

                            securityFIX = securityFIX + "==click unregister --user=phablet "
                                    + clickArray[counter]
                        }
                    }
                }
            }

            canvas2.currentValue = 30
            checkFirewall.start()
        }
    }

    Timer {
        id: checkFirewall
        interval: 3000
        onTriggered: {


            //************************************************** check Firewall *********************************************************
            txt1.text = "Checking...\nFirewall Status"

            firewallStatus = getClickList.checkFirewall()

            totalItemScaned++
            txt5.text = totalItemScaned.toString()

            if (firewallStatus === "inactive") {

                var warning = txt6.text
                warning++
                txt6.text = warning.toString()

                if (securityWarning === "") {

                    securityWarning = "Firewall is inactive"
                } else {

                    securityWarning = securityWarning + "==Firewall is inactive"
                }

                if (securityFIX === "") {

                    securityFIX = "service ufw start"
                    securityFIX = securityFIX + "==ufw enable"
                } else {

                    securityFIX = securityFIX + "==service ufw start"
                    securityFIX = securityFIX + "==ufw enable"
                }
            }

            canvas2.currentValue = 40
            checkPorts.start()
        }
    }

    Timer {
        id: checkPorts
        interval: 5000
        onTriggered: {


            //************************************************** check listening Ports *********************************************************
            txt1.text = "Scanning...\nListening Ports"

            listeningPorts = getClickList.getListenPorts()

            var listeningContent = listeningPorts.split('==')
            var listeningCounter = 0

            for (listeningCounter = 0; listeningCounter
                 <= listeningContent.length - 1; listeningCounter++) {

                totalItemScaned++
                txt5.text = totalItemScaned.toString()

                if (String(listeningContent[listeningCounter]) === "53"
                        || String(listeningContent[listeningCounter]) === "80"
                        || String(listeningContent[listeningCounter]) === "22"
                        || String(listeningContent[listeningCounter]) === "") {

                } else {

                    var risks = txt7.text
                    risks++
                    txt7.text = risks.toString()

                    if (securityRisks === "") {

                        securityRisks = "You Have Listening Port On " + String(
                                    listeningContent[listeningCounter]) + "\nReason: Listening Unknown (or not required) Ports on Phone For a Long Time."
                    } else {

                        securityRisks = securityRisks + "=="
                                + "You Have Listening Port On " + String(
                                    listeningContent[listeningCounter]) + "\nReason: Listening Unknown (or not required) Ports on Phone For a Long Time."
                    }

                    if (securityFIX === "") {

                        securityFIX = "ufw deny " + String(
                                    listeningContent[listeningCounter])
                    } else {

                        securityFIX = securityFIX + "==ufw deny " + String(
                                    listeningContent[listeningCounter])
                    }
                }
            }

            canvas2.currentValue = 50
            checkIPs.start()
        }
    }

    Timer {
        id: checkIPs
        interval: 5000
        onTriggered: {


            //************************************************** check ip's *********************************************************
            txt1.text = "Scanning...\nEstablished Connections"

            ips = getClickList.getIpList()

            var establishedContent = ips.split('==')
            var establishedCounter = 0

            console.log(establishedContent)

            for (establishedCounter = 0; establishedCounter
                 <= establishedContent.length - 1; establishedCounter++) {

                totalItemScaned++
                txt5.text = totalItemScaned.toString()

                if(establishedContent[establishedCounter] === "") {


                }else {

                var ipStatus = getClickList.scanIp(
                            establishedContent[establishedCounter])

                if (ipStatus === "not contain") {

                } else if (ipStatus === "Network unreachable") {

                    establishedCounter = establishedContent.length
                    PopupUtils.open(alertPopup)
                } else if (ipStatus === "contain") {

                    var risks = txt7.text
                    risks++
                    txt7.text = risks.toString()

                    if (securityRisks === "") {

                        securityRisks = "You Have Malicious Connection With " + String(
                                    establishedContent[establishedCounter]) + "\nReason: This IP has Marked as Malicious."
                    } else {

                        securityRisks = securityRisks + "=="
                                + "You Have Malicious Connection With " + String(
                                    establishedContent[establishedCounter])  + "\nReason: This IP has Marked as Malicious."
                    }

                    if (securityFIX === "") {

                        securityFIX = "ufw deny from " + String(
                                    establishedContent[establishedCounter])
                    } else {

                        securityFIX = securityFIX + "==ufw deny from " + String(
                                    establishedContent[establishedCounter])
                    }
                }
            }

            }

            canvas2.currentValue = 70
            checkPassword.start()
        }
    }

    Timer {
        id: checkPassword
        interval: 3000
        onTriggered: {


            //************************************************** check Password *********************************************************
            txt1.text = "Checking...\nUsers And Device Password"

            isHavePassword = getClickList.checkPassword()

            totalItemScaned++
            txt5.text = totalItemScaned.toString()

            var passContent = isHavePassword.split(' ')
            isHavePassword = passContent[1]

            if (isHavePassword === "NP") {

                var warning = txt6.text
                warning++
                txt6.text = warning.toString()

                if (securityWarning === "") {

                    securityWarning = "Please Set Password For Your Device\nReason: Applications Can Execute CMD Commands Without Your Permission."
                } else {

                    securityWarning = securityWarning + "==Please Set Password For Your Device\nReason: Applications Can Execute CMD Commands Without Your Permission."
                }
            }

            canvas2.currentValue = 80
            checkRcLocal.start()
        }
    }

    Timer {
        id: checkRcLocal
        interval: 5000
        onTriggered: {


            //************************************************** check rc.local *********************************************************
            txt1.text = "Checking...\n/etc/rc.local"

            rcLocalStatus = getClickList.checkRcLocal()

            totalItemScaned++
            txt5.text = totalItemScaned.toString()

            var rclocalContent = rcLocalStatus.split('\n')
            var counterRcLocal = 0

            for (counterRcLocal = 0; counterRcLocal <= rclocalContent.length
                 - 1; counterRcLocal++) {

                if (String(rclocalContent[counterRcLocal]).charAt(0) === "#"
                        || String(rclocalContent[counterRcLocal]) === "exit 0"
                        || String(rclocalContent[counterRcLocal]) === "") {

                } else {

                    counterRcLocal = rclocalContent.length

                    var warning = txt6.text
                    warning++
                    txt6.text = warning.toString()

                    if (securityWarning === "") {

                        securityWarning
                                = "You Have Extra Line in Your rc.local File It's May Dangerous"
                    } else {

                        securityWarning = securityWarning
                                + "==You Have Extra Line in Your rc.local File It's May Dangerous"
                    }

                    if (securityFIX === "") {

                        securityFIX = "echo '\n\nexit0' > /etc/rc.local"
                    } else {

                        securityFIX = securityFIX + "==echo '\n\nexit0' > /etc/rc.local"
                    }
                }
            }

            canvas2.currentValue = 90
            finalStep.start()
        }
    }

    Timer {
        id: finalStep
        interval: 3000
        onTriggered: {

            canvas2.currentValue = 100

            if (securityRisks !== "") {

                txt1.text = "Your Device is Infected"
                txt1.color = UbuntuColors.red
                canvas2.currentColor = "#f32c36"

                btn1.opacity = 1.0
                btn2.opacity = 1.0
            } else if (securityWarning !== "") {

                txt1.text = "Your Device is At Risk"
                txt1.color = "#b3a50d"
                canvas2.currentColor = "#e3e130"

                btn1.opacity = 1.0
                btn2.opacity = 1.0
            } else {

                txt1.text = "Your Device is Safe"
                txt1.color = "#00a132"
                txt8.opacity = 1.0
                txt9.opacity = 1.0
                canvas2.currentColor = "#00a132"
            }

            rotate.stop()
            canvas2.rotation = 0
            mode = ""
        }
    }

    function startScan() {

        mode = "scan"
        scanApps.start()
    }

    MyType {
        id: getClickList
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

            console.log(Screen.pixelDensity)
        }
    }

    Canvas {

        id: canvas
        width: 270 * scaleFactoer
        height: 270 * scaleFactoer
        anchors.horizontalCenterOffset: 0
        anchors.left: parent.left
        anchors.leftMargin: 30 * scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 8 * scaleFactoer
        antialiasing: true

        Canvas {
            id: canvas2
            width: 270 * scaleFactoer
            height: 270 * scaleFactoer
            anchors.left: parent.left
            anchors.leftMargin: 0 * scaleFactoer
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0 * scaleFactoer
            antialiasing: true

            property color primaryColor: "orange"
            property color secondaryColor: "lightblue"

            property real centerWidth: width / 2
            property real centerHeight: height / 2
            property real radius: Math.min(canvas2.width, canvas2.height) / 2.2

            property real minimumValue: 0
            property real maximumValue: 100
            property real currentValue: 0
            property string currentColor: "#36c2f7"

            // this is the angle that splits the circle in two arcs
            // first arc is drawn from 0 radians to angle radians
            // second arc is angle radians to 2*PI radians
            property real angle: (currentValue - minimumValue)
                                 / (maximumValue - minimumValue) * 2 * Math.PI

            // we want both circle to start / end at 12 o'clock
            // without this offset we would start / end at 9 o'clock
            property real angleOffset: -Math.PI / 2

            property string text: "Text"

            signal clicked

            onPrimaryColorChanged: requestPaint()
            onSecondaryColorChanged: requestPaint()
            onMinimumValueChanged: requestPaint()
            onMaximumValueChanged: requestPaint()
            onCurrentValueChanged: requestPaint()
            onCurrentColorChanged: requestPaint()

            onPaint: {

                var ctx = getContext("2d")
                ctx.save()

                ctx.clearRect(0, 0, canvas2.width, canvas2.height)

                // fills the mouse area when pressed
                // the fill color is a lighter version of the
                // secondary color
                if (mouseArea.pressed) {

                    if(mode === "") {

                        rotate.start()

                        ctx.beginPath()
                        ctx.lineWidth = 1 * scaleFactoer
                        ctx.fillStyle = Qt.lighter(canvas2.secondaryColor, 1.25)
                        ctx.arc(canvas2.centerWidth, canvas2.centerHeight,
                                canvas2.radius, 0, 2 * Math.PI)
                        ctx.fill()

                        var internetStatus = getClickList.scanIp("8.8.8.8")

                        if (internetStatus === "Network unreachable") {

                            PopupUtils.open(alertPopup22)
                        } else {

                            txt1.text = "Scanning...\nInstalled Applications"
                            canvas2.currentValue = 10
                            canvas2.currentColor = "#36c2f7"
                            txt1.color = "#36c2f7"
                            btn1.opacity = 0.0
                            btn2.opacity = 0.0
                            txt5.text = "0"
                            txt6.text = "0"
                            txt7.text = "0"
                            txt8.opacity = 0.0
                            txt9.opacity = 0.0
                            startScan()
                        }

                    }

                }

                // First, thinner arc
                // From angle to 2*PI
                ctx.beginPath()
                ctx.lineWidth = 10 * scaleFactoer
                ctx.strokeStyle = "#dfdfdf"
                ctx.arc(canvas2.centerWidth, canvas2.centerHeight,
                        canvas2.radius, angleOffset + canvas2.angle,
                        angleOffset + 2 * Math.PI)
                ctx.stroke()

                // Second, thicker arc
                // From 0 to angle
                ctx.beginPath()
                ctx.lineWidth = 10 * scaleFactoer
                ctx.strokeStyle = currentColor
                ctx.arc(canvas2.centerWidth, canvas2.centerHeight,
                        canvas2.radius, canvas2.angleOffset,
                        canvas2.angleOffset + canvas2.angle)
                ctx.stroke()

                ctx.restore()
            }
        }

        MouseArea {
            id: mouseArea
            anchors.rightMargin: 0 * scaleFactoer
            anchors.bottomMargin: 0 * scaleFactoer
            anchors.leftMargin: 0 * scaleFactoer
            anchors.topMargin: 0 * scaleFactoer

            anchors.fill: parent
            onClicked: canvas2.clicked()
            onPressedChanged: canvas2.requestPaint()
        }

        RotationAnimation {
            id: rotate
            target: canvas2
            property: "rotation"
            from: 0
            to: 360
            duration: 1000
            loops: 9999999
            direction: RotationAnimation.Clockwise
        }

        Text {
            id: txt1
            y: 92 * scaleFactoer
            height: 84 * scaleFactoer

            text: "Tap To Scan"
            anchors.left: parent.left
            anchors.leftMargin: 24 * scaleFactoer
            anchors.right: parent.right
            anchors.rightMargin: 24 * scaleFactoer
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WrapAnywhere
            color: "#36c2f7"
        }
    }

    Text {
        id: txt3
        x: 0 * scaleFactoer
        width: 150 * scaleFactoer
        height: 20 * scaleFactoer
        color: "#000000"
        text: "Total Security Warning :"
        anchors.horizontalCenterOffset: -21 * scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: txt2.bottom
        anchors.topMargin: 6 * scaleFactoer
        wrapMode: Text.NoWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
    Text {
        id: txt2
        x: 0 * scaleFactoer
        width: 150 * scaleFactoer
        height: 20 * scaleFactoer
        color: "#000000"
        text: "Total Item Scaned :"
        anchors.horizontalCenterOffset: -21 * scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: canvas.bottom
        anchors.topMargin: 6 * scaleFactoer
        wrapMode: Text.NoWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
    Text {
        id: txt4
        x: 0 * scaleFactoer
        width: 150 * scaleFactoer
        height: 20 * scaleFactoer
        color: "#000000"
        text: "Total Security Risk :"
        anchors.horizontalCenterOffset: -21 * scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: txt3.bottom
        anchors.topMargin: 5 * scaleFactoer
        wrapMode: Text.NoWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
    Button {
        id: btn2
        x: 108 * scaleFactoer

        width: 114 * scaleFactoer
        height: 32 * scaleFactoer
        text: "Show Details"
        anchors.top: txt4.bottom
        anchors.topMargin: 16 * scaleFactoer
        anchors.horizontalCenterOffset: 0 * scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
        color: UbuntuColors.orange
        opacity: 0.0
        onClicked: {

            if(securityWarning === "") {

                result = String(securityRisks).split('==')

            }else {

                result = String(securityWarning + "==" + securityRisks).split('==')

            }

            console.log(result)

            PopupUtils.open(resultView)
        }
    }
    Button {
        id: btn1
        x: 108 * scaleFactoer

        width: 114 * scaleFactoer
        height: 32 * scaleFactoer
        text: "Resolve Risks"
        anchors.top: btn2.bottom
        anchors.topMargin: 14 * scaleFactoer
        anchors.horizontalCenterOffset: 0 * scaleFactoer
        anchors.horizontalCenter: parent.horizontalCenter
        color: UbuntuColors.green
        opacity: 0.0
        onClicked: {

            PopupUtils.open(passwordPopup2)
        }
    }
    Text {
        id: txt5
        width: 36 * scaleFactoer
        height: 20 * scaleFactoer
        color: "#000000"
        text: "0"
        anchors.left: txt2.right
        anchors.leftMargin: 6 * scaleFactoer
        anchors.top: canvas.bottom
        anchors.topMargin: 6 * scaleFactoer
        wrapMode: Text.NoWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
    Text {
        id: txt6
        width: 36 * scaleFactoer
        height: 20 * scaleFactoer
        color: "#b3a50d"
        text: "0"
        anchors.left: txt3.right
        anchors.leftMargin: 6 * scaleFactoer
        anchors.top: txt5.bottom
        anchors.topMargin: 6 * scaleFactoer
        wrapMode: Text.NoWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
    Text {
        id: txt7
        width: 36 * scaleFactoer
        height: 20 * scaleFactoer
        color: UbuntuColors.red
        text: "0"
        anchors.left: txt4.right
        anchors.leftMargin: 6 * scaleFactoer
        anchors.top: txt6.bottom
        anchors.topMargin: 5 * scaleFactoer
        wrapMode: Text.NoWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    Component {
        id: alertPopup
        Dialog {
            id: alertDialog
            title: i18n.tr("Message")
            text: i18n.tr(
                      "Network is Unreachable Checking Malicious IP Skipped")

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
        id: alertPopup22
        Dialog {
            id: alertDialog22
            title: i18n.tr("Message")
            text: i18n.tr("Network is Unreachable This Will Reduce Impact of Scan")

            Button {
                text: i18n.tr("Resume")
                color: UbuntuColors.green
                onClicked: {

                    txt1.text = "Scanning...\nInstalled Applications"
                    canvas2.currentValue = 10
                    canvas2.currentColor = "#36c2f7"
                    txt8.opacity = 0.0
                    txt9.opacity = 0.0
                    startScan()
                    PopupUtils.close(alertDialog22)
                }
            }

                Button {
                    text: i18n.tr("Cancel")
                    color: UbuntuColors.red
                    onClicked: {
                        PopupUtils.close(alertDialog22)
                    }
                }

        }
    }

    Component {
        id: passwordPopup2
        Dialog {
            id: passwordDialog2
            title: i18n.tr("Enter Password")
            text: i18n.tr("Your Password is Required for This Action")

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

                    var passResult = getClickList.pass(passwordText.text)

                    if (passResult === "NO") {

                        PopupUtils.open(alertPopup2)
                        passwordDialog2.rejected()
                        PopupUtils.close(passwordDialog2)
                    } else {


                        //PopupUtils.open(waitPopup)
                        var fix = securityFIX.split('==')

                        var counterSolver = 0

                        for (counterSolver = 0; counterSolver <= fix.length - 1; counterSolver++) {

                            var com = "echo '" + passwordText.text
                                    + "' | sudo -S " + fix[counterSolver]
                            var res = getClickList.resolveRISKS(com)
                            console.log(res)
                        }

                        //PopupUtils.close(waitPopup)
                        PopupUtils.open(alertPopup3)
                        passwordDialog2.rejected()
                        PopupUtils.close(passwordDialog2)
                    }
                }
            }

            Button {
                text: i18n.tr("Cancel")
                color: UbuntuColors.red
                onClicked: {
                    passwordDialog2.rejected()
                    PopupUtils.close(passwordDialog2)
                }
            }
        }
    }

    Component {
        id: alertPopup2
        Dialog {
            id: alertDialog2
            title: i18n.tr("Message")
            text: i18n.tr("Incorrect Password")

            Button {
                text: i18n.tr("OK")
                color: UbuntuColors.green
                onClicked: {
                    PopupUtils.close(alertDialog2)
                }
            }
        }
    }

    Component {
        id: alertPopup3
        Dialog {
            id: alertDialog3
            title: i18n.tr("Message")
            text: i18n.tr("All Security Risks Fixed Successfully")

            Button {
                text: i18n.tr("OK")
                color: UbuntuColors.green
                onClicked: {
                    PopupUtils.close(alertDialog3)
                    txt1.text = "Your Device is Safe"
                    txt1.color = "#00a132"
                    txt8.opacity = 1.0
                    txt9.opacity = 1.0
                    btn1.opacity = 0.0
                    btn2.opacity = 0.0

                    canvas2.currentColor = "#00a132"
                }
            }
        }
    }

    Component {
        id: waitPopup
        Dialog {
            id: waitPopupp
            title: i18n.tr("Message")
            text: i18n.tr("Please Wait...")

            ActivityIndicator {
                id: activity
                running: true
            }
        }
    }

    Text {
        id: txt8
        y: 335 * scaleFactoer
        width: 20 * scaleFactoer
        height: 20 * scaleFactoer
        color: UbuntuColors.green
        text: "☑"
        anchors.left: txt7.right
        anchors.leftMargin: 6 * scaleFactoer
        font.pixelSize: 16 * scaleFactoer
        wrapMode: Text.NoWrap
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        opacity: 0.0
    }

    Text {
        id: txt9
        y: 310 * scaleFactoer
        width: 20 * scaleFactoer
        height: 20 * scaleFactoer
        color: UbuntuColors.green
        text: "☑"
        anchors.left: txt6.right
        anchors.leftMargin: 6 * scaleFactoer
        wrapMode: Text.NoWrap
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 16 * scaleFactoer
        verticalAlignment: Text.AlignVCenter
        opacity: 0.0
    }

    Component {
        id: resultView
        Dialog {
            id: resultViewPopupp
            title: i18n.tr("Scan Result")

            ListView {
                id: listview
                clip: true
                model: result
                width: bbttnn.width
                height: bbttnn.width
                anchors.bottom: bbttnn
                delegate: ListItem.Standard {
                    height: 80 * scaleFactoer
                    Text {
                        id: tt
                        width: bbttnn.width
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        text: modelData
                    }
                }
            }

            Button {
                id: bbttnn
                text: i18n.tr("OK")
                color: UbuntuColors.green
                onClicked: {
                    PopupUtils.close(resultViewPopupp)
                }
            }
        }
    }
}
