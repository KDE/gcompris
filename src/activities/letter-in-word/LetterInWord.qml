/* GCompris - LetterInWord.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *               2016 Akshat Tandon <akshat.tandon@research.iiit.ac.in>
 *               2020 Timothée Giet <animtim@gmail.com>

 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de> (Click on Letter - Qt Quick port)
 *   Akshat Tandon <akshat.tandon@research.iiit.ac.in> (Adapt Click on Letter to make Letter in which word)
 *   Timothée Giet <animtim@gmail.com> (Refactoring, fixes and improvements)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0
import "../../core"
import "letter-in-word.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity
    focus: true

    onStart: focus = true

    pageComponent: Image {
        id: activityBackground
        source: Activity.resUrl + "hillside.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectCrop
        focus: true

        // system locale by default
        property string locale: "system"

        property bool englishFallback: false

        signal start
        signal stop
        signal voiceError

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Timer {
            id: voiceTimer
            interval: 200
            repeat: true
            onTriggered: {
                if(DownloadManager.areVoicesRegistered(activityBackground.locale)) {
                    voiceTimer.stop();
                    Activity.appendVoice();
                }
            }
        }

        QtObject {
            id: items
            property Item activityPage: activity
            property int currentLevel: activity.currentLevel
            property alias activityBackground: activityBackground
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias wordsModel: wordsModel
            property int currentLetterCase: ApplicationSettings.fontCapitalization
            property int currentMode: normalModeWordCount
            readonly property int easyModeWordCount: 5
            readonly property int normalModeWordCount: 11
            property GCAudio audioVoices: activity.audioVoices
            property alias parser: parser
            property alias animateX: animateX
            property alias repeatItem: repeatItem
            property alias score: score
            property alias bonus: bonus
            property alias errorRectangle: errorRectangle
            property alias locale: activityBackground.locale
            property alias questionItem: questionItem
            property alias englishFallbackDialog: englishFallbackDialog
            property string question
            property bool buttonsBlocked: false
            property alias voiceTimer: voiceTimer
        }

        onStart: {
            activity.audioVoices.error.connect(voiceError)
            Activity.start(items);
        }

        onStop: {
            voiceTimer.stop();
            Activity.stop();
        }

        onWidthChanged: {
                animateX.restart();
        }

        onHeightChanged: {
                animateX.restart();
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home();
            }
            onLoadData: {
                if(activityData && activityData["locale"] && activityData["locale"] !== "system") {
                    activityBackground.locale = activityData["locale"];
                }
                else {
                    activityBackground.locale = Core.resolveLocale(activityBackground.locale)
                }
                if(activityData && activityData["savedLetterCase"]) {
                    items.currentLetterCase = activityData["savedLetterCase"];
                }
                if(activityData && activityData["savedMode"]) {
                    items.currentMode = activityData["savedMode"];
                }
            }
            onStartActivity: {
                activityBackground.stop();
                activityBackground.start();
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
                displayDialog(dialogActivityConfig);
            }
        }

        Score {
            id: score
            anchors {
                right: parent.right
                rightMargin: GCStyle.baseMargins
                bottom: wordsView.bottom
                left: undefined
                top: undefined
            }
            onStop: Activity.nextSubLevel();
        }

        Bonus {
            id: bonus
            interval: 100
            Component.onCompleted: {
                win.connect(Activity.nextLevel);
            }
        }

        Item {
            id: planeText
            width: plane.width
            height: plane.height
            x: -width
            anchors.top: parent.top
            anchors.topMargin: GCStyle.baseMargins

            Image {
                id: plane
                anchors.centerIn: planeText
                anchors.top: parent.top
                source: Activity.resUrl + "plane.svg"
                sourceSize.height: 90 * ApplicationInfo.ratio
            }

            GCText {
                id: questionItem
                width: plane.width * 0.6
                height: plane.height * 0.8
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: plane.verticalCenter
                anchors.verticalCenterOffset : height * -0.1
                anchors.left: plane.left
                fontSize: hugeSize
                fontSizeMode: Text.Fit
                font.weight: Font.DemiBold
                color: GCStyle.darkerText
                text: items.question
            }

            PropertyAnimation {
                id: animateX
                target: planeText
                properties: "x"
                from: -planeText.width
                to: bar.level <= 2 ? activityBackground.width * 0.5 - questionItem.width * 0.5 : activityBackground.width
                duration: bar.level <= 2 ? 5500 : 11000
                easing.type: bar.level <= 2 ? Easing.OutQuad: Easing.OutInCirc
            }
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg"
            width: GCStyle.bigButtonHeight
            anchors {
                top: parent.top
                right: parent.right
                margins: GCStyle.baseMargins
            }
            onClicked:{
                if(!audioVoices.isPlaying() && !items.buttonsBlocked) {
                    Activity.playLetter(Activity.currentLetter);
                    animateX.restart();
                }
            }
        }

        Keys.enabled: !items.buttonsBlocked
        Keys.onSpacePressed: wordsView.currentItem.select();
        Keys.onTabPressed: repeatItem.clicked();
        Keys.onEnterPressed: ok.clicked();
        Keys.onReturnPressed: ok.clicked();
        Keys.onRightPressed: wordsView.moveCurrentIndexRight();
        Keys.onLeftPressed: wordsView.moveCurrentIndexLeft();
        Keys.onDownPressed: wordsView.moveCurrentIndexDown();
        Keys.onUpPressed: wordsView.moveCurrentIndexUp();

        ListModel {
            id: wordsModel
        }

        property int itemWidth: Core.fitItems(wordsView.width, wordsView.height, wordsView.count);

        GridView {
            id: wordsView
            anchors.bottom: bar.top
            anchors.left: parent.left
            anchors.right: ok.left
            anchors.top: planeText.bottom
            anchors.topMargin: 0
            anchors.leftMargin: GCStyle.baseMargins
            anchors.rightMargin: GCStyle.baseMargins
            anchors.bottomMargin: bar.height * 0.5
            cellWidth: activityBackground.itemWidth
            cellHeight: activityBackground.itemWidth
            clip: false
            interactive: false
            layoutDirection: Qt.LeftToRight
            currentIndex: -1
            highlight: gridHighlight
            highlightFollowsCurrentItem: true
            keyNavigationWraps: true
            model: wordsModel
            delegate: Card {
                width: activityBackground.itemWidth
                height: activityBackground.itemWidth - GCStyle.baseMargins
                mouseActive: !items.buttonsBlocked
            }
        }

        Component {
            id: gridHighlight
            Rectangle {
                width: activityBackground.itemWidth
                height: activityBackground.itemWidth
                color:  "#AAFFFFFF"
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        BarButton {
            id: ok
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: repeatItem.width
            anchors {
                bottom: score.top
                margins: GCStyle.baseMargins
                horizontalCenter: score.horizontalCenter
            }
            onClicked: {
                if(!items.buttonsBlocked)
                    Activity.checkAnswer();
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: wordsView
            radius: GCStyle.baseMargins
            imageSize: Math.min(width, height) * 0.5
            function releaseControls() {
                items.buttonsBlocked = false;
            }
        }

        JsonParser {
            id: parser
            onError: (msg) => console.error("Letter-in-word: Error parsing JSON: " + msg);
        }

        Loader {
            id: englishFallbackDialog
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                message: qsTr("We are sorry, we don't have yet a translation for your language.") + " " +
                         qsTr("GCompris is developed by the KDE community, you can translate GCompris by joining a translation team on <a href=\"%2\">%2</a>").arg("https://l10n.kde.org/") +
                         "<br /> <br />" +
                         qsTr("We switched to English for this activity but you can select another language in the configuration dialog.")
                onClose: {
                    activityBackground.englishFallback = false;
                    Core.checkForVoices(activity);
                }
            }
            anchors.fill: parent
            focus: true
            active: activityBackground.englishFallback
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
