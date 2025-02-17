/* gcompris - Planegame.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import core 1.0

import "../../core"
import "planegame.js" as Activity

ActivityBase {
    id: activity
    focus: true

    onStart: { focus = true; }
    onStop: { }

    Keys.onPressed: (event) => { Activity.processPressedKey(event) }
    Keys.onReleased:  (event) => { Activity.processReleasedKey(event) }

    property var dataset
    property var tutorialInstructions: ""
    property bool showTutorial: false

    property int oldWidth: width
    onWidthChanged: {
        // Reposition helico and clouds, same for height
        Activity.repositionObjectsOnWidthChanged(width / oldWidth)
        oldWidth = width
    }

    property int oldHeight: height
    onHeightChanged: {
        // Reposition helico and clouds, same for height
        Activity.repositionObjectsOnHeightChanged(height / oldHeight)
        oldHeight = height
    }

    pageComponent: Image {
        id: activityBackground
        anchors.fill: parent
        signal start
        signal stop
        signal voiceDone
        source: Activity.url + "../algorithm/resource/desert_scene.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop

        Component.onCompleted: {
                activity.start.connect(start)
                activity.stop.connect(stop)
        }

        // Needed to get keyboard focus on Tutorial
        Keys.forwardTo: [tutorialSection]

        QtObject {
            id: items
            property Item activityPage: activity
            property alias activityBackground: activityBackground
            property alias bar: bar
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias plane: plane
            property alias fileChecker: fileChecker
            property GCAudio audioVoices: activity.audioVoices
            property alias crashSound: crashSound
            property alias movePlaneTimer: movePlaneTimer
            property alias cloudCreation: cloudCreation
            property bool showTutorial: activity.showTutorial
            property bool goToNextLevel: false
            property alias toolTipText: toolTipText.text
       }

       onVoiceDone: {
           if(items.goToNextLevel) {
               items.goToNextLevel = false;
               items.bonus.good("flower");
           }
        }

        onStart: {
            activity.audioVoices.done.connect(voiceDone)
            Activity.start(items, dataset)
        }
        onStop: { Activity.stop() }

        File {
            id: fileChecker
        }

        GCSoundEffect {
            id: crashSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        // Tutorial section starts
        Image {
            id: tutorialImage
            source: "../digital_electricity/resource/texture01.webp"
            anchors.fill: parent
            fillMode: Image.Tile
            z: 1
            visible: showTutorial
            Tutorial {
                id: tutorialSection
                tutorialDetails: tutorialInstructions
                useImage: false
                onSkipPressed: {
                    showTutorial = false
                    Activity.initLevel()
                }
            }
        }
        // Tutorial section ends

        MultiPointTouchArea {
            anchors.fill: parent
            touchPoints: [ TouchPoint { id: point1 } ]

            onReleased: {
                plane.x = point1.x - plane.width / 2
                plane.y = point1.y - plane.height / 2
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: items.showTutorial ? (help | home) : (help | home | level) }
            onHelpClicked: displayDialog(dialogHelp)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            visible: !showTutorial
            fontSize: activityBackground.width >= activityBackground.height ? internalTextComponent.largeSize : internalTextComponent.mediumSize
            height: internalTextComponent.height + 10
            anchors.bottom: bar.top
            anchors.margins: 10
        }

        property int movePlaneTimerCounter: 0
        Timer {
            id: movePlaneTimer
            running: false
            repeat: true
            onTriggered: {
                plane.state = "play"
                interval = 50
                if(movePlaneTimerCounter++ % 3 == 0) {
                    /* Do not call this too often or plane commands are too hard */
                    Activity.handleCollisionsWithCloud();
                }
                Activity.computeVelocity();
                Activity.planeMove();
            }
        }

        Timer {
            id: cloudCreation
            running: false
            repeat: true
            interval: 10200 - (bar.level * 200)
            onTriggered: Activity.createCloud()
        }

        Plane {
            id: plane
            visible: !showTutorial
        }

        Item {
            id: toolTipArea
            anchors {
                top: parent.top
                topMargin: 5 * ApplicationInfo.ratio
                horizontalCenter: parent.horizontalCenter
            }
            width: Math.min(parent.width - 20 * ApplicationInfo.ratio,
                            200 * ApplicationInfo.ratio)
            height: 40 * ApplicationInfo.ratio
            visible: toolTipText.text != ""

            Rectangle {
                anchors.centerIn: toolTipText
                width: toolTipText.contentWidth + 10 * ApplicationInfo.ratio
                height: toolTipText.contentHeight
                radius: 5 * ApplicationInfo.ratio
                color:"#AAFFFFFF"
            }

            GCText {
                id: toolTipText
                anchors.centerIn: parent
                fontSizeMode: Text.Fit
                fontSize: regularSize
                color: "#373737"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: ""
            }
        }
    }
}
