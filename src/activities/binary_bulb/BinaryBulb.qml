/* GCompris - BinaryBulb.qml
 *
 * SPDX-FileCopyrightText: 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * Authors:
 *   RAJAT ASTHANA <rajatasthana4@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "binary_bulb.js" as Activity
import "numbers.js" as Dataset

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property var dataset: Dataset.get()

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "../digital_electricity/resource/texture01.webp"
        fillMode: Image.Tile
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias bulbs: bulbs
            property int numberSoFar: 0
            property int numberToConvert: 0
            property int numberOfBulbs: 0
            property int currentSelectedBulb: -1
            property alias score: score
            property alias errorRectangle: errorRectangle
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items, dataset) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        // Tutorial section starts
        Image {
            id: tutorialImage
            source: "../digital_electricity/resource/texture01.webp"
            anchors.fill: parent
            fillMode: Image.Tile
            z: 5
            visible: true
            Tutorial {
                id: tutorialSection
                tutorialDetails: Activity.tutorialInstructions
                useImage: false
                onSkipPressed: {
                    Activity.initLevel()
                    tutorialImage.visible = false
                }
            }
        }
        // Tutorial section ends

        // Needed to get keyboard focus on Tutorial
        Keys.forwardTo: [tutorialSection]

        Keys.onPressed: (event) => {
            if(items.buttonsBlocked)
                return
            if(event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                Activity.equalityCheck()
            }
            else if(event.key === Qt.Key_Space) {
                if(items.currentSelectedBulb != -1) {
                    Activity.changeState(items.currentSelectedBulb)
                }
            }
            else if(event.key === Qt.Key_Left) {
                if(--items.currentSelectedBulb < 0) {
                    items.currentSelectedBulb = items.numberOfBulbs-1
                }
            }
            else if(event.key === Qt.Key_Right) {
                if(++items.currentSelectedBulb >= items.numberOfBulbs) {
                    items.currentSelectedBulb = 0
                }
            }
        }

        Rectangle {
            id: questionItemBackground
            opacity: 0
            z: 10
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 10
            }
            height: activityBackground.height / 6
            width: parent.width - 20 * ApplicationInfo.ratio
        }

        GCText {
            id: questionItem
            anchors.fill: questionItemBackground
            anchors.bottom: questionItemBackground.bottom
            fontSizeMode: Text.Fit
            wrapMode: Text.Wrap
            z: 4
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("What is the binary representation of %1?").arg(items.numberToConvert)
        }

        Row {
            id: bulbsRow
            anchors.top: questionItem.bottom
            anchors.topMargin: 30 * ApplicationInfo.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10 * ApplicationInfo.ratio
            Repeater {
                id: bulbs
                model: items.numberOfBulbs
                LightBulb {
                    height: activityBackground.height / 5
                    width: (activityBackground.width >= activityBackground.height) ? (activityBackground.width / 20) : ((activityBackground.width - (16 * bulbsRow.spacing)) / 8)
                    valueVisible: dataset[items.currentLevel].bulbValueVisible
                }
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: bulbsRow
            z: score.z
            imageSize: okButton.width
            function releaseControls() { items.buttonsBlocked = false; }
        }

        GCText {
            id: reachedSoFar
            anchors.horizontalCenter: bulbsRow.horizontalCenter
            anchors.top: bulbsRow.bottom
            anchors.topMargin: 30 * ApplicationInfo.ratio
            color: "white"
            fontSize: largeSize
            text: items.numberSoFar
            visible: dataset[items.currentLevel].enableHelp
        }

        BarButton {
            id: okButton
            anchors {
                bottom: bar.top
                right: parent.right
                rightMargin: 10 * ApplicationInfo.ratio
                bottomMargin: 10 * ApplicationInfo.ratio
            }
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 60 * ApplicationInfo.ratio
            onClicked: Activity.equalityCheck()
            enabled: !items.buttonsBlocked
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: tutorialImage.visible ? (help | home) : (help | home | level) }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Score {
            id: score
            visible: !tutorialImage.visible
            anchors.bottom: bar.top
            anchors.right: bar.right
            anchors.left: parent.left
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.rightMargin: 0
            onStop: Activity.nextSubLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
