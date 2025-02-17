/* GCompris - guess24.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr> (Qt Quick native)
 *   Timothée Giet <animtim@gmail.com> (Graphics and layout refactoring)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * References :
 *  https://www.4nums.com/game/difficulties/
 *  https://www.4nums.com/solutions/allsolvables/   (2023-07-08 datas)
 *  https://fr.y8.com/games/make_24
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "guess24.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        signal start
        signal stop

        property int baseMargins: 5 * ApplicationInfo.ratio
        property int baseRadius: 2 * ApplicationInfo.ratio
        property string baseColor: "#A1CBD9"
        property string selectionColor: "#4B9BB5"
        property int selectionWidth: 4 * ApplicationInfo.ratio

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
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias errorRectangle: errorRectangle
            property var levels: activity.datasets
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property alias bleepSound: bleepSound
            property alias smudgeSound: smudgeSound
            property alias jsonParser: jsonParser
            property int currentValue: 0
            property int currentOperator: -1
            property int operatorsCount: 4
            property int subLevelCount: 0
            property bool keysOnValues: true    // True when focus is on values false if focus is on operators
            property alias cardsModel: cardsModel
            property alias cardsBoard: cardsBoard
            property alias operators: operators
            property alias cancelButton: cancelButton
            property alias hintButton: hintButton
            property alias animationCard: animationCard
            property alias steps: steps
            property alias solution: solution
            property alias solutionRect: solutionRect
            property alias animSol: animSol
            property bool keyboardNavigation: false
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        JsonParser { id: jsonParser }


        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        GCSoundEffect {
            id: bleepSound
            source: "qrc:/gcompris/src/core/resource/sounds/bleep.wav"
        }

        GCSoundEffect {
            id: smudgeSound
            source: "qrc:/gcompris/src/core/resource/sounds/smudge.wav"
        }

        ListModel {
            id: cardsModel
            function randPosition(): real { return (Math.floor(Math.random() * count)) }                                // choose a random position
            function shuffleModel() { for (var i = 0 ; i < count; i++) { move(randPosition(), randPosition(), 1) } }    // shuffle elements
        }

        Rectangle {
            id: captionBg
            width: caption.contentWidth + activityBackground.baseMargins * 2
            height: caption.contentHeight + activityBackground.baseMargins
            color: "#80FFFFFF"
            radius: activityBackground.baseRadius
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: activityBackground.baseMargins
            GCText {
                id: caption
                width: activityBackground.width - activityBackground.baseMargins * 4
                anchors.centerIn: captionBg
                text: qsTr("Use the four numbers with given operators to find 24.")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            MouseArea {
                anchors.fill: parent
                onClicked: captionBg.opacity = 0.0
            }
        }

        Item {
            id: layoutArea
            anchors.top: captionBg.bottom
            anchors.bottom: score.top
            anchors.horizontalCenter: activityBackground.horizontalCenter
            anchors.margins: activityBackground.baseMargins
            width: Math.min(activityBackground.width - 2 * activityBackground.baseMargins,
                                400 * ApplicationInfo.ratio)
        }
        // Main section
        Rectangle {     // Values
            id: valuesArea
            anchors.top: layoutArea.top
            anchors.left: layoutArea.left
            width: layoutArea.width * 0.66
            height: Math.min(250 * ApplicationInfo.ratio, layoutArea.height * 0.75)
            color: "#80FFFFFF"
            radius: activityBackground.baseRadius
            GridView {
                id: cardsBoard
                anchors.fill: parent
                cellWidth: (parent.width - activityBackground.baseMargins) * 0.5
                cellHeight: (parent.height - activityBackground.baseMargins) * 0.5
                highlightFollowsCurrentItem: false
                boundsBehavior: Flickable.StopAtBounds
                maximumFlickVelocity: activity.height
                model: cardsModel
                delegate: Item {   // Display a card with a number inside
                    id: cardNumber
                    property int value: value_
                    width: cardsBoard.cellWidth
                    height: cardsBoard.cellHeight
                    Rectangle {
                        id: cardRect
                        width: parent.width - activityBackground.baseMargins
                        height: parent.height - activityBackground.baseMargins
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: activityBackground.baseMargins
                        visible: true
                        color: (items.currentValue === index) ? activityBackground.baseColor :  "#F0F0F0"
                        border.width: (items.keyboardNavigation && items.keysOnValues && (cardsBoard.currentIndex === index)) ? activityBackground.selectionWidth : ApplicationInfo.ratio
                        border.color: (items.keyboardNavigation && items.keysOnValues && (cardsBoard.currentIndex === index)) ? activityBackground.selectionColor : activityBackground.baseColor
                        radius: activityBackground.baseMargins
                        GCText {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            fontSize: hugeSize
                            fontSizeMode: Text.Fit
                            text: value
                        }
                        MouseArea {
                            id: boardArea
                            anchors.fill: parent
                            enabled: animationCard.state === "" && !items.buttonsBlocked
                            onClicked: Activity.valueClicked(index)
                        }
                    }
                }
            }

            ErrorRectangle {
                id: errorRectangle
                anchors.fill: valuesArea
                radius: valuesArea.radius
                imageSize: Math.min(width, height) * 0.5
                function releaseControls() { items.buttonsBlocked = false; }
            }

            Item {     // Animation card visible during animations
                id: animationCard
                property string value: ""
                property string action: Activity.animActions[0]
                width: cardsBoard.cellWidth
                height: cardsBoard.cellHeight
                visible: false
                Rectangle {
                    id: animationCardBg
                    width: parent.width - activityBackground.baseMargins
                    height: parent.height - activityBackground.baseMargins
                    color: activityBackground.baseColor
                    radius: activityBackground.baseMargins
                    border.color: activityBackground.baseColor
                    border.width: activityBackground.selectionWidth
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: activityBackground.baseMargins
                }
                GCText {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSize: hugeSize
                    fontSizeMode: Text.Fit
                    text: animationCard.value
                }
                states: [
                    State {
                        name: "moveto"
                        PropertyChanges {
                            animationCard {
                                visible: true
                                x: items.cardsBoard.currentItem.x
                                y: items.cardsBoard.currentItem.y
                            }
                        }
                    },
                    State {
                        name: "wait"
                        PropertyChanges {
                            animationCard {
                                visible: true
                            }
                        }
                        PropertyChanges {
                            animationCardBg {
                                color: "tomato"
                                border.color: "tomato"
                            }
                        }
                    }
                ]
                transitions: [
                    Transition {
                        to: "moveto"
                        SequentialAnimation {
                            alwaysRunToEnd: true
                            NumberAnimation { properties: "x,y"; duration: 300 }
                            ScriptAction {
                                script: {
                                    animationCard.state = ""
                                    if (animationCard.action === "forward")
                                        Activity.checkResult()
                                    else if (animationCard.action === "backward")
                                        Activity.endPopOperation()
                                }
                            }
                        }
                    },
                    Transition {
                        to: "wait"
                        SequentialAnimation {
                            alwaysRunToEnd: true
                            PauseAnimation { duration: 800 }
                            ScriptAction { script: { badAnswerSound.play() }}
                            PauseAnimation { duration: 800 }
                            ScriptAction { script: { Activity.popOperation() }}
                        }
                    }
                ]
            }
        }

        Rectangle {     // Operators
            id: operatorsArea
            anchors.top: valuesArea.bottom
            anchors.topMargin: activityBackground.baseMargins
            anchors.left: valuesArea.left
            anchors.right: valuesArea.right
            height: Math.min(layoutArea.height - valuesArea.height - activityBackground.baseMargins,
                             80 * ApplicationInfo.ratio)
            radius: activityBackground.baseRadius
            color: "#80FFFFFF"
            enabled: ((items.currentValue !== -1) && (animationCard.state === ""))
            ListView {
                id: operators
                anchors.fill: parent
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.StopAtBounds
                model: [ "+", "−", "×", "÷" ]
                delegate: Item {
                    width: (operatorsArea.width - activityBackground.baseMargins) * 0.25
                    height: operatorsArea.height
                    Rectangle {     // Display an operator button
                        id: opRect
                        width: parent.width - activityBackground.baseMargins
                        height: parent.height - activityBackground.baseMargins * 2
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: activityBackground.baseMargins
                        visible: index < items.operatorsCount
                        color: (items.currentOperator === index) ? activityBackground.baseColor : "#F0F0F0"
                        opacity: (items.currentValue !== -1) ? 1.0 : 0.5
                        border.width: (items.keyboardNavigation && !items.keysOnValues && (operators.currentIndex === index) && (items.currentValue !== -1)) ? activityBackground.selectionWidth : ApplicationInfo.ratio
                        border.color: (items.keyboardNavigation && !items.keysOnValues && (operators.currentIndex === index) && (items.currentValue !== -1)) ? activityBackground.selectionColor : activityBackground.baseColor
                        radius: activityBackground.baseMargins
                        GCText {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: operators.model[index]
                            fontSize: hugeSize
                            fontSizeMode: Text.Fit
                        }
                        MouseArea {
                            id: opArea
                            anchors.fill: parent
                            enabled: !items.buttonsBlocked
                            onClicked: Activity.operatorClicked(index)
                        }
                    }
                }
            }
        }

        Rectangle {
            id: stepsRect
            width: layoutArea.width - valuesArea.width - activityBackground.baseMargins
            height: Math.min(80 * ApplicationInfo.ratio,
                             (layoutArea.height - activityBackground.baseMargins) * 0.5)
            anchors.top: layoutArea.top
            anchors.right: layoutArea.right
            color: "#F0F0F0"
            radius: activityBackground.baseRadius
            GCText {
                id: steps
                anchors.fill: parent
                anchors.leftMargin: activityBackground.baseMargins
                fontSize: tinySize
                text: ""
            }
        }

        Rectangle {
            id: solutionRect
            width: stepsRect.width
            height: stepsRect.height
            color: "#F0F0F0"
            radius: activityBackground.baseRadius
            anchors.top: stepsRect.bottom
            anchors.topMargin: activityBackground.baseMargins
            anchors.right: layoutArea.right
            opacity: 0.0
            GCText {
                id: solution
                anchors.fill: parent
                anchors.leftMargin: activityBackground.baseMargins
                fontSize: tinySize
                opacity: 0.5
                text: ""
            }
            NumberAnimation on opacity {
                id: animSol
                property bool firstTime: true
                alwaysRunToEnd: true
                to: 0.0
                duration: 1000
                onStarted: cancelButton.visible = false
                onStopped: {
                    if (!firstTime) {   // animation is triggered on activity start
                        Activity.unstack = true
                        Activity.popOperation()
                    }
                    firstTime = false
                    cardsBoard.enabled = true
                    operators.enabled = true
                }
            }
        }

        Image {
            id: cancelButton
            source: "qrc:/gcompris/src/activities/chess/resource/undo.svg"
            height: score.height
            width: height
            sourceSize.width: width
            sourceSize.height: height
            anchors.top: operatorsArea.bottom
            anchors.topMargin: activityBackground.baseMargins
            anchors.left: operatorsArea.left
            enabled: animationCard.state === ""
            MouseArea {
                anchors.fill: parent
                enabled: !items.buttonsBlocked
                onClicked: {
                    if (solutionRect.opacity !== 0.0) {
                        animSol.start()
                    } else {
                        animSol.stop()
                        Activity.unstack = false
                        Activity.popOperation()
                    }
                }
            }
        }

        Image {
            id: hintButton
            source: "qrc:/gcompris/src/core/resource/bar_hint.svg"
            height: score.height
            width: height
            sourceSize.width: width
            sourceSize.height: height
            anchors.right: operatorsArea.right
            anchors.top: operatorsArea.bottom
            anchors.topMargin: activityBackground.baseMargins
            enabled: animationCard.state === ""
            MouseArea {
                anchors.fill: parent
                enabled: !items.buttonsBlocked
                onClicked: {
                    if (Activity.helpCount < 4)
                        Activity.helpCount++
                        solution.text = Activity.splittedSolution.slice(0, Activity.helpCount).join("\n")
                        solutionRect.opacity = 1.0
                        cardsBoard.enabled = false
                        operators.enabled = false
                        hintButton.visible = false
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

        Score {
            id: score
            numberOfSubLevels: items.subLevelCount
            currentSubLevel: 0
            anchors.top: undefined
            anchors.right: activityBackground.right
            anchors.rightMargin: activityBackground.baseMargins
            anchors.left: undefined
            anchors.bottom: activityBackground.bottom
            anchors.bottomMargin: bar.height * 1.5
            onStop: Activity.nextSubLevel()
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

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Keys.onPressed: (event) => { Activity.handleKeys(event) }
    }
}
