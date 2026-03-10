/* GCompris - keyboard_training.js
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 */
.pragma library
.import QtQuick as Quick
.import core 1.0 as GCompris //for ApplicationInfo
.import "qrc:/gcompris/src/core/core.js" as Core

var items
var levelData; // array to store level letters

function start(items_) {
    items = items_;
    items.inputLocked = true;

    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale);

    // register the voices for the locale
    GCompris.DownloadManager.updateResource(GCompris.GCompris.VOICES, {"locale": locale})

    if(!items.levels) {
        items.wordlist.loadFromFile(GCompris.ApplicationInfo.getLocaleFilePath(
            items.dataSetUrl + "default-"+locale+".json"));
    } else {
        items.wordlist.loadFromJSON(items.levels);
    }
    // If wordlist is empty, we try to load from short locale and if not present again, we switch to default one
    var localeUnderscoreIndex = locale.indexOf('_')
    // probably exist a better way to see if the list is empty
    if(items.wordlist.maxLevel == 0) {
        var localeShort;
        // We will first look again for locale xx (without _XX if exist)
        if(localeUnderscoreIndex > 0) {
            localeShort = locale.substring(0, localeUnderscoreIndex);
        }
        else {
            localeShort = locale;
        }
        // If not found, we will use the default file
        items.wordlist.useDefault = true;
        if(!items.levels) {
            items.wordlist.loadFromFile(GCompris.ApplicationInfo.getLocaleFilePath(
                items.dataSetUrl + "default-"+localeShort+".json"));
        } else {
            items.wordlist.loadFromJSON(items.levels);
        }
        // We remove the using of default file for next time we enter this function
        items.wordlist.useDefault = false;
    }
    items.numberOfLevel = items.wordlist.maxLevel;

    // Make sure items.numberOfLevel is initialized before calling Core.getInitialLevel
    items.currentLevel = Core.getInitialLevel(items.numberOfLevel);
    initLevel();
}

function stop() {
}

function initLevel() {
    items.score.currentSubLevel = 0;
    items.errorRectangle.resetState();
    items.subLevelCompleted = false;

    var level = items.wordlist.getLevelWordList(items.currentLevel + 1);
    levelData = level.words;
    items.score.numberOfSubLevels = levelData.length;
    items.wordlist.initRandomWord(items.currentLevel + 1);
    populateKeyboard();
    initSubLevel();
}

function initSubLevel() {
    items.questionText = toCaseSetting(items.wordlist.getRandomWord());
    items.client.startTiming();
    items.inputLocked = false;
}

function toCaseSetting(letter_) {
    if(items.uppercaseMode) {
        return letter_.toLocaleUpperCase();
    } else {
        return letter_.toLocaleLowerCase();
    }
}

function populateKeyboard() {
    /* populate VirtualKeyboard for mobile:
        * 1. for < 10 letters print them all in the same row
        * 2. for > 10 letters create 3 rows with equal amount of keys per row
        *    if possible, otherwise more keys in the upper rows
    */
    // first generate a map of needed letters
    var letters = new Array();
    items.keyboard.shiftKey = false;
    for (var i = 0; i < levelData.length; i++) {
        // The word is a letter, even if it has several chars (digraph)
        var letter = toCaseSetting(levelData[i]);
        letters.push(letter);
    }
    letters = GCompris.ApplicationInfo.localeSort(letters, items.locale);
    // generate layout from letter map
    var layout = new Array();
    var row = 0;
    var offset = 0;
    while (offset < letters.length) {
        var cols = letters.length <= 10 ? letters.length : (Math.ceil((letters.length-offset) / (3 - row)));
        layout[row] = new Array();
        for (var j = 0; j < cols; j++) {
            layout[row][j] = { label: letters[j+offset] };
        }
        offset += j;
        row++;
    }
    items.keyboard.layout = layout;
}

function processKeyPress(text) {
    if(items.inputLocked) {
        return;
    }
    items.inputLocked = true;

    items.answerText = toCaseSetting(text);

    if(items.answerText != items.questionText) {
        items.client.sendToServer(false);
        items.errorRectangle.startAnimation();
        items.badAnswerSound.play();
    } else {
        items.client.sendToServer(true);
        items.particle.burst(30)
        playLetter(text);
        items.score.currentSubLevel += 1;
        items.score.playWinAnimation();
        items.subLevelCompleted = true;
    }

    focusTextInput();
}

function playLetter(letter) {
    var locale = GCompris.ApplicationInfo.getVoicesLocale(items.locale);
    items.audioVoices.stop();
    items.audioVoices.append(GCompris.ApplicationInfo.getAudioFilePath("voices-$CA/"+locale+"/alphabet/"
    + Core.getSoundFilenamForChar(letter)));
}

function nextSubLevel() {
    if(items.score.currentSubLevel === items.score.numberOfSubLevels) {
        items.questionText = "";
        items.bonus.good("flower");
    } else {
        initSubLevel();
    }
}

function nextLevel() {
    items.currentLevel = Core.getNextLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function previousLevel() {
    items.currentLevel = Core.getPreviousLevel(items.currentLevel, items.numberOfLevel);
    initLevel();
}

function focusTextInput() {
    if (!GCompris.ApplicationInfo.isMobile && items && items.textinput)
        items.textinput.forceActiveFocus();
}
