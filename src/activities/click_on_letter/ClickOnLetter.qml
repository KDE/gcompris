/* GCompris - ClickOnLetter.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0
import "../../core"
import "click_on_letter.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity
    focus: true

    /* mode of the activity, either "lowercase" (click_on_letter)
     * or "uppercase" (click_on_letter_up): */
    property string mode: "lowercase"

    onStart: focus = true

    // When opening a dialog, it steals the focus and re set it to the activity.
    // We need to set it back to the eventHandler item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusEventHandler()
        }
    }

    pageComponent: Image {
        id: background
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        verticalAlignment: Image.AlignBottom
        focus: true

        // system locale by default
        property string locale: "system"

        signal start
        signal stop
        signal voiceError
        signal voiceDone

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item activityPage: activity
            property int currentLevel: activity.currentLevel
            property alias trainModel: trainModel
            property GCAudio audioVoices: activity.audioVoices
            property alias winSound: winSound
            property alias parser: parser
            property alias questionItem: questionItem
            property alias repeatItem: repeatItem
            property alias score: score
            property alias bonus: bonus
            property alias locale: background.locale
            property bool keyNavigationMode: false
            property int lastSelectedIndex: -1
            property alias eventHandler: eventHandler
            property alias errorRectangle: errorRectangle
            property bool buttonsBlocked: false
        }

        onVoiceError: {
            questionItem.visible = true;
            repeatItem.visible = false;
        }

        onStart: {
            activity.audioVoices.done.connect(voiceDone);
            activity.audioVoices.error.connect(voiceError);
            Activity.start(items, mode);
            eventHandler.forceActiveFocus();
        }

        onStop: Activity.stop()

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        GCSoundEffect {
            id: crashSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCSoundEffect {
            id: winSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        Item {
            id: eventHandler
            focus: true
            Keys.enabled: !items.buttonsBlocked && !dialogActivityConfig.visible
            Keys.onPressed: (event) => {
                if(event.key === Qt.Key_Tab) {
                    activity.audioVoices.clearQueue();
                    activity.audioVoices.stop();
                    Activity.playLetter(Activity.currentLetter);
                } else {
                    background.handleKeys(event);
                }
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home();
                eventHandler.forceActiveFocus();
            }
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels;
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels;
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels);
            }
            onLoadData: {
                if(activityData && activityData["locale"]) {
                    background.locale = Core.resolveLocale(activityData["locale"]);
                }
                else {
                    background.locale = Core.resolveLocale(background.locale);
                }
            }
            onStartActivity: {
                background.stop();
                background.start();
                eventHandler.forceActiveFocus();
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Score {
            id: score
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.left: parent.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
            anchors.right: undefined
            onStop: Activity.nextSubLevel()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            width: 80 * ApplicationInfo.ratio
            anchors {
                top: parent.top
                right: parent.right
                margins: 10
            }
            onClicked: {
                if(!activity.audioVoices.isPlaying()) {
                    Activity.playLetter(Activity.currentLetter);
                }
            }
        }

        Image {
            id: railway
            source: Activity.url + "railway.svg"
            fillMode: Image.PreserveAspectCrop
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            sourceSize.width: width
            sourceSize.height: height
            anchors.bottomMargin: bar.height * 1.5
        }

        Rectangle {
            id: questionItem
            anchors.fill: repeatItem
            border.color: "#FFFFFF"
            border.width: 2
            color: "#2881C3"
            radius: 10
            visible: false

            property alias text: questionText.text

            GCText {
                id: questionText
                anchors.centerIn: parent
                width: repeatItem.width
                height: repeatItem.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                z:11
                text: ""
                fontSizeMode: Text.Fit
                minimumPointSize: 10
                fontSize: width > 0 ? width : 128
                font.bold: true
                color: "white"
            }
        }

        ListModel {
            id: trainModel
        }

        //always calculate layout for a maximum of 24 letters per level
        //adding 1 extra to px and py to include one more item (the engine) in the calculation
        property int itemWidth: Core.fitItems(wholeTrainArea.width, wholeTrainArea.height, 24, 1)

        Image {
            id: engine
            source: Activity.url + "engine.svg"
            anchors.bottom: wholeTrainArea.bottom
            anchors.left: wholeTrainArea.left
            sourceSize.width: itemWidth
            sourceSize.height: itemWidth
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: smoke
            source: Activity.url + "smoke.svg"
            anchors.bottom: engine.top
            anchors.left: engine.left
            anchors.bottomMargin: 5 * ApplicationInfo.ratio
            sourceSize.width: engine.width
            fillMode: Image.PreserveAspectFit
        }

        Item {
            id: wholeTrainArea
            anchors.bottom: railway.bottom
            anchors.left: background.left
            anchors.right: background.right
            anchors.top: repeatItem.bottom
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottomMargin: 5 * ApplicationInfo.ratio
        }

        GridView {
            id: train
            anchors.bottom: engine.bottom
            anchors.top: wholeTrainArea.top
            anchors.right: wholeTrainArea.right
            anchors.left: engine.right
            cellWidth: itemWidth
            cellHeight: itemWidth
            clip: false
            interactive: false
            verticalLayoutDirection: GridView.BottomToTop
            layoutDirection: Qt.LeftToRight
            keyNavigationWraps: true
            currentIndex: -1

            model: trainModel
            delegate: Carriage {
                width: train.cellWidth
                height: train.cellHeight
                nbCarriage: train.width / train.cellWidth - 1
                clickEnabled: items.buttonsBlocked ? false : (activity.audioVoices.playbackState == 1 ? false : true)
                isSelected: train.currentIndex === index
            }
        }

        ErrorRectangle {
            id: errorRectangle
            z: 20
            anchors.centerIn: parent
            width: 2
            height: 2
            imageSize: train.cellWidth * 0.75
            function releaseControls() {
                items.buttonsBlocked = false;
            }
        }

        function moveErrorRectangle(clickedItem) {
            errorRectangle.parent = clickedItem
            errorRectangle.startAnimation()
            crashSound.play()
        }

        function handleKeys(event) {
            if(!items.keyNavigationMode) {
                smudgeSound.play();
                items.keyNavigationMode = true;
                if(items.lastSelectedIndex > 0 && items.lastSelectedIndex < trainModel.count)
                    train.currentIndex = items.lastSelectedIndex;
                else
                    train.currentIndex = 0;
            } else if(event.key === Qt.Key_Right) {
                smudgeSound.play();
                train.moveCurrentIndexRight();
            } else if(event.key === Qt.Key_Left) {
                smudgeSound.play();
                train.moveCurrentIndexLeft();
            } else if(event.key === Qt.Key_Up) {
                smudgeSound.play();
                train.moveCurrentIndexUp();
            } else if(event.key === Qt.Key_Down) {
                smudgeSound.play();
                train.moveCurrentIndexDown();
            } else if(event.key === Qt.Key_Space && activity.audioVoices.playbackState != 1) {
                items.buttonsBlocked = true;
                if(Activity.checkAnswer(train.currentIndex)) {
                    train.currentItem.successAnimation.restart();
                    train.currentItem.particle.burst(30);
                } else {
                    moveErrorRectangle(train.currentItem);
                }
            }
        }

        JsonParser {
            id: parser
            onError: (msg) => console.error("Click_on_letter: Error parsing JSON: " + msg);
        }

    }
}
