/* GCompris - Traffic.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import core 1.0

import "../../core"
import "traffic.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: activityBackground
        color: "#64B560"

        signal start
        signal stop

        property string mode: "IMAGE" // allow to choose between "COLOR" and "IMAGE"
        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias goodAnswerSound: goodAnswerSound
            property alias carSound: carSound
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias score: score
            property alias jamBox: jamBox
            property alias jamGridContainer: jamGridContainer
            property bool isVertical: activityBackground.width < activityBackground.height - 64 * ApplicationInfo.ratio
        }

        onStart: { Activity.start(items, mode) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: carSound
            source: Activity.baseUrl + "car.wav"
        }

        Rectangle {
            color: "#9EC282"
            width: jamBox.width * 1.075
            height: width
            radius: width * 0.15
            anchors.centerIn: jamBox
        }
        Rectangle {
            color: "#9EC282"
            width: activityBackground.width * 0.5
            height: jamBox.height * 0.2
            anchors.left: jamBox.horizontalCenter
            anchors.verticalCenter: outsideRoad.verticalCenter
        }
        Rectangle {
            id: outsideRoad
            color: "#444444"
            width: activityBackground.width * 0.5
            height: jamBox.height * 0.125
            anchors.left: jamBox.horizontalCenter
            anchors.bottom: jamBox.verticalCenter
        }

        Image {
            id: jamBox
            source: "qrc:/gcompris/src/activities/traffic/resource/jamBox.svg"
            width: parent.height - 64 * ApplicationInfo.ratio
            height: width
            sourceSize.width: width
            sourceSize.height: height
            anchors.horizontalCenter: activityBackground.horizontalCenter
            states: [
                State {
                    name: "verticalLayout"
                    when: items.isVertical
                    PropertyChanges {
                        jamBox {
                            width: parent.width
                        }
                    }
                    AnchorChanges {
                        target: jamBox
                        anchors.top: undefined
                        anchors.verticalCenter: activityBackground.verticalCenter
                    }
                },
                State {
                    name: "horizontalLayout"
                    when: !items.isVertical
                    PropertyChanges {
                        jamBox {
                            width: parent.height - 64 * ApplicationInfo.ratio
                        }
                    }
                    AnchorChanges {
                        target: jamBox
                        anchors.top: parent.top
                        anchors.verticalCenter: undefined
                    }
                }
            ]

            Item {
                id: jamGridContainer
                anchors.centerIn: parent
                width: parent.width * 0.75
                height: width
                // Add an alias to mode so it can be used on Car items
                property alias mode: activityBackground.mode

                Grid {
                    id: jamGrid
                    anchors.centerIn: parent
                    width: parent.width
                    height: width
                    columns: 6
                    rows: 6
                    spacing: 0

                    Repeater {
                        id: gridRepeater
                        model: jamGrid.columns * jamGrid.rows

                        delegate: Rectangle {
                            id: gridDelegate
                            height: jamGrid.height / jamGrid.rows
                            width: height
                            border.width: Math.max(1, 0.5 * ApplicationInfo.ratio)
                            border.color: "#A2A2A2"
                            color: "transparent"
                        }
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onClose: {
                home()
            }
            onLoadData: {
                if(activityData && activityData["mode"]) {
                   activityBackground.mode = activityData["mode"];
                }
            }
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | reload | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.initLevel()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        Score {
            id: score
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
            onStop: Activity.nextSubLevel()
        }
    }
}
