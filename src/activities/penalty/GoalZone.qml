/* GCompris - GoalZone.qml
*
* SPDX-FileCopyrightText: 2017 Rohit Das <rohit.das950@gmail.com>
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import './penalty.js' as Activity

import "../../core"

Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.top: parent.top
    anchors.topMargin: parent.height * 0.07
    property var progress: undefined
    state: "INITIAL"
    color: "transparent"

    GCSoundEffect {
        id: brickSound
        source: "qrc:/gcompris/src/core/resource/sounds/brick.wav"
    }

    GCSoundEffect {
        id: flipSound
        source: "qrc:/gcompris/src/core/resource/sounds/flip.wav"
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        /* enabled if the current zone has been clicked on or if the ball is at the initial position */
        enabled: items.saveBallState === parent.state || (items.saveBallState === "INITIAL" && ball.x === items.ballX && ball.y === items.ballY)
        onClicked: changeBallState()
    }

    function changeBallState() {
        instruction.text = ""

        if(ball.state === "FAIL") {
            Activity.resetLevel()
            return
        }

        /* This is a shoot */
        if (items.saveBallState === "INITIAL") {
            items.saveBallState = state
        }

        if(progress.ratio > 0) {
            /* Second click, stop animation */
            progress.anim.running = false;

            /* Play sound */
            brickSound.play()

            /* Success or not */
            if(progress.ratio < 100) {
                /* Success */
                ball.state = state
            } else {
                /* failure */
                ball.state = "FAIL"
            }
            timerBonus.start()
        } else {
            /* First click, start animation*/
            progress.anim.running = true;

            /* Play sound */
            flipSound.play()
        }
    }
}
