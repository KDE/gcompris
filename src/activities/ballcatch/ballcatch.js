/*
 gcompris - ballcatch.js

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 SPDX-License-Identifier: GPL-3.0-or-later
*/

.pragma library
.import GCompris 1.0 as GCompris //for ApplicationInfo

var levelProperties = [
            {
                "timerInc": 900,
                "backgroundImage": 1
            },
            {
                "timerInc": 350,
                "backgroundImage": 1
            },
            {
                "timerInc": 300,
                "backgroundImage": 2
            },
            {
                "timerInc": 200,
                "backgroundImage": 2
            },
            {
                "timerInc": 150,
                "backgroundImage": 3
            },
            {
                "timerInc": 100,
                "backgroundImage": 3
            },
            {
                "timerInc": 60,
                "backgroundImage": 4
            },
            {
                "timerInc": 30,
                "backgroundImage": 4
            },
            {
                "timerInc": 15,
                "backgroundImage": 4
            },
        ]

var gameWon = false

// When the timer is finished we set this variable to true to disabled key press
var gameFinished = false

// Store the time diff between left and right key
var timerDiff = 0
// The child has to press both key between this laps of time
var timerinc = 900

var currentLevel = 0

var items

function start(items_) {
    items = items_
    currentLevel = 0

    initLevel()

}

function stop() {
    items.deltaPressedTimer.stop();
}

function leftShiftPressed() {
    if(!items.deltaPressedTimer.running && !items.rightPressed) {
        items.leftHand.animate(timerinc)
        items.deltaPressedTimer.start()
    }

    if(items.rightPressed) {
        items.leftHand.animate(timerinc)
        items.background.playSound("smudge")
    }
}

function rightShiftPressed() {
    if(!items.deltaPressedTimer.running && !items.leftPressed) {
        items.deltaPressedTimer.start()
        items.rightHand.animate(timerinc)
    }
    if(items.leftPressed) {
        items.rightHand.animate(timerinc)
        items.background.playSound("smudge")
    }
}

function endTimer() {
    gameFinished = true
    gameWon = items.rightPressed && items.leftPressed
}

function initLevel() {
    items.bar.level = currentLevel + 1
    timerinc = levelProperties[currentLevel].timerInc

    timerDiff = 0
    items.deltaPressedTimer.stop();
    items.deltaPressedTimer.interval = timerinc

    items.background.source = "qrc:/gcompris/src/activities/ballcatch/resource/beach" +
            levelProperties[currentLevel].backgroundImage + ".svg"

    items.ball.stop();
    items.ball.reinitBall();

    items.leftPressed = false
    items.rightPressed = false

    gameWon = false
    gameFinished = false

    items.leftHand.reinitPosition()
    items.rightHand.reinitPosition()
}

function nextLevel() {
    if(levelProperties.length <= ++ currentLevel) {
        currentLevel = 0
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = levelProperties.length - 1
    }
    initLevel();
}

function restartLevel() {
    initLevel();
}

function processKey(event) {
    if(!gameFinished) {
        if(event.key === Qt.Key_Left) {
            // left
            if(!items.leftPressed) {
                leftShiftPressed();
                items.leftPressed = true
            }
        }
        else if(event.key === Qt.Key_Right) {
            // right
            if(!items.rightPressed) {
                rightShiftPressed();
                items.rightPressed = true
            }
        }
    }
    event.accepted = true;
}
