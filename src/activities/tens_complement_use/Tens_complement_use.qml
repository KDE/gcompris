/* GCompris - tens_complement_use.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQml.Models
import core 1.0
import "../../core"
import "tens_complement_use.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.height: height
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
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias cardListModel: cardListModel
            property alias holderListModel: holderListModel
            property int selectedIndex: -1
            property alias score: score
            property alias okButton: okButton
            readonly property var levels: activity.datasets
            property double cardSize: Core.fitItems(numberContainerArea.width, numberContainerArea.height, 6)
            property bool isHorizontal: activityBackground.width >= activityBackground.height
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        Item {
            id: layoutArea
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.bottomMargin: bar.height * 0.2
            anchors.left: parent.left
            anchors.right: parent.right
        }

        ListModel {
            id: cardListModel
        }

        Item {
            id: numberContainerArea
            height: width * 0.67
            width: (layoutArea.width - GCStyle.baseMargins * 3) * 0.32
            anchors.left: layoutArea.left
            anchors.verticalCenter: answerHolderArea.verticalCenter
            anchors.leftMargin: GCStyle.baseMargins
        }

        Rectangle {
            id: numberContainer
            width: items.cardSize * 3
            height: items.cardSize * Math.ceil(cardListModel.count / 3)
            anchors.verticalCenter: numberContainerArea.verticalCenter
            anchors.left: numberContainerArea.left
            color: "#80FFFFFF"
            radius: GCStyle.halfMargins

            GridView {
                id: container
                height: parent.height
                width: parent.width
                interactive: false
                anchors.centerIn: parent
                cellHeight: items.cardSize
                cellWidth: items.cardSize
                model: cardListModel
                delegate: NumberQuestionCard {
                    height: items.cardSize
                    width: items.cardSize
                    selected: index == items.selectedIndex
                    onClicked: {
                        items.selectedIndex = index;
                    }
                }
            }
        }

        ListModel {
            id: holderListModel
        }

        Item {
            id: answerHolderArea
            anchors {
                left: numberContainer.right
                top: layoutArea.top
                bottom: score.top
                right: okButton.left
            }

            ListView {
                height: Math.min((items.cardSize * holderListModel.count + GCStyle.baseMargins) * 2 , answerHolderArea.height)
                width: parent.width
                interactive: false
                anchors.centerIn: parent
                model: holderListModel
                delegate: ContainerBox {
                    height: Math.min((items.cardSize + GCStyle.baseMargins) * 2, answerHolderArea.height / 2)
                    width: Math.min(height * 5, ListView.view.width)
                }
            }
        }

        BarButton {
            id: okButton
            visible: false
            z: 10
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            anchors {
                bottom: score.top
                right: layoutArea.right
                margins: GCStyle.baseMargins
            }
            width: GCStyle.bigButtonHeight
            enabled: !items.buttonsBlocked
            onClicked: Activity.checkAnswer()
        }

        Score {
            id: score
            anchors {
                right: undefined
                bottom: layoutArea.bottom
                margins: GCStyle.baseMargins
                horizontalCenter: okButton.horizontalCenter
            }
            onStop: Activity.nextSubLevel()
        }

        states: [
            State {
                name: "horizontalLayout"
                when: items.isHorizontal
                AnchorChanges {
                    target: numberContainerArea
                    anchors {
                        left: numberContainerArea.parent.left
                        verticalCenter: answerHolderArea.verticalCenter
                        horizontalCenter: undefined
                        bottom: undefined
                    }
                }
                PropertyChanges {
                    numberContainerArea {
                        anchors {
                            leftMargin: GCStyle.baseMargins
                            bottomMargin: 0
                        }
                        height: numberContainerArea.width * 0.67
                        width: (layoutArea.width - GCStyle.baseMargins * 3) * 0.32
                    }
                }
                AnchorChanges {
                    target: numberContainer
                    anchors {
                        verticalCenter: numberContainerArea.verticalCenter
                        left: numberContainerArea.left
                        horizontalCenter: undefined
                    }
                }
                AnchorChanges {
                    target: answerHolderArea
                    anchors {
                        left: numberContainer.right
                        top: answerHolderArea.parent.top
                        bottom: score.top
                        right: okButton.left
                    }
                }
            },
            State {
                name: "verticalLayout"
                when: !items.isHorizontal
                AnchorChanges {
                    target: numberContainerArea
                    anchors {
                        left: undefined
                        verticalCenter: undefined
                        horizontalCenter: layoutArea.horizontalCenter
                        bottom: score.top
                    }
                }
                PropertyChanges {
                    numberContainerArea {
                        anchors {
                            leftMargin: 0
                            bottomMargin: GCStyle.baseMargins
                        }
                        width: Math.min(layoutArea.width - okButton.width * 2 - GCStyle.baseMargins * 4,
                                    layoutArea.height * 0.35)
                        height: numberContainerArea.width * 0.67
                    }
                }
                AnchorChanges {
                    target: numberContainer
                    anchors {
                        verticalCenter: numberContainerArea.verticalCenter
                        left: undefined
                        horizontalCenter: numberContainerArea.horizontalCenter
                    }
                }
                AnchorChanges {
                    target: answerHolderArea
                    anchors {
                        left: layoutArea.left
                        top: answerHolderArea.parent.top
                        bottom: numberContainerArea.top
                        right: layoutArea.right
                    }
                }
            }
        ]

        MouseArea {
            id: clickMask
            anchors.fill: layoutArea
            enabled: items.buttonsBlocked
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

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
