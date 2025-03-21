/* GCompris - Scalesboard.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   miguel DE IZARRA <miguel2i@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "scalesboard.js" as Activity
import "."

ActivityBase {
    id: activity


    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        signal start
        signal stop

        property int scaleHeight: items.masseAreaLeft.weight == items.masseAreaRight.weight ? 0 :
                                 items.masseAreaLeft.weight > items.masseAreaRight.weight ? 20 : -20

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias metalSound: metalSound
            property alias errorRectangle: errorRectangle
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property int giftWeight
            property int scaleHeight: activityBackground.scaleHeight
            readonly property var levels: activity.datasets
            property alias masseAreaCenter: masseAreaCenter
            property alias masseAreaLeft: masseAreaLeft
            property alias masseAreaRight: masseAreaRight
            property alias masseCenterModel: masseAreaCenter.masseModel
            property alias masseRightModel: masseAreaRight.masseModel
            property alias question: question
            property alias numpad: numpad
            property bool rightDrop
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool isHorizontal: activityBackground.width > activityBackground.height
        property bool scoreAtBottom: bar.width * 6 + okButton.width * 1.5 + score.width < activityBackground.width

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/win.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCSoundEffect {
            id: metalSound
            source: Activity.url + "metal_hit.wav"
        }

        Image {
            id: scaleBoard
            source: Activity.url + "scale.svg"
            sourceSize.width: isHorizontal ? Math.min(parent.width - okButton.height * 2,
                                                      (parent.height - okButton.height * 2) * 2) : parent.width
            anchors.centerIn: parent
            anchors.verticalCenterOffset: scoreAtBottom ? 0 : okButton.height * -0.5
        }

        Image {
            id: needle
            parent: scaleBoard
            source: Activity.url + "needle.svg"
            sourceSize.width: parent.width * 0.75
            z: -1
            property int angle: - activityBackground.scaleHeight * 0.35
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.15
            }
            transform: Rotation {
                origin.x: needle.width / 2
                origin.y: needle.height * 0.9
                angle: needle.angle
            }
            Behavior on angle {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // === The Left plate ===
        Image {
            id: plateLeft
            parent: scaleBoard
            source: Activity.url + "plate.svg"
            sourceSize.width: parent.width * 0.35
            z: -10

            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: - parent.paintedWidth * 0.3
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.03 + activityBackground.scaleHeight
            }
            Behavior on anchors.verticalCenterOffset {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            // The Left Drop Area
            MasseArea {
                id: masseAreaLeft
                parent: scaleBoard
                width: plateLeft.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: - parent.paintedWidth * 0.3
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: - parent.paintedHeight * 0.44 + activityBackground.scaleHeight
                }
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                nbColumns: 3

                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // === The Right plate ===
        Image {
            id: plateRight
            parent: scaleBoard
            source: Activity.url + "plate.svg"
            sourceSize.width: parent.width * 0.35
            z: -10
            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: parent.paintedWidth * 0.3
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: - parent.paintedHeight * 0.03 - activityBackground.scaleHeight
            }
            Behavior on anchors.verticalCenterOffset {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.InOutQuad
                }
            }

            // The Right Drop Area
            MasseArea {
                id: masseAreaRight
                parent: scaleBoard
                width: plateRight.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.paintedWidth * 0.3
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: - parent.paintedHeight * 0.44 - activityBackground.scaleHeight
                }
                masseAreaCenter: masseAreaCenter
                masseAreaLeft: masseAreaLeft
                masseAreaRight: masseAreaRight
                nbColumns: 3
                dropEnabledForThisLevel: items.rightDrop

                Behavior on anchors.verticalCenterOffset {
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        // === The Initial Masses List ===
        MasseArea {
            id: masseAreaCenter
            parent: scaleBoard
            x: parent.width * 0.05
            y: parent.height * 0.84 - height
            width: parent.width
            masseAreaCenter: masseAreaCenter
            masseAreaLeft: masseAreaLeft
            masseAreaRight: masseAreaRight
            nbColumns: masseModel.count
        }

        Message {
            id: message
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 10
                left: parent.left
                leftMargin: 10
            }
        }

        Question {
            id: question
            parent: scaleBoard
            anchors.horizontalCenter: scaleBoard.horizontalCenter
            anchors.top: masseAreaCenter.top
            anchors.bottom: masseAreaCenter.bottom
            z: 1000
            width: isHorizontal ? parent.width * 0.5 : activityBackground.width - 160 * ApplicationInfo.ratio
            answer: items.giftWeight
            visible: (items.question.text && activityBackground.scaleHeight === 0) ? true : false
        }

        ErrorRectangle {
            id: errorRectangle
            z: 1010
            parent: scaleBoard
            height: parent.height * 0.5
            radius: 10 * ApplicationInfo.ratio
            imageSize: okButton.width
            function releaseControls() {
                items.buttonsBlocked = false;
            }
            states: [
                State {
                    when: question.visible
                    AnchorChanges {
                        target: errorRectangle
                        anchors.left: question.left
                        anchors.right: question.right
                        anchors.top: question.top
                        anchors.bottom: question.bottom
                    }
                },
                State {
                    when: !question.visible
                    AnchorChanges {
                        target: errorRectangle
                        anchors.left: plateLeft.right
                        anchors.right: plateRight.left
                        anchors.top: parent.top
                        anchors.bottom: undefined
                    }
                }
            ]
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
                // restart activity on saving
                activityBackground.start()
            }
            onClose: {
                home()
            }
            onStartActivity: {
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 60 * ApplicationInfo.ratio
            enabled: !items.buttonsBlocked && (items.question.text ?  items.question.userEntry : masseAreaLeft.weight != 0)
            ParticleSystemStarLoader {
                id: okButtonParticles
                clip: false
            }
            onClicked: {
                Activity.checkAnswer();
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onLevelChanged: message.text = items.levels[bar.level - 1].message ? items.levels[bar.level - 1].message : ""
        }

        Score {
            id: score
            onStop: { Activity.nextSubLevel(); }
        }

        states: [
            State {
                name: "horizontalLayout"; when: activityBackground.scoreAtBottom
                AnchorChanges {
                    target: score
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.right: okButton.left
                    anchors.verticalCenter: okButton.verticalCenter
                }
                AnchorChanges {
                    target: okButton
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: bar.verticalCenter
                    anchors.bottom: undefined
                    anchors.right: activityBackground.right
                    anchors.left: undefined
                }
                PropertyChanges {
                    okButton {
                        anchors.bottomMargin: 0
                        anchors.rightMargin: okButton.width * 0.5
                        anchors.verticalCenterOffset: -10
                    }
                }
            },
            State {
                name: "verticalLayout"; when: !activityBackground.scoreAtBottom
                AnchorChanges {
                    target: score
                    anchors.top: undefined
                    anchors.bottom: undefined
                    anchors.right: okButton.left
                    anchors.verticalCenter: okButton.verticalCenter
                }
                AnchorChanges {
                    target: okButton
                    anchors.horizontalCenter: undefined
                    anchors.verticalCenter: undefined
                    anchors.bottom: bar.top
                    anchors.right: undefined
                    anchors.left: activityBackground.horizontalCenter
                }
                PropertyChanges {
                    okButton {
                        anchors.bottomMargin: okButton.height * 0.5
                        anchors.rightMargin: 0
                        anchors.verticalCenterOffset: 0
                    }
                }
            }
        ]

        NumPad {
            id: numpad
            onAnswerChanged: question.userEntry = answer
            maxDigit: ('' + items.giftWeight).length + 1
            opacity: question.visible ? 1 : 0
            columnWidth: 60 * ApplicationInfo.ratio
            enableInput: !items.buttonsBlocked
        }

        Keys.enabled: !items.buttonsBlocked
        Keys.onPressed: (event) => {
            if(okButton.enabled && (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)) {
                    Activity.checkAnswer()
            }
            else if(question.visible) {
                    numpad.updateAnswer(event.key, true);
            }
        }

        Keys.onReleased: (event) => {
            if(question.visible) {
                numpad.updateAnswer(event.key, false);
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
