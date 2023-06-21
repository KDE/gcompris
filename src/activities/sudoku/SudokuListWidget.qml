/* gcompris - SudokuListWidget.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.12
import GCompris 1.0
import "sudoku.js" as Activity
import "../../core"

Item {
    id: listWidget
    width: view.width
    height: view.height
    anchors {
        left: parent.left
        leftMargin: 10 * ApplicationInfo.ratio
        top: parent.top
        topMargin: 10 * ApplicationInfo.ratio
    }

    property alias model: mymodel;
    property alias view: view;
    property GCSfx audioEffects

    ListModel {
        id: mymodel
    }

    ListView {
        id: view
        width: Math.min(64 * ApplicationInfo.ratio, background.width * 0.12)
        height: background.height - 2 * bar.height
        interactive: false
        spacing: 5 * ApplicationInfo.ratio
        model: mymodel
        delegate: contactsDelegate

        property int iconSize: Math.min((height - mymodel.count * spacing) /
                                        mymodel.count,
                                        view.width * 0.95)

        Component {
            id: contactsDelegate

            Rectangle {
                id: iconBg
                width: view.iconSize
                height: view.iconSize
                color: "#AAFFFFFF"
                radius: height * 0.1

                Image {
                    id: icon
                    anchors.centerIn: parent
                    sourceSize.height: view.iconSize
                    source: model.imgName === undefined ? "" :
                                                          Activity.url + model.imgName
                    z: iAmSelected ? 10 : 1

                    property bool iAmSelected: view.currentIndex == index

                    states: [
                        State {
                            name: "notclicked"
                            when: !icon.iAmSelected && !mouseArea.containsMouse
                            PropertyChanges {
                                target: icon
                                scale: 0.8
                            }
                        },
                        State {
                            name: "clicked"
                            when: mouseArea.pressed
                            PropertyChanges {
                                target: icon
                                scale: 0.7
                            }
                        },
                        State {
                            name: "hover"
                            when: mouseArea.containsMouse && !icon.iAmSelected
                            PropertyChanges {
                                target: icon
                                scale: 1
                            }
                        },
                        State {
                            name: "selected"
                            when: icon.iAmSelected
                            PropertyChanges {
                                target: icon
                                scale: 0.9
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
                        onClicked: {
                            listWidget.audioEffects.play('qrc:/gcompris/src/core/resource/sounds/scroll.wav')
                            view.currentIndex = index
                        }
                    }
                }
            }
        }
    }
}

