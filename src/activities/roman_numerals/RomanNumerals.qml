/* GCompris - roman_numerals.qml
 *
 * SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *   Timothée Giet <animtim@gmail.com> (layout refactoring)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import core 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    // When opening a dialog, it steals the focus and re set it to the activity.
    // We need to set it back to the textinput item in order to have key events.
    signal resetFocus
    onFocusChanged: {
        if(focus)
            resetFocus();
    }

    pageComponent: Image {
        id: activityBackground
        source: items.toArabic ?
                    "qrc:/gcompris/src/activities/roman_numerals/resource/arabian-building.svg" :
                    "qrc:/gcompris/src/activities/roman_numerals/resource/roman-building.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: width
        sourceSize.height: height
        signal start
        signal stop
        signal resetFocus

        onResetFocus: {
            if (!ApplicationInfo.isMobile)
                textInput.forceActiveFocus();
        }

        property int layoutMargins: 10 * ApplicationInfo.ratio

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
            activity.resetFocus.connect(resetFocus)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias activityBackground: activityBackground
            property alias bonus: bonus
            property alias score: score
            property alias textInput: textInput

            property bool toArabic: dataset[currentLevel].toArabic
            property string questionText: dataset[currentLevel].question
            property string instruction: dataset[currentLevel].instruction
            property string questionValue

            // we initialize it to -1, so on start() function,
            // it forces a layout refresh when it's set to 0
            property int currentLevel: -1
            property int numberOfLevel: dataset.length
            property bool buttonsBlocked: false

            property var dataset: [
                {
                    values: ['I', 'V', 'X', 'L', 'C', 'D', 'M'],
                    instruction: qsTr("The roman numbers are all built out of these 7 numbers:\nI and V (units, 1 and 5)\nX and L (tens, 10 and 50)\nC and D (hundreds, 100 and 500)\n and M (1000).\n An interesting observation here is that the roman numeric system lacks the number 0."),
                    question: qsTr("Convert the roman number %1 to arabic."),
                    toArabic: true
                },
                {
                    values: [1, 5, 10, 50, 100, 500, 1000],
                    instruction: qsTr("The roman numbers are all built out of these 7 numbers:\nI and V (units, 1 and 5)\nX and L (tens, 10 and 50)\nC and D (hundreds, 100 and 500)\n and M (1000).\n An interesting observation here is that the roman numeric system lacks the number 0."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX'],
                    instruction: qsTr("All the units except 4 and 9 are built using sums of I and V:\nI, II, III, V, VI, VII, VIII.\n The 4 and the 9 units are built using differences:\nIV (5 – 1) and IX (10 – 1)."),
                    question: qsTr("Convert the roman number %1 to arabic."),
                    toArabic: true
                },
                {
                    values: [2, 3, 4, 5, 6, 7, 8, 9],
                    instruction: qsTr("All the units except 4 and 9 are built using sums of I and V:\nI, II, III, V, VI, VII, VIII.\n The 4 and the 9 units are built using differences:\nIV (5 – 1) and IX (10 – 1)."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['XX', 'XXX', 'XL', 'LX', 'LXX', 'LXXX', 'XC'],
                    instruction: qsTr("All the tens except 40 and 90 are built using sums of X and L:\nX, XX, XXX, L, LX, LXX, LXXX.\nThe 40 and the 90 tens are built using differences:\nXL (10 taken from 50) and XC (10 taken from 100)."),
                    question: qsTr("Convert the roman number %1 to arabic."),
                    toArabic: true
                },
                {
                    values: [20, 30, 40, 60, 70, 80, 90],
                    instruction: qsTr("All the tens except 40 and 90 are built using sums of X and L:\nX, XX, XXX, L, LX, LXX, LXXX.\nThe 40 and the 90 tens are built using differences:\nXL (10 taken from 50) and XC (10 taken from 100)."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['CC', 'CCC', 'CD', 'DC', 'DCC', 'DCCC', 'CM', ],
                    instruction: qsTr("All the hundreds except 400 and 900 are built using sums of C and D:\nC, CC, CCC, D, DC, DCC, DCCC.\nThe 400 and the 900 hundreds are built using differences:\nCD (100 taken from 500) and CM (100 taken from 1000)."),
                    question: qsTr("Convert the roman number %1 to arabic."),
                    toArabic: true
                },
                {
                    values: [200, 300, 400, 600, 700, 800, 900],
                    instruction: qsTr("All the hundreds except 400 and 900 are built using sums of C and D:\nC, CC, CCC, D, DC, DCC, DCCC.\nThe 400 and the 900 hundreds are built using differences:\nCD (100 taken from 500) and CM (100 taken from 1000)."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['MM', 'MMM'],
                    instruction: qsTr("Sums of M are used for building thousands: M, MM, MMM.\nNotice that you cannot join more than three identical symbols. The first implication of this rule is that you cannot use just sums for building all possible units, tens or hundreds, you must use differences too. On the other hand, it limits the maximum roman number to 3999 (MMMCMXCIX)."),
                    question: qsTr("Convert the roman number %1 to arabic."),
                    toArabic: true
                },
                {
                    values: [2000, 3000],
                    instruction: qsTr("Sums of M are used for building thousands: M, MM, MMM.\nNotice that you cannot join more than three identical symbols. The first implication of this rule is that you cannot use just sums for building all possible units, tens or hundreds, you must use differences too. On the other hand, it limits the maximum roman number to 3999 (MMMCMXCIX)."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 50 /* up to this number */ , 10 /* sublevels */],
                    instruction: qsTr("Now you know the rules, you can read and write numbers in roman numerals."),
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 100, 10],
                    instruction: '',
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 500, 10],
                    instruction: '',
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                },
                {
                    values: ['_random_', 1000, 10],
                    instruction: '',
                    question: qsTr("Convert the arabic number %1 to roman."),
                    toArabic: false
                }
            ]

            onQuestionValueChanged: {
                textInput.text = ''
                romanConverter.arabic = 0
                if(toArabic)
                    keyboard.populateArabic()
                else
                    keyboard.populateRoman()

            }

            function start() {
                if (!ApplicationInfo.isMobile)
                    textInput.forceActiveFocus();
                items.currentLevel = Core.getInitialLevel(items.numberOfLevel)
                initLevel()
            }

            function initLevel() {
                errorRectangle.resetState()
                score.currentSubLevel = 0
                initSubLevel()
            }

            function initSubLevel() {
                if(dataset[currentLevel].values[0] === '_random_') {
                    questionValue = Math.round(Math.random() * dataset[currentLevel].values[1] + 1)
                    score.numberOfSubLevels = dataset[currentLevel].values[2]
                } else {
                    questionValue = dataset[currentLevel].values[score.currentSubLevel]
                    score.numberOfSubLevels = dataset[currentLevel].values.length
                }
                items.buttonsBlocked = false
            }

            function nextLevel() {
                score.stopWinAnimation()
                currentLevel = Core.getNextLevel(currentLevel, numberOfLevel);
                initLevel();
            }

            function previousLevel() {
                score.stopWinAnimation()
                currentLevel = Core.getPreviousLevel(currentLevel, numberOfLevel);
                initLevel();
            }

            function nextSubLevel() {
                if(score.currentSubLevel >= score.numberOfSubLevels) {
                    bonus.good("tux")
                } else {
                    initSubLevel();
                }
            }

            function check() {
                items.buttonsBlocked = true
                if(feedback.value == items.questionValue) {
                    score.currentSubLevel += 1;
                    score.playWinAnimation();
                    goodAnswerSound.play();
                } else {
                    badAnswerSound.play();
                    errorRectangle.startAnimation()
                }
            }
        }

        onStart: {
            items.start()
        }
        onStop: { }

        Keys.onPressed: (event) => {
            if ((event.key === Qt.Key_Enter) || (event.key === Qt.Key_Return)) {
                if(!items.buttonsBlocked)
                    items.check()
            }
        }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        QtObject {
            id: romanConverter
            property int arabic
            property string roman

            // conversion code copied from:
            // http://blog.stevenlevithan.com/archives/javascript-roman-numeral-converter
            function arabic2Roman(num) {
                if (!+num || num > 3999)
                    return '';
                var digits = String(+num).split(""),
                        key = ["","C","CC","CCC","CD","D","DC","DCC","DCCC","CM",
                               "","X","XX","XXX","XL","L","LX","LXX","LXXX","XC",
                               "","I","II","III","IV","V","VI","VII","VIII","IX"],
                        roman = "",
                        i = 3;
                while (i--)
                    roman = (key[+digits.pop() + (i * 10)] || "") + roman;
                return new Array(+digits.join("") + 1).join("M") + roman;
            }

            function roman2Arabic(str) {
                var	str = str.toUpperCase(),
                        validator = /^M*(?:D?C{0,3}|C[MD])(?:L?X{0,3}|X[CL])(?:V?I{0,3}|I[XV])$/,
                        token = /[MDLV]|C[MD]?|X[CL]?|I[XV]?/g,
                        key = {M:1000,CM:900,D:500,CD:400,C:100,XC:90,L:50,XL:40,X:10,IX:9,V:5,IV:4,I:1},
                num = 0, m;
                if (!(str && validator.test(str)))
                    return false;
                while (m = token.exec(str))
                    num += key[m[0]];
                return num;
            }
            onArabicChanged: roman = arabic2Roman(arabic)
            onRomanChanged: arabic = roman2Arabic(roman)
        }

        Item {
            id: questionArea
            anchors.top: activityBackground.top
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right
            anchors.margins: activityBackground.layoutMargins
            height: questionLabel.contentHeight + 20 * ApplicationInfo.ratio
            Rectangle {
                anchors.centerIn: parent
                width: questionLabel.contentWidth + 2 * activityBackground.layoutMargins
                height: questionLabel.contentHeight + activityBackground.layoutMargins
                color: "#f2f2f2"
                radius: activityBackground.layoutMargins
                border.width: 2 * ApplicationInfo.ratio
                border.color: "#9fb8e3"
                GCText {
                    id: questionLabel
                    anchors.centerIn: parent
                    wrapMode: TextEdit.WordWrap
                    text: items.questionValue ? items.questionText.arg(items.questionValue) : ''
                    color: "#373737"
                    width: questionArea.width - 2 * activityBackground.layoutMargins
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Rectangle {
            id: inputArea
            anchors.top: questionArea.bottom
            anchors.left: activityBackground.left
            anchors.margins: activityBackground.layoutMargins
            color: "#f2f2f2"
            radius: activityBackground.layoutMargins
            width: questionArea.width * 0.5 - activityBackground.layoutMargins * 0.5
            height: textInput.height
            TextInput {
                id: textInput
                x: parent.width / 2
                width: parent.width
                enabled: !items.buttonsBlocked
                color: "#373737"
                text: ''
                maximumLength: items.toArabic ?
                ('' + romanConverter.roman2Arabic(items.questionValue)).length + 1 :
                romanConverter.arabic2Roman(items.questionValue).length + 1
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: questionLabel.pointSize
                font.weight: Font.DemiBold
                font.family: GCSingletonFontLoader.fontName
                font.capitalization: ApplicationSettings.fontCapitalization
                font.letterSpacing: ApplicationSettings.fontLetterSpacing
                cursorVisible: true
                wrapMode: TextInput.Wrap
                validator: RegularExpressionValidator{ regularExpression: items.toArabic ?
                    /[0-9]+/ :
                    /[ivxlcdmIVXLCDM]*/}
                    onTextChanged: if(text) {
                        text = text.toUpperCase();
                        if(items.toArabic)
                            romanConverter.arabic = parseInt(text)
                            else
                                romanConverter.roman = text
                    }

                function appendText(car) {
                    if(car === keyboard.backspace) {
                        if(text && cursorPosition > 0) {
                            var oldPos = cursorPosition
                            text = text.substring(0, cursorPosition - 1) + text.substring(cursorPosition)
                            cursorPosition = oldPos - 1
                        }
                        return
                    }
                    var oldPos = cursorPosition
                    text = text.substring(0, cursorPosition) + car + text.substring(cursorPosition)
                    cursorPosition = oldPos + 1
                }
            }
        }

        Rectangle {
            id: feedbackArea
            anchors.top: questionArea.bottom
            anchors.margins: activityBackground.layoutMargins
            anchors.right: activityBackground.right
            width: inputArea.width
            height: inputArea.height
            color: "#f2f2f2"
            radius: activityBackground.layoutMargins

            GCText {
                id: feedback
                anchors.horizontalCenter: parent.horizontalCenter
                text: items.toArabic ?
                qsTr("Roman value: %1").arg(value) :
                qsTr('Arabic value: %1').arg(value)
                color: "#373737"
                property string value: items.toArabic ?
                romanConverter.roman :
                romanConverter.arabic ? romanConverter.arabic : ''
                verticalAlignment: Text.AlignVCenter
                width: parent.width * 0.9
                height: parent.height * 0.9
                fontSizeMode: Text.Fit
                minimumPointSize: 10
                fontSize: mediumSize
            }
        }

        Item {
            id: instructionArea
            visible: items.instruction != ''
            anchors.top: feedbackArea.bottom
            anchors.bottom: okButton.top
            anchors.left: activityBackground.left
            anchors.right: activityBackground.right
            anchors.margins: activityBackground.layoutMargins

            Rectangle {
                width: instruction.contentWidth + 2 * activityBackground.layoutMargins
                height: instruction.contentHeight + activityBackground.layoutMargins
                anchors.centerIn: parent
                color: "#f2f2f2"
                border.color: "#9fb8e3"
                border.width: 2 * ApplicationInfo.ratio

                GCText {
                    id: instruction
                    wrapMode: TextEdit.WordWrap
                    anchors.centerIn: parent
                    width: instructionArea.width - 2 * activityBackground.layoutMargins
                    height: instructionArea.height - 2 * activityBackground.layoutMargins
                    text: items.instruction
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#373737"
                    fontSizeMode: Text.Fit
                    minimumPointSize: 8
                    fontSize: mediumSize
                }
            }
        }

        ErrorRectangle {
            id: errorRectangle
            anchors.fill: inputArea
            radius: inputArea.radius
            imageSize: height * 2
            function releaseControls() { items.buttonsBlocked = false; }
        }

        Score {
            id: score
            anchors.right: okButton.left
            anchors.verticalCenter: okButton.verticalCenter
            anchors.bottom: undefined
            currentSubLevel: 0
            numberOfSubLevels: 1
            onStop: items.nextSubLevel()
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: visible && !items.buttonsBlocked

            function populateArabic() {
                layout = [ [
                    { label: "0" },
                    { label: "1" },
                    { label: "2" },
                    { label: "3" },
                    { label: "4" },
                    { label: "5" },
                    { label: "6" },
                    { label: "7" },
                    { label: "8" },
                    { label: "9" },
                    { label: keyboard.backspace }
                ] ]
            }

            function populateRoman() {
                layout = [ [
                    { label: "I" },
                    { label: "V" },
                    { label: "X" },
                    { label: "L" },
                    { label: "C" },
                    { label: "D" },
                    { label: "M" },
                    { label: keyboard.backspace }
                ] ]
            }

            onKeypress: textInput.appendText(text)

            onError: (msg) => console.log("VirtualKeyboard error: " + msg);
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level | hint }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: items.previousLevel()
            onNextLevelClicked: items.nextLevel()
            onHomeClicked: activity.home()
            onHintClicked: feedbackArea.visible = !feedbackArea.visible
        }
        BarButton {
          id: okButton
          source: "qrc:/gcompris/src/core/resource/bar_ok.svg";
          visible: true
          anchors.right: activityBackground.right
          anchors.bottom: bar.top
          anchors.margins: 2 * activityBackground.layoutMargins
          enabled: !items.buttonsBlocked
          width: bar.height
          onClicked: items.check()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(items.nextLevel)
        }
    }
}
