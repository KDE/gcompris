/* GCompris - Clockgame.qml
*
* SPDX-FileCopyrightText: 2014 Stephane Mankowski <stephane@mankowski.fr>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
*   Stephane Mankowski <stephane@mankowski.fr> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
pragma ComponentBehavior: Bound

import QtQuick
import core 1.0

import "../../core"
import "clockgame.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {

    }

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/menu/resource/background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        signal start
        signal stop

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property alias activityBackground: activityBackground
            property alias errorRectangle: errorRectangle
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property int targetH: 12
            property int targetM: 0
            property int targetS: 0
            property int currentH: 1
            property int currentM: 25
            property int currentS: 43
            property int numberOfTry: 3
            property int currentTry: 0
            readonly property var levels: activity.datasets
            property bool minutesHandVisible
            property bool secondsHandVisible
            property bool zonesVisible
            property bool hoursMarksVisible
            property bool hoursVisible
            property bool minutesVisible
            property bool noHint
            property bool useTwelveHourFormat: true
            property bool buttonsBlocked: false
        }

        onStart: {
            Activity.start(items)
        }
        onStop: {
            Activity.stop()
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Score {
            id: score
            anchors {
                bottom: bar.top
                bottomMargin: 2 * GCStyle.baseMargins
                left: parent.left
                leftMargin: GCStyle.baseMargins
                right: undefined
                top: undefined
            }
            onStop: { Activity.nextSubLevel() }
        }

        /* Target text */
        GCTextPanel {
            id: instructionPanel
            z: 10
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: (parent.height - zones.height) * 0.5 - GCStyle.baseMargins - GCStyle.halfMargins
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins
            textItem.text: qsTr("Set the watch to:") + " " +
            //~ singular %n hour
            //~ plural %n hours
            addNbsp(qsTr("%n hour(s)", "", items.targetH)) + " " +
            //~ singular %n minute
            //~ plural %n minutes
            addNbsp(qsTr("%n minute(s)", "", items.targetM)) +
            //~ singular %n second
            //~ plural %n seconds
            (s.visible ? " " + addNbsp(qsTr("%n second(s)", "", items.targetS)) : "")
            textItem.fontSize: textItem.mediumSize

            // We don't want the wrapping to happen anywhere, set no break space
            function addNbsp(str: string): string {
                return str.replace(" ", " "); // non-breaking space character
            }
        }

        /* The clock */
        Image {
            id: clock
            source: activity.resourceUrl + "clock_bg.svg"
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            sourceSize.width: radius * 0.9

            property int radius: Math.min(activityBackground.width, activityBackground.height - bar.height)

            /* The grey zones */
            Image {
                id: zones
                source: activity.resourceUrl + "clock_zones.svg"
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                sourceSize.width: parent.width * 0.8
                visible: items.zonesVisible
                z: 2
            }

            /* The setter */
            Image {
                id: setter
                source: activity.resourceUrl + "clock_setter.svg"
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.right
                    leftMargin: -10
                }
                z: 1
            }

            /* The minutes */
            Repeater {
                model: 60
                GCText {
                    required property int index
                    text: index + 1
                    font {
                        pointSize: NaN  // need to clear font.pointSize explicitly
                        pixelSize: Math.max(
                                       (index + 1) % 5
                                       === 0 ? clock.radius / 40 : clock.radius / 45,
                                               1)
                        bold: items.currentM === ((index + 1) % 60) || (items.currentS === ((index + 1) % 60) && s.visible)
                        underline: items.currentM === ((index + 1) % 60) || (items.currentS === ((index + 1) % 60) && s.visible)
                    }
                    anchors {
                        verticalCenter: clock.verticalCenter
                        horizontalCenter: clock.horizontalCenter
                        verticalCenterOffset: -clock.radius * 0.33 * Math.cos(
                                                  (index + 1) * 2 * Math.PI / 60)
                        horizontalCenterOffset: clock.radius * 0.33 * Math.sin(
                                                    (index + 1) * 2 * Math.PI / 60)
                    }
                    z: 4
                    color: "#d56a3a"
                    visible: items.minutesHandVisible && items.minutesVisible
                }
            }
            /* The seconds */
            Repeater {
                model: 60

                Rectangle {
                    required property int index
                    color: "#d56a3a"
                    width: clock.radius * 0.02
                    height: 2
                    rotation: 90 + (index + 1) * 360 / 60
                    radius: 1
                    anchors {
                        verticalCenter: clock.verticalCenter
                        horizontalCenter: clock.horizontalCenter
                        verticalCenterOffset: -clock.radius * 0.3 * Math.cos(
                                                  (index + 1) * 2 * Math.PI / 60)
                        horizontalCenterOffset: clock.radius * 0.3 * Math.sin(
                                                    (index + 1) * 2 * Math.PI / 60)
                    }
                    z: 4
                    visible: items.secondsHandVisible
                }
            }

            /* The hours */
            Repeater {
                model: 12
                GCText {
                    id: hourText
                    required property int index
                    text: index + 1
                    font {
                        pointSize: NaN  // need to clear font.pointSize explicitly
                        pixelSize: Math.max(clock.radius / 30, 1)
                        bold: items.currentH === ((index + 1) % 12)
                        underline: items.currentH === ((index + 1) % 12)
                    }
                    anchors {
                        verticalCenter: clock.verticalCenter
                        horizontalCenter: clock.horizontalCenter
                        verticalCenterOffset: -clock.radius * 0.26 * Math.cos(
                                                  (index + 1) * 2 * Math.PI / 12)
                        horizontalCenterOffset: clock.radius * 0.26 * Math.sin(
                                                    (index + 1) * 2 * Math.PI / 12)
                    }
                    z: 4
                    color: "#3a81d5"
                    visible: items.hoursVisible
                }
            }

            Repeater {
                model: 12

                Rectangle {
                    required property int index
                    color: "#3a81d5"
                    width: clock.radius * 0.03
                    height: 4
                    rotation: 90 + (index + 1) * 360 / 12
                    radius: 1
                    anchors {
                        verticalCenter: clock.verticalCenter
                        horizontalCenter: clock.horizontalCenter
                        verticalCenterOffset: -clock.radius * 0.3 * Math.cos(
                                                  (index + 1) * 2 * Math.PI / 12)
                        horizontalCenterOffset: clock.radius * 0.3 * Math.sin(
                                                    (index + 1) * 2 * Math.PI / 12)
                    }
                    z: 4
                    visible: items.hoursMarksVisible || !items.hoursMarksVisible && (index + 1) % 3 === 0
                }
            }

            /* Help text */
            GCText {
                id: helper
                text:  Activity.get2CharValue(items.useTwelveHourFormat ? items.currentH : items.currentH+12) + ":" +
                       Activity.get2CharValue(items.currentM) + ":" +
                       Activity.get2CharValue(items.currentS)
                font.pointSize: NaN
                font.pixelSize: Math.max(clock.radius / 30, 1)
                anchors {
                    verticalCenter: clock.verticalCenter
                    horizontalCenter: clock.horizontalCenter
                    verticalCenterOffset: clock.radius * 0.2
                }
                z: 4
                opacity: items.noHint ? 0 : 1
                color: GCStyle.darkerText
                visible: false
            }

            /* Arrow H */
            Rectangle {
                id: h
                property alias angle: roth.angle
                height: clock.radius * 0.2
                width: height / 10
                radius: width / 2
                color: "#3a81d5"
                transform: Rotation {
                    id: roth
                    origin.x: h.width / 2
                    origin.y: 0
                    angle: (180 + 360 * (items.currentH / 12 + items.currentM / 60 / 12)) % 360
                    Behavior on angle {
                        RotationAnimation {
                            duration: 100
                            direction: RotationAnimation.Shortest
                        }
                    }
                }

                anchors {
                    verticalCenter: clock.verticalCenter
                    horizontalCenter: clock.horizontalCenter
                    verticalCenterOffset: h.height / 2
                }
                z: 5
            }

            /* Arrow M */
            Rectangle {
                id: m
                property alias angle: rotm.angle
                height: clock.radius * 0.28
                width: height / 20
                radius: width / 2
                color: "#d56a3a"
                visible: items.minutesHandVisible
                transform: Rotation {
                    id: rotm
                    origin.x: m.width / 2
                    origin.y: 0
                    angle: (180 + 360 * (items.currentM / 60 + items.currentS / 60 / 60)) % 360
                    Behavior on angle {
                        RotationAnimation {
                            duration: 100
                            direction: RotationAnimation.Shortest
                        }
                    }
                }

                anchors {
                    verticalCenter: clock.verticalCenter
                    horizontalCenter: clock.horizontalCenter
                    verticalCenterOffset: m.height / 2
                }
                z: 6
            }

            /* Arrow S */
            Rectangle {
                id: s
                property alias angle: rots.angle
                height: clock.radius * 0.32
                width: height / 30
                radius: width / 2
                color: "#2ccf4b"
                visible: items.secondsHandVisible
                transform: Rotation {
                    id: rots
                    origin.x: s.width / 2
                    origin.y: 0
                    angle: (180 + 360 * items.currentS / 60) % 360
                    Behavior on angle {
                        RotationAnimation {
                            duration: 100
                            direction: RotationAnimation.Shortest
                        }
                    }
                }

                anchors {
                    verticalCenter: clock.verticalCenter
                    horizontalCenter: clock.horizontalCenter
                    verticalCenterOffset: s.height / 2
                }
                z: 7
            }

            /* Center */
            Rectangle {
                id: center
                color: "#2a2a2a"
                height: clock.radius / 25
                width: height
                radius: width / 2
                anchors.centerIn: clock
                z: 8
            }

            /* Manage the move */
            MouseArea {
                anchors.fill: parent
                enabled: !items.buttonsBlocked
                acceptedButtons: Qt.LeftButton
                onPressed: {
                    /* Find the closer Arrow */
                    var a = (270 + 360 + 180 * Math.atan2(
                                 mouseY - (center.y + center.height / 2),
                                 mouseX - (center.x + center.width / 2)) / Math.PI) % 360
                    var agnh = h.angle
                    var angm = m.angle
                    var angs = s.angle
                    var dh = Math.min(Math.abs(a - agnh),
                                      Math.abs(a - agnh - 360),
                                      Math.abs(a - agnh + 360))
                    var dm = m.visible ? Math.min(Math.abs(a - angm),
                                             Math.abs(a - angm - 360),
                                             Math.abs(a - angm + 360)) : 9999
                    var ds = s.visible ? Math.min(
                                             Math.abs(a - angs),
                                             Math.abs(a - angs - 360),
                                             Math.abs(a - angs + 360)) : 9999
                    var dmin = Math.min(dh, dm, ds)

                    if (dh === dmin) {
                        Activity.selectedArrow = h
                    } else if (dm === dmin) {
                        Activity.selectedArrow = m
                    } else {
                        Activity.selectedArrow = s
                    }
                }

                onMouseXChanged: {
                    /* Move */
                    if (Activity.selectedArrow !== null) {
                        var a = (270 + 360 + 180 * Math.atan2(
                                     mouseY - (center.y + center.height / 2),
                                     mouseX - (center.x + center.width / 2)) / Math.PI) % 360

                        var previousM = items.currentM
                        var previousS = items.currentS

                        if (Activity.selectedArrow === h) {
                            items.currentH = Math.round(
                                        12 * ((a - 180) / 360 - items.currentM / 60 / 12) + 12) % 12
                        } else if (Activity.selectedArrow === m) {
                            items.currentM = Math.round(
                                        60 * ((a - 180) / 360 - items.currentS / 60 / 60) + 60) % 60
                        } else {
                            items.currentS = Math.round(
                                        60 * (a - 180) / 360 + 60) % 60
                        }

                        if (previousS > 45 && items.currentS < 15)
                            items.currentM = (items.currentM + 1 + 60) % 60
                        if (previousS < 15 && items.currentS > 45)
                            items.currentM = (items.currentM - 1 + 60) % 60
                        if (previousM > 45 && items.currentM < 15)
                            items.currentH = (items.currentH + 1 + 12) % 12
                        if (previousM < 15 && items.currentM > 45)
                            items.currentH = (items.currentH - 1 + 12) % 12
                    }
                }
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.centerIn: clock
            width: zones.width
            height: zones.height
            radius: width * 0.5
            imageSize: okButton.width
            function releaseControls() {
                items.buttonsBlocked = false;
            }
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: GCStyle.bigButtonHeight
            anchors.bottom: bar.top
            anchors.bottomMargin: 2 * GCStyle.baseMargins
            anchors.right: parent.right
            anchors.rightMargin: GCStyle.baseMargins
            enabled: !items.buttonsBlocked
            ParticleSystemStarLoader {
                id: okButtonParticles
                clip: false
            }
            MouseArea {
                id: okButtonMouseArea
                anchors.fill: parent
                onClicked: {
                    Activity.checkAnswer()
                }
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                    if(activityData["mode"] == 1) {
                        items.useTwelveHourFormat = true;
                    }
                    else {
                        items.useTwelveHourFormat = false;
                    }
                }
            }
            onClose: {
                activity.home()
            }
            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: items.noHint ? withoutHint : withHint

            property BarEnumContent withHint: BarEnumContent { value: help | home | level | hint | activityConfig }
            property BarEnumContent withoutHint: BarEnumContent { value: help | home | level | activityConfig }

            onHelpClicked: {
                activity.displayDialog(dialogHelp)
            }
            onHintClicked: {
                helper.visible = !helper.visible
            }
            onActivityConfigClicked: {
                activity.displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
