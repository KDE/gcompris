/* gcompris - SudokuListWidget.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import core 1.0
import "sudoku.js" as Activity
import "../../core"

Item {
    id: listWidget
    width: view.width
    height: view.height
    anchors.top: layoutArea.top
    anchors.left: layoutArea.left

    GCSoundEffect {
        id: scrollSound
        source: "qrc:/gcompris/src/core/resource/sounds/scroll.wav"
    }

    property alias model: mymodel;
    property alias view: view;
    property bool inputBlocked: false

    ListModel {
        id: mymodel
    }

    ListView {
        id: view
        interactive: false
        spacing: GCStyle.halfMargins
        model: mymodel
        delegate: listItemComponent

        property int iconSize

        states: [
            State {
                name: "horizontalLayout"
                when: activityBackground.isHorizontalLayout
                PropertyChanges {
                    view {
                        width: view.iconSize
                        height: layoutArea.height
                        orientation: ListView.Vertical
                        iconSize: Math.min(
                            (height - (mymodel.count - 1) * view.spacing) / mymodel.count,
                            GCStyle.bigButtonHeight)
                    }
                }
            },
            State {
                name: "verticalLayout"
                when: !activityBackground.isHorizontalLayout
                PropertyChanges {
                    view {
                        width: layoutArea.width
                        height: view.iconSize
                        orientation: ListView.Horizontal
                        iconSize: Math.min(
                            (width - (model.count - 1) * view.spacing) / mymodel.count,
                            GCStyle.bigButtonHeight)
                    }
                }
            }
        ]

        Component {
            id: listItemComponent

            Rectangle {
                id: iconBg
                width: view.iconSize
                height: view.iconSize
                color: GCStyle.lightTransparentBg
                radius: GCStyle.halfMargins

                Image {
                    id: icon
                    anchors.fill: parent
                    sourceSize.height: height
                    source: model.imgName === undefined ? "" :
                                            Activity.url + model.imgName
                    z: iAmSelected ? 10 : 1

                    property bool iAmSelected: view.currentIndex == index

                    states: [
                        State {
                            name: "notclicked"
                            when: !icon.iAmSelected && !mouseArea.containsMouse
                            PropertyChanges {
                                icon {
                                    scale: 0.8
                                }
                            }
                        },
                        State {
                            name: "clicked"
                            when: mouseArea.pressed
                            PropertyChanges {
                                icon {
                                    scale: 0.7
                                }
                            }
                        },
                        State {
                            name: "hover"
                            when: mouseArea.containsMouse && !icon.iAmSelected
                            PropertyChanges {
                                icon {
                                    scale: 1
                                }
                            }
                        },
                        State {
                            name: "selected"
                            when: icon.iAmSelected
                            PropertyChanges {
                                icon {
                                    scale: 0.9
                                }
                            }
                        }
                    ]

                    SequentialAnimation {
                        id: anim
                        running: icon.iAmSelected
                        loops: Animation.Infinite
                        alwaysRunToEnd: true
                        NumberAnimation {
                            target: iconBg
                            property: "rotation"
                            from: 0; to: 5
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: iconBg
                            property: "rotation"
                            from: 5; to: -5
                            duration: 400
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: iconBg
                            property: "rotation"
                            from: -5; to: 0
                            duration: 200
                            easing.type: Easing.InQuad
                        }
                    }

                    Behavior on scale { NumberAnimation { duration: 70 } }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: icon
                        hoverEnabled: true
                        enabled: !listWidget.inputBlocked
                        onClicked: {
                            scrollSound.play()
                            view.currentIndex = index
                        }
                    }
                }
            }
        }
    }
}

