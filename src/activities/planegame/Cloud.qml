/* gcompris - Cloud.qml

 SPDX-FileCopyrightText: 2014 Johnny Jazeix <jazeix@gmail.com>

 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick
import "planegame.js" as Activity
import "../../core"
import core 1.0

Image {
    id: cloud
    property Item cloudBackground
    property alias text: number.text
    property double heightRatio: 1

    /* An helper property to remember if a cloud has been wrongly touched */
    property bool touched: false

    height: 60 * ApplicationInfo.ratio * heightRatio
    sourceSize.height: height

    state: "normal"
    fillMode: Image.PreserveAspectFit

    z: 5

    signal done
    signal touch

    onDone: {
        particles.burst(50)
        opacityTimer.start()
    }

    onTouch: {
        touched = true
        state = "storm"
    }

    GCText {
        id: number
        anchors.centerIn: parent
        color: GCStyle.darkText
        font.bold: true
        fontSize: 18
    }

    Component.onCompleted: {
        x = -cloud.width - 1
        y = Activity.getRandomInt(0, cloudBackground.height - (cloud.height + Activity.items.bar.height))
    }

    Behavior on x { PropertyAnimation { duration: 20000 } }
    Behavior on opacity { PropertyAnimation { duration: 400 } }

    Timer {
        id: stormy
        interval: 2000
        running: false
        repeat: false
        onTriggered: cloud.state = "normal"
    }

    states: [
        State {
            name: "normal"
            PropertyChanges {
                cloud {
                    source: Activity.url + "resource/cloud.svg"
                }
            }
        },
        State {
            name: "storm"
            PropertyChanges {
                cloud {
                    source: Activity.url + "resource/cloud_storm.svg"
                }
            }
            StateChangeScript {
                script: stormy.start()
            }
        }
    ]

    Timer {
        id: opacityTimer
        running: false
        repeat: false
        interval: 500
        onTriggered: cloud.opacity = 0
    }

    ParticleSystemStarLoader {
        id: particles
        anchors.fill: parent
        clip: false
    }

}
