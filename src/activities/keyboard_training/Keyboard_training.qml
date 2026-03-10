/* GCompris - Keyboard_training.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "keyboard_training.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    // When going on configuration, it steals the focus and re set it to the activity.
    // We need to set it back to the textinput item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusTextInput()
        }
    }

     onActivityNextLevel: {
         Activity.nextLevel()
    }

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/menu/resource/background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height

        // system locale by default
        property string locale: "system"

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
            property Item main: activity.main
            property GCAudio audioVoices: activity.audioVoices
            readonly property var levels: activity.datasets.length !== 0 ? activity.datasets : null
            // Path to gletters datasets, with default-<locale>.json files in it
            readonly property string dataSetUrl: "qrc:/gcompris/src/activities/gletters/resource/"
            property string caseMode: "uppercase"
            readonly property bool uppercaseMode: caseMode === "uppercase"
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            onCurrentLevelChanged: activity.currentLevel = currentLevel
            property int numberOfLevel: 0
            onNumberOfLevelChanged: activity.numberOfLevel = numberOfLevel
            property alias bonus: bonus
            property alias wordlist: wordlist
            property alias score: score
            property alias keyboard: keyboard
            property alias questionText: questionText.text
            property string answerText: ""
            property alias badAnswerSound: badAnswerSound
            property alias locale: activityBackground.locale
            property alias errorRectangle: errorRectangle
            property alias particle: particle
            property alias textinput: textinput
            property bool inputLocked: false
            property bool subLevelCompleted: false
            property alias client: client
        }

        onStart: {
            Activity.start(items);
            Activity.focusTextInput();
        }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Client {    // Client for server version. Prepare data from activity to server
            id: client
            getDataCallback: function() {
                var data = {
                    "question": items.questionText,
                    "answer": items.answerText
                }
                return data
            }
        }

        TextInput {
            // Helper element to capture composed key events like french ô which
            // are not available via Keys.onPressed() on linux. Must be
            // disabled on mobile!
            id: textinput
            enabled: !ApplicationInfo.isMobile
            focus: true
            visible: false

            onTextChanged: {
                if (text != "") {
                    Activity.processKeyPress(text);
                    text = "";
                }
            }
        }

        Wordlist {
            id: wordlist
            defaultFilename: activity.dataSetUrl + "default-en.json"
            // To switch between locales: xx_XX stored in configuration and
            // possibly correct xx if available (ie fr_FR for french but dataset is fr.)
            useDefault: false
            filename: ""

            onError: (msg) => console.log("Type_letters: Wordlist error: " + msg);
        }

        Item {
            id: layoutArea
            anchors.top: activityBackground.top
            anchors.bottom: bar.top
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Activity.focusTextInput();
                }
            }
        }

        Rectangle {
            id: textBG
            visible: questionText.text != ""
            color: GCStyle.whiteBg
            opacity: 0.5
            width: questionText.contentWidth * 2
            height: questionText.contentHeight
            radius: GCStyle.baseMargins

            ParticleSystemStarLoader {
                id: particle
                clip: false
            }
        }

        GCText {
            id: questionText
            anchors.centerIn: textBG
            text: ""
            fontSize: 54
            font.bold: true
            color: "#d2611d"
            style: Text.Outline
            styleColor: "white"
        }

        states: [
            State {
                name: "regularKeyboard"
                when: !InputMethod.visible
                AnchorChanges {
                    target: textBG
                    anchors.top: undefined
                    anchors.horizontalCenter: layoutArea.horizontalCenter
                    anchors.verticalCenter: layoutArea.verticalCenter
                }
            },
            State {
                name: "mobileKeyboard"
                when: InputMethod.visible
                AnchorChanges {
                    target: textBG
                    anchors.top: layoutArea.top
                    anchors.horizontalCenter: layoutArea.horizontalCenter
                    anchors.verticalCenter: undefined
                }
            }
        ]

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: textBG
            radius: textBG.radius
            imageSize: height * 0.5
            function releaseControls() { items.inputLocked = false; }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                activity.home()
            }
            onLoadData: {
                if(activityData && activityData["locale"]) {
                    activityBackground.locale = Core.resolveLocale(activityData["locale"]);
                }
                else {
                    activityBackground.locale = Core.resolveLocale(activityBackground.locale)
                }
                if(activityData && activityData["caseMode"]) {
                    items.caseMode = activityData["caseMode"];
                }
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
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
               activity.displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                activity.displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(activity.nextLevel)
        }

        Score {
            id: score
            anchors.right: parent.right
            anchors.rightMargin: GCStyle.baseMargins
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.5

            onStop: {
                // if score animation finishes after voice
                if(items.subLevelCompleted && !activity.audioVoices.isPlaying()) {
                    items.subLevelCompleted = false;
                    Activity.nextSubLevel();
                }
            }
        }

        Connections {
            target: activity.audioVoices
            function onDone() {
                // if voice finishes after score animation
                if(items.subLevelCompleted && !score.isWinAnimationPlaying) {
                    items.subLevelCompleted = false;
                    Activity.nextSubLevel();
                }
            }
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            onKeypress: (text) => Activity.processKeyPress(text);
            onError: (msg) => console.log("VirtualKeyboard error: " + msg);
        }
    }
}
