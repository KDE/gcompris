/* GCompris - mosaic.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Clement coudoin <clement.coudoin@free.fr> (GTK+ version)
 *   Bruno.coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"
import "mosaic.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: activityBackground
        source: Activity.url + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        signal start
        signal stop

        property bool keyboardMode: false
        property var areaWithKeyboardFocus: selector

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias brushSound: brushSound
            property alias question: question
            property alias answerModel: answerModel
            property alias selector: selector
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property string selectedItem
            readonly property var levels: activity.datasets
            property int nbItems
            property int questionLayoutColumns
            property int questionLayoutRows
            property string modelDisplayLayout
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Keys.enabled: !items.buttonsBlocked
        Keys.onLeftPressed: {
            keyboardMode = true
            areaWithKeyboardFocus.moveCurrentIndexLeft()
        }

        Keys.onRightPressed: {
            keyboardMode = true
            areaWithKeyboardFocus.moveCurrentIndexRight()
        }

        Keys.onUpPressed: {
            keyboardMode = true
            areaWithKeyboardFocus.moveCurrentIndexUp()
        }

        Keys.onDownPressed: {
            keyboardMode = true
            areaWithKeyboardFocus.moveCurrentIndexDown()
        }

        Keys.onEnterPressed: {
            selectCell()
        }

        Keys.onSpacePressed: {
            selectCell()
        }

        Keys.onReturnPressed: {
            selectCell()
        }

        Keys.onTabPressed: {
            keyboardMode = true
            areaWithKeyboardFocus.changeAreaWithKeyboardFocus()
        }

        function selectCell() {
            keyboardMode = true
            areaWithKeyboardFocus.selectCurrentCell(areaWithKeyboardFocus.currentItem)
        }

        GCSoundEffect {
            id: brushSound
            source: "qrc:/gcompris/src/activities/redraw/resource/brush.wav"
        }

        GCSoundEffect {
            id: scrollSound
            source: "qrc:/gcompris/src/core/resource/sounds/scroll.wav"
        }

        Rectangle {
            id: mainArea
            anchors.top: activityBackground.top
            anchors.bottom: bar.top
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right
            color: "#00FFFFFF"

            property int nbItems: 24
            property bool horizontal: activityBackground.width >= activityBackground.height
            property bool smallQuestionMode: items.modelDisplayLayout === "smaller"
            property int nbColumns: items.questionLayoutColumns
            property int nbLines: items.questionLayoutRows
            property int layoutMargin: Math.floor(10 * ApplicationInfo.ratio)
            property int itemsMargin: Math.floor(5 * ApplicationInfo.ratio)

            states: [
                State {
                    name: "horizontal"
                    when: mainArea.horizontal
                    AnchorChanges {
                        target: questionRectangle
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.horizontalCenter: undefined
                    }
                    PropertyChanges {
                        answerRectangle {
                            height: mainArea.height * 0.66 - mainArea.layoutMargin * 2
                            width: mainArea.width * 0.5  - mainArea.layoutMargin * 1.5
                        }
                    }
                    AnchorChanges {
                        target: answerRectangle
                        anchors.top: parent.top
                        anchors.left: questionRectangle.right
                    }
                },
                State {
                    name: "vertical"
                    when: !mainArea.horizontal
                    AnchorChanges {
                        target: questionRectangle
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.horizontalCenter: undefined
                    }
                    PropertyChanges {
                        answerRectangle {
                            height: mainArea.height / 3 - mainArea.layoutMargin * 2
                            width: mainArea.width - mainArea.layoutMargin * 2
                        }
                    }
                    AnchorChanges {
                        target: answerRectangle
                        anchors.top: questionRectangle.bottom
                        anchors.left: parent.left
                    }
                }
            ]

            // === The Question Area ===
            Rectangle {
                id: questionRectangle
                color: "#00FFFFFF"
                height: answerRectangle.height
                width: answerRectangle.width
                anchors.top: mainArea.top
                anchors.left: mainArea.left
                anchors.topMargin: mainArea.layoutMargin
                anchors.leftMargin: mainArea.layoutMargin
                Rectangle {
                    id: questionRectangleContent
                    anchors.centerIn: parent
                    color: "#55333333"
                    border.color: "black"
                    border.width: 2
                    radius: 5

                    states: [
                        State {
                            name: "smallQuestion"
                            when: mainArea.smallQuestionMode
                            PropertyChanges {
                                questionRectangleContent {
                                    height: answerRectangle.height * 0.7
                                    width: answerRectangle.width * 0.7
                                }
                            }
                        },
                        State {
                            name: "normalQuestion"
                            when: !mainArea.smallQuestionMode
                            PropertyChanges {
                                questionRectangleContent {
                                    height: answerRectangle.height
                                    width: answerRectangle.width
                                }
                            }
                        }
                    ]

                    GridView {
                        id: question
                        width: cellWidth * mainArea.nbColumns
                        height: cellHeight * mainArea.nbLines
                        anchors.centerIn: parent
                        cellHeight: cellWidth
                        cellWidth: Math.floor(Math.min((parent.width - mainArea.itemsMargin) / mainArea.nbColumns, (parent.height - mainArea.itemsMargin) / mainArea.nbLines))
                        interactive: false
                        keyNavigationWraps: true
                        delegate: Item {
                            width: question.cellWidth
                            height: question.cellHeight
                            Image {
                                id: imageQuestionId
                                source: Activity.url + modelData
                                fillMode: Image.PreserveAspectFit
                                width: question.cellWidth - mainArea.itemsMargin
                                height: width
                                sourceSize.width: width
                                sourceSize.height: width
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }

            ListModel {
                id: answerModel
            }

            // === The Answer Area ===
            Rectangle {
                id: answerRectangle
                height: mainArea.height * 0.33 - mainArea.layoutMargin * 2
                width: mainArea.width  - mainArea.layoutMargin * 2
                anchors.top: questionRectangle.bottom
                anchors.left: mainArea.left
                anchors.topMargin: mainArea.layoutMargin
                anchors.leftMargin: mainArea.layoutMargin
                color: "#55333333"
                border.color: "black"
                border.width: 2
                radius: 5

                GridView {
                    id: answer
                    model: answerModel
                    width: cellWidth * mainArea.nbColumns
                    height: cellHeight * mainArea.nbLines
                    anchors.centerIn: parent
                    cellHeight: cellWidth
                    cellWidth: Math.floor(Math.min((parent.width - mainArea.itemsMargin) / mainArea.nbColumns, (parent.height - mainArea.itemsMargin) / mainArea.nbLines))
                    interactive: false
                    keyNavigationWraps: true
                    highlightFollowsCurrentItem: true
                    highlight: Rectangle {
                        color: "red"
                        border.width: 3
                        border.color: "black"
                        opacity: 0.6
                        visible: activityBackground.keyboardMode && (activityBackground.areaWithKeyboardFocus === answer)
                    }

                    // If the image was directly used as a delegate (without containing it in the item), the highlight element would have been be hard to notice as it would get completely hidden by the image due to the same sizes.
                    delegate: Item {
                        id: cellItem
                        width: answer.cellWidth
                        height: answer.cellHeight

                        readonly property int cellIndex: index

                        Image {
                            id: imageAnswerId
                            source: Activity.url + imgUrl
                            fillMode: Image.PreserveAspectFit
                            width: answer.cellWidth - mainArea.itemsMargin
                            height: width
                            sourceSize.width: width
                            sourceSize.height: height
                            anchors.centerIn: parent

                            MouseArea {
                                anchors.fill: parent
                                enabled: !items.buttonsBlocked
                                onClicked: answer.selectCurrentCell(cellItem)
                            }
                        }
                    }
                    function selectCurrentCell(selectedCell) {
                        Activity.answerSelected(selectedCell.cellIndex)
                    }

                    function changeAreaWithKeyboardFocus() {
                        areaWithKeyboardFocus = selector
                    }
                }
            }

            // === The Selector ===
            Rectangle {
                id: selectorRectangle
                height: mainArea.height * 0.33 - mainArea.layoutMargin * 2
                width: mainArea.width - mainArea.layoutMargin * 2
                anchors.top: answerRectangle.bottom
                anchors.left: mainArea.left
                anchors.topMargin: mainArea.layoutMargin
                anchors.leftMargin: mainArea.layoutMargin
                color: "#661111AA"
                border.color: "black"
                border.width: 2
                radius: 5
                property int selectorItemSize: Core.fitItems(selectorRectangle.width - mainArea.itemsMargin, selectorRectangle.height - mainArea.itemsMargin, selector.count)

                GridView {
                    id: selector
                    width: parent.width
                    height: parent.height
                    anchors.top: parent.top
                    anchors.topMargin: (height - contentItem.childrenRect.height) * 0.5
                    anchors.left: parent.left
                    anchors.leftMargin: (width - contentItem.childrenRect.width) * 0.5
                    cellHeight: selectorRectangle.selectorItemSize
                    cellWidth: selectorRectangle.selectorItemSize
                    interactive: false
                    keyNavigationWraps: true
                    highlightFollowsCurrentItem: true
                    highlight: Rectangle {
                        color: "red"
                        border.width: 3
                        border.color: "black"
                        opacity: 0.6
                        visible: activityBackground.keyboardMode && (activityBackground.areaWithKeyboardFocus === selector)
                    }
                    delegate: Item {
                        id: selectorItem
                        width: selector.cellWidth
                        height: width
                        Image {
                            id: imageId
                            source: Activity.url + modelData
                            fillMode: Image.PreserveAspectFit
                            width: selector.cellWidth - mainArea.itemsMargin
                            height: width
                            sourceSize.width: width
                            sourceSize.height: height
                            antialiasing: true
                            anchors.centerIn: parent
                            z: selectorItem.iAmSelected ? 10 : 1
                        }

                        readonly property bool iAmSelected: items.selectedItem === modelData
                        readonly property string imageName: modelData

                        states: [
                            State {
                                name: "notclicked"
                                when: !selectorItem.iAmSelected && !mouseArea.containsMouse
                                PropertyChanges {
                                    imageId {
                                        scale: 0.8
                                    }
                                }
                            },
                            State {
                                name: "clicked"
                                when: mouseArea.pressed
                                PropertyChanges {
                                    imageId {
                                        scale: 0.7
                                    }
                                }
                            },
                            State {
                                name: "hover"
                                when: mouseArea.containsMouse
                                PropertyChanges {
                                    imageId {
                                        scale: 1
                                    }
                                }
                            },
                            State {
                                name: "selected"
                                when: selectorItem.iAmSelected
                                PropertyChanges {
                                    imageId {
                                        scale: 1
                                    }
                                }
                            }
                        ]

                        SequentialAnimation {
                            id: anim
                            running: selectorItem.iAmSelected
                            loops: Animation.Infinite
                            alwaysRunToEnd: true
                            NumberAnimation {
                                target: imageId
                                property: "rotation"
                                from: 0; to: 10
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                            NumberAnimation {
                                target: imageId
                                property: "rotation"
                                from: 10; to: -10
                                duration: 400
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                target: imageId
                                property: "rotation"
                                from: -10; to: 0
                                duration: 200
                                easing.type: Easing.InQuad
                            }
                        }

                        Behavior on scale { NumberAnimation { duration: 70 } }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: imageId
                            hoverEnabled: true
                            enabled: !items.buttonsBlocked
                            onClicked: selector.selectCurrentCell(parent)
                        }
                    }

                    function selectCurrentCell(selectedCell) {
                        scrollSound.play()
                        items.selectedItem = selectedCell.imageName
                    }

                    function changeAreaWithKeyboardFocus() {
                        areaWithKeyboardFocus = answer
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
            content: BarEnumContent { value: help | home | level | activityConfig}
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
    }
}
