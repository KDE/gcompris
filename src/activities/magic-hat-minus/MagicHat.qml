/* GCompris - MagicHat.qml
 *
 * SPDX-FileCopyrightText: 2014 Thibaut ROMAIN <thibrom@gmail.com>
 *
 * Authors:
 *   <Bruno Coudoin> (GTK+ version)
 *   Thibaut ROMAIN <thibrom@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "magic-hat.js" as Activity
import "."

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property string mode: "minus"

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        readonly property int baseMargins: 10 * ApplicationInfo.ratio
        readonly property int halfMargins: 5 * ApplicationInfo.ratio
        readonly property int starSize: Math.min((layoutArea.width - baseMargins - halfMargins * 11) / 13 ,
                                        (layoutArea.height - baseMargins * 4 - halfMargins * 7) / 9)
        signal start
        signal stop

        property var starColors : ["1", "2", "3"]

        readonly property bool horizontalLayout:
            (width - okButton.width * 4 > height - bar.height * 1.5 - 6 * baseMargins)

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        onStart: Activity.start(items, mode)
        onStop: Activity.stop()

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property alias smudgeSound: smudgeSound
            property int currentLevel: activity.currentLevel
            readonly property var levels: activity.datasets
            property alias bonus: bonus
            property alias hat: theHat
            property alias introText: introText
            property bool inputBlocked: true
            property bool coefficientVisible: false
            property var repeatersList:
                [repeaterFirstRow, repeaterSecondRow, repeaterAnswerRow]
        }

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        Item {
            id: layoutArea
            anchors.fill: parent
            anchors.margins: activityBackground.baseMargins
            anchors.topMargin: 5 * activityBackground.baseMargins
            anchors.bottomMargin: activityBackground.horizontalLayout ? bar.height * 1.5 :
                                    bar.height * 1.5 + theHat.height + activityBackground.baseMargins

            Image {
                // The math operation
                id: operatorImage
                source: mode == "minus" ? Activity.url + "minus.svg" :
                Activity.url + "plus.svg"
                anchors.right: operationLayout.left
                anchors.rightMargin: activityBackground.baseMargins
                width: activityBackground.starSize
                height: width
                sourceSize.width: width
                y: secondRow.y
            }

            Column {
                id: operationLayout
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: (operatorImage.width + activityBackground.baseMargins) * 0.5
                }
                width: items.coefficientVisible ?
                    (activityBackground.starSize + activityBackground.halfMargins) * 11 + activityBackground.starSize :
                    (activityBackground.starSize + activityBackground.halfMargins) * 10
                height: parent.height
                spacing: activityBackground.baseMargins
                Column {
                    id: firstRow
                    height: activityBackground.starSize * 3 + activityBackground.halfMargins * 2
                    spacing: activityBackground.halfMargins
                    z: 10
                    Repeater {
                        id: repeaterFirstRow
                        model: 3
                        StarsBar {
                            barGroupIndex: 0
                            barIndex: index
                            width: operationLayout.width
                            backgroundColor: "#4d4d4d"
                            starsColor: starColors[index]
                            theHat: items.hat
                            opacity: 0
                        }
                    }
                }
                Column {
                    id: secondRow
                    height: firstRow.height
                    spacing: activityBackground.halfMargins
                    z: 9
                    Repeater {
                        id: repeaterSecondRow
                        model: 3
                        StarsBar {
                            barGroupIndex: 1
                            barIndex: index
                            width: operationLayout.width
                            backgroundColor: "#4d4d4d"
                            starsColor: starColors[index]
                            theHat: items.hat
                            opacity: 0
                        }
                    }
                }

                Rectangle {
                    x: - activityBackground.halfMargins * 0.5
                    width: operationLayout.width
                    height: activityBackground.halfMargins
                    color: "white"
                }

                Column {
                    id: answerRow
                    height: firstRow.height
                    spacing: activityBackground.halfMargins
                    Repeater {
                        id: repeaterAnswerRow
                        model: 3
                        StarsBar {
                            barGroupIndex: 2
                            barIndex: index
                            width: operationLayout.width
                            backgroundColor: "#088292"
                            starsColor: starColors[index]
                            authorizeClick: false
                            theHat: items.hat
                            opacity: 0
                        }
                    }
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
            onClose: {
                home()
            }
            onStartActivity: {
                activityBackground.stop()
                activityBackground.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Hat {
            id: theHat
            anchors.bottom: parent.bottom
            anchors.bottomMargin: bar.height * 1.5
            x: Math.max(20 * ApplicationInfo.ratio, operationLayout.x * 0.5 - width * 0.5)
            height: Math.min(100 * ApplicationInfo.ratio, (activityBackground.height - anchors.bottomMargin) * 0.2)
            width: height
            starsSize: activityBackground.starSize
        }

        BarButton {
            id: okButton
            anchors {
                bottom: theHat.bottom
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: theHat.height
            enabled: !items.inputBlocked && theHat.state === "GuessNumber"
            onClicked: {
                items.inputBlocked = true
                Activity.verifyAnswer()
            }
        }

        Rectangle {
            id: introTextBG
            width: introText.contentWidth + 2 * activityBackground.baseMargins
            height: introText.contentHeight + activityBackground.baseMargins
            anchors.centerIn: introText
            color: "#373737"
            radius: activityBackground.baseMargins
            visible: introText.visible
        }

        GCText {
            id: introText
            anchors.centerIn: layoutArea
            width: parent.width - 40 * ApplicationInfo.ratio
            height: 30 * ApplicationInfo.ratio
            fontSizeMode: Text.Fit
            fontSize: regularSize
            font.bold: true
            color: "white"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Click on the hat to begin the game")
        }

        Bonus {
            id: bonus
            onLoose: items.inputBlocked = false
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
