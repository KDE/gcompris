/* GCompris - Comparator.qml
 *
 * SPDX-FileCopyrightText: 2022 Aastha Chauhan <aastha.chauhan01@gmail.com>
 *
 * Authors:
 *   Aastha Chauhan <aastha.chauhan01@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0
import QtQml.Models 2.12

import "../../core"
import "comparator.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        source: "qrc:/gcompris/src/activities/chess/resource/background-wood.svg"
        anchors.centerIn: parent
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.height: height
        signal start
        signal stop
        property int layoutMargins: ApplicationInfo.ratio * 10

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        function resetSelectedButton() {
            symbolSelectionList.currentIndex = -1;
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            readonly property var levels: activity.datasets
            property alias dataListModel: dataListModel
            property int selectedLine: -1
            property int spacingOfElement: 20 * ApplicationInfo.ratio
            property int sizeOfElement: 36 * ApplicationInfo.ratio
            property int numberOfRowsCompleted: 0
            property alias score: score
            property bool horizontalLayout: layoutArea.width >= layoutArea.height
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
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: bar.top
                bottomMargin: bar.height * 0.5
            }
        }

        ListModel {
            id: dataListModel
        }

        Keys.enabled: !bonus.isPlaying
        Keys.onPressed: (event) => {
            if(items.buttonsBlocked)
                return;
            switch(event.key) {
                case Qt.Key_Less:
                event.accepted = true;
                symbolSelectionList.enterSign("<");
                break;
                case Qt.Key_Equal:
                event.accepted = true;
                symbolSelectionList.enterSign("=");
                break;
                case Qt.Key_Greater:
                event.accepted = true;
                symbolSelectionList.enterSign(">");
                break;
                case Qt.Key_Up:
                event.accepted = true;
                Activity.upAction();
                break;
                case Qt.Key_Down:
                event.accepted = true;
                Activity.downAction();
                break;
                case Qt.Key_Left:
                event.accepted = true;
                symbolSelectionList.decrementCurrentIndex();
                break;
                case Qt.Key_Right:
                event.accepted = true;
                symbolSelectionList.incrementCurrentIndex();
                break;
                case Qt.Key_Space:
                event.accepted = true;
                if(symbolSelectionList.currentItem) {
                    symbolSelectionList.currentItem.clicked();
                }
                break;
                case Qt.Key_Return:
                case Qt.Key_Enter:
                event.accepted = true;
                if(okButton.visible) {
                    okButton.clicked();
                }
                break;
                case Qt.Key_Backspace:
                event.accepted = true;
                var equation = dataListModel.get(items.selectedLine);
                if(equation.symbol != "") {
                    equation.symbol = "";
                    items.numberOfRowsCompleted --;
                    equation.isValidationImageVisible = false;
                }
                break;
            }
        }

        Rectangle {
            id: wholeExerciceDisplay
            // width defined in states
            height: items.sizeOfElement * lineRepeater.count
            anchors.horizontalCenter: layoutArea.horizontalCenter
            anchors.verticalCenter: layoutArea.verticalCenter
            anchors.verticalCenterOffset: -symbolSelectionList.height
            color: "#F2F2F2"
            Column {
                id: wholeExerciceDisplayContent
                spacing: 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: parent.height
                Repeater {
                    id: lineRepeater
                    model: dataListModel
                    delegate: ComparatorLine {
                    }
                }
            }
        }

        Item {
            id: upDownButtonSet
            anchors.verticalCenter: wholeExerciceDisplay.verticalCenter
            anchors.right: wholeExerciceDisplay.left
            anchors.rightMargin: activityBackground.layoutMargins
            height: upButton.width * 3
            width: upButton.width
            BarButton {
                id: upButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                // width defined in states
                rotation: -90
                anchors.top: parent.top
                anchors.right: parent.right
                Rectangle {
                    anchors.fill: parent
                    radius: width * 0.5
                    color: "#FFFFFF"
                    border.color: "#000000"
                    border.width: 4
                    opacity: 0.2
                }
                onClicked: {
                    Activity.upAction()
                }
            }
            BarButton {
                id: downButton
                source: "qrc:/gcompris/src/activities/path_encoding/resource/arrow.svg"
                width: upButton.width
                rotation: 90
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                Rectangle {
                    anchors.fill: parent
                    radius: width * 0.5
                    color: "#FFFFFF"
                    border.color: "#000000"
                    border.width: 4
                    opacity: 0.2
                }
                onClicked: {
                    Activity.downAction()
                }
            }
        }
            
        ListView {
            id: symbolSelectionList
            height: Math.min(wholeExerciceDisplay.width * 0.2, items.sizeOfElement * 1.5)
            width: height * 4
            anchors.top: wholeExerciceDisplay.bottom
            anchors.topMargin: activityBackground.layoutMargins
            anchors.horizontalCenter: wholeExerciceDisplay.horizontalCenter
            orientation: Qt.Horizontal
            interactive: false
            keyNavigationWraps: true
            spacing: height * 0.5
            currentIndex: -1
            model: ["<", "=", ">"]
            delegate: ComparatorSign {
                height: ListView.view.height
                width: height
                signValue: modelData
                isSelected: ListView.isCurrentItem
            }
            function enterSign(sign: string) {
                //increment the numberOfRowsCompleted if there was no symbol previously
                if(dataListModel.get(items.selectedLine).symbol === "") {
                    items.numberOfRowsCompleted ++;
                }
                dataListModel.get(items.selectedLine).symbol = sign;
                dataListModel.get(items.selectedLine).isValidationImageVisible = false;
            }
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            visible: items.numberOfRowsCompleted == dataListModel.count
            width: 60 * ApplicationInfo.ratio
            height: width
            enabled: !bonus.isPlaying
            anchors {
                bottom: score.top
                bottomMargin: activityBackground.layoutMargins
                horizontalCenter: score.horizontalCenter
            }
            onClicked: {
                Activity.checkAnswer()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
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

        Score {
            id: score
            anchors.right: layoutArea.right
            anchors.bottom: layoutArea.bottom
            anchors.rightMargin: activityBackground.layoutMargins
            anchors.bottomMargin: activityBackground.layoutMargins
            anchors.horizontalCenterOffset: layoutArea.width * 0.375
            onStop: Activity.nextSubLevel()
        }

        states: [
            State {
                name: "isHorizontalLayout"
                when: items.horizontalLayout
                AnchorChanges {
                    target: score
                    anchors.right: undefined
                    anchors.horizontalCenter: layoutArea.horizontalCenter
                }
                PropertyChanges {
                    wholeExerciceDisplay {
                        width: layoutArea.width * 0.5
                        anchors.horizontalCenterOffset: -items.sizeOfElement
                    }
                }
                PropertyChanges {
                    upButton {
                        width: Math.max(layoutArea.height * 0.1, items.sizeOfElement)
                    }
                }
            },
            State {
                name: "isVerticalLayout"
                when: !items.horizontalLayout
                AnchorChanges {
                    target: score
                    anchors.right: layoutArea.right
                    anchors.horizontalCenter: undefined
                }
                PropertyChanges {
                    wholeExerciceDisplay {
                        width: layoutArea.width * 0.7
                        anchors.horizontalCenterOffset: 0
                    }
                }
                PropertyChanges {
                    upButton {
                        width: layoutArea.width * 0.1
                    }
                }
            }
        ]

        MouseArea {
            id: inputLock
            anchors.fill: layoutArea
            enabled: items.buttonsBlocked
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
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}
