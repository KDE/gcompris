/* GCompris - left_right_click.js
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick 2.12 as Quick
.import "../../core/GCompris/core.js" as Core

var items;
var currentLevel = 0;
var numberOfLevel = 3;
var animalCountForBonus = 0;
var cardsToDisplay;
// different number of cards to display per level
var levelDifficulty = [5, 7, 10]
var imgSrc = [
    "qrc:/gcompris/src/activities/left_right_click/resource/fish.svg",
    "qrc:/gcompris/src/activities/left_right_click/resource/monkey.svg"
]
var Position = {
    left: 0,
    right: 1
}

function start(items_) {
    items = items_
    initLevel()
}

function stop() {
}

function initLevel() {
    items.bar.level = currentLevel + 1;
    items.animalListModel.clear();
    var animalArray = new Array();
    cardsToDisplay = levelDifficulty[items.bar.level - 1];
    items.animalCount = (cardsToDisplay / 2) * 3;
    var animalCardLeft = {
        "animalIdentifier": Position.left,
        "leftArea": items.leftArea,
        "rightArea": items.rightArea,
        "animalInvisible": false,
        "imageSource": imgSrc[0]
    }
    var animalCardRight = {
        "animalIdentifier": Position.right,
        "leftArea": items.leftArea,
        "rightArea": items.rightArea,
        "animalInvisible": false,
        "imageSource": imgSrc[1]
    }
    // this is invisible card so giving any value won't be of any use.
    var animalCardInvisible = {
        "animalIdentifier": Position.right,
        "leftArea": items.leftArea,
        "rightArea": items.rightArea,
        "animalInvisible": true,
        "imageSource": imgSrc[1]
    }
    for(var i = 0; i < Math.floor(cardsToDisplay/2); i++) {
        // with every iteration we insert 3 types of cards, invisible card to create a random spacing between the other two cards.
        animalArray.push(animalCardRight);
        animalArray.push(animalCardLeft);
        animalArray.push(animalCardInvisible);
    }
    // more right cards on level 1 than left cards.
    if(items.bar.level === 1) {
        animalArray.push(animalCardLeft);
    }
    // more left cards on level 2 than right cards.
    else if(items.bar.level === 2) {
        animalArray.push(animalCardRight);
    }
    Core.shuffle(animalArray);
    for(var i = 0; i < animalArray.length; i++) {
        items.animalListModel.append(animalArray[i]);
    }
    animalCountForBonus = 0;
}

function nextLevel() {
    if(numberOfLevel <= ++currentLevel) {
        currentLevel = 0;
    }
    initLevel();
}

function previousLevel() {
    if(--currentLevel < 0) {
        currentLevel = numberOfLevel - 1;
    }
    initLevel();
}

function incrementCounter() {
    animalCountForBonus++;
    if(animalCountForBonus % cardsToDisplay === 0) {
        items.bonus.good("lion");
    }
}

function playWrongClickSound() {
    items.audioEffects.play('qrc:/gcompris/src/core/GCompris/resource/sounds/crash.wav')
}
