/* GCompris - NumPad.qml
 *
 * SPDX-FileCopyrightText: 2014 Aruna Sankaranarayanan <arunasank@src.gnome.org>
 *
 * Authors:
 *   Aruna Sankaranarayanan <arunasank@src.gnome.org>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

/**
* A QML component providing an on screen numpad.
*
* Numpad displays integers from 0 to 9 that can be used
* in applications that need numerical inputs from the user.
* By default it shows integer 0 - 4 in a column on left and
* integers 5 - 9 on right in a column.
* It also contains the backspace button to remove the last input value.
* It is also only displayed when the "virtual keyboard" is enabled in the options.
*
* @inherit QtQuick.Item
*/
Item {
    id: containerPanel
    anchors.top: parent.top
    anchors.bottom: bar.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottomMargin: bar.height * 0.2

    /**
     * type:list
     *
     * Default keys-rectangle color used unless the user provides another.
     */
    property var colours: ["#ec8748", "#eceb48", "#7fec48", "#48d3ec","#ee5f5f"]

    /**
     * type:list
     *
     * Default sequence of numbers displayed unless the user provides another.
     */
    property var numbers: [0, 1, 2, 3, 4]

    /**
     * type:string
     *
     * String containing the numbers selected by user.
     */
    property string answer: ""

    /**
     * type:bool
     *
     * Set to true when good answer is submitted and to
     * avoid the inputs until required.
     */
    property bool answerFlag: false

    /**
     * type:var
     *
     * Column containing containing first half integers i.e.
     * 0 - 4, displayed at the left edge of the activity window.
     */
    property var leftPanelComponent: leftPanel

    /**
     * type:var
     *
     * Column containing containing second half integers i.e.
     * 5 - 9, displayed at the right edge of the activity window.
     */
    property var rightPanelComponent: rightPanel

    /**
     * type:var
     *
     * Button for displaying backSpace key.
     * Removes last input from answer on clicked or pressed.
     */
    property var backspaceButtonComponent: backspaceButton

    /**
     * type:var
     *
     * Button for displaying decimal point character.
     */
    property var decimalPointButton: decimalPointButton

    /**
    * type:bool
    *
    * Enable or disable the button for the decimal point character.
    */
    property bool displayDecimalButton: false

    /**
      * type:readonly string
      *
      * Stores the decimal point character of the current locale.
      */
    readonly property string decimalPoint: ApplicationSettings.locale == "system" ? Qt.locale().decimalPoint : Qt.locale(ApplicationSettings.locale).decimalPoint

    /**
     * type:int
     *
     * Stores the maximum length of the correct answer.
     */
    property int maxDigit: 2

    /**
     * type:int
     *
     * Set this to more than 1 to reduce buttons width on horizontally-constrained activities.
     * Don't set it too high (max. 12).
     */
    property int widthRatio: 4

    /**
     * type:int
     *
     * Stores the width of each key container.
     */
    property int columnWidth: Math.min(width / widthRatio, 80 * ApplicationInfo.ratio)

    /**
     * type:bool
     *
     * Enable or disable press input
     */
    property bool enableInput: true

    signal answer

    visible: ApplicationSettings.isVirtualKeyboard

    Column {
        id: leftPanel
        width: columnWidth
        height: parent.height - 90 * ApplicationInfo.ratio

        Repeater {
            model: 5

            Rectangle{
                width: parent.width
                height: parent.height * 0.2
                color: colours[index]
                border.color: Qt.darker(color)
                border.width: GCStyle.thinBorder

                GCText {
                    anchors.fill: parent
                    anchors.margins: GCStyle.halfMargins
                    fontSize: 28
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    text: numbers[index]
                }

                MouseArea {
                    anchors.fill: parent
                    width: parent.width
                    enabled: ApplicationSettings.isVirtualKeyboard &&
                             containerPanel.opacity > 0 && containerPanel.enableInput

                    onClicked: {
                        if(answer.length < maxDigit)
                            answer += numbers[index]
                    }
                    onPressed: {
                        leftPanel.children[index].color = Qt.lighter(colours[index])
                        leftPanel.children[index].border.width = GCStyle.midBorder
                    }
                    onReleased: {
                        leftPanel.children[index].color = colours[index]
                        leftPanel.children[index].border.width = GCStyle.thinBorder
                    }
                }
            }
        }

        Rectangle {
            id: decimalPointButton
            visible: containerPanel.displayDecimalButton
            width: parent.width
            height: containerPanel.height - leftPanel.height
            color: GCStyle.whiteBg
            border.color: GCStyle.darkBorder
            border.width: GCStyle.thinBorder

            GCText {
                id: decimalPointCharacter
                anchors.fill: parent
                anchors.margins: GCStyle.halfMargins
                fontSize: 28
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                text: containerPanel.decimalPoint
            }

            MouseArea {
                anchors.fill: parent
                enabled: answer.length && answer.indexOf(containerPanel.decimalPoint) == -1

                onClicked: {
                    answer += containerPanel.decimalPoint
                }

                onPressed: {
                    decimalPointButton.color = Qt.lighter(GCStyle.whiteBg)
                    decimalPointButton.border.width = GCStyle.midBorder
                }

                onReleased: {
                    decimalPointButton.color = GCStyle.whiteBg
                    decimalPointButton.border.width = GCStyle.thinBorder
                }
            }
        }
    }

    Column {
        id: rightPanel
        width: columnWidth
        height: parent.height - 90 * ApplicationInfo.ratio
        x: parent.width - columnWidth

        Repeater {
            model: 5

            Rectangle {
                width: parent.width
                height: parent.height * 0.2
                color: colours[index]
                border.color: Qt.darker(color)
                border.width: GCStyle.thinBorder

                GCText {
                    anchors.fill: parent
                    anchors.margins: GCStyle.halfMargins
                    fontSize: 28
                    fontSizeMode: Text.Fit
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.bold: true
                    text: numbers[index] + 5
                }
                MouseArea {
                    anchors.fill: parent
                    width: parent.width * 2
                    enabled: ApplicationSettings.isVirtualKeyboard &&
                             containerPanel.opacity > 0

                    onClicked: {
                        if(answer.length < maxDigit)
                            answer += numbers[index] + 5
                    }
                    onPressed: {
                        rightPanel.children[index].color = Qt.lighter(colours[index])
                        rightPanel.children[index].border.width = GCStyle.midBorder
                    }
                    onReleased: {
                        rightPanel.children[index].color = colours[index]
                        rightPanel.children[index].border.width = GCStyle.thinBorder
                    }
                }
            }
        }

        Rectangle {
            id: backspaceButton
            width: parent.width
            height: containerPanel.height - rightPanel.height
            color: GCStyle.whiteBg
            border.color: GCStyle.darkBorder
            border.width: GCStyle.thinBorder

            GCText {
                anchors.fill: parent
                anchors.margins: GCStyle.halfMargins
                fontSize: 28
                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                text: "←"
            }

            MouseArea {
                anchors.fill: parent
                enabled: ApplicationSettings.isVirtualKeyboard &&
                         containerPanel.opacity > 0 &&
                         containerPanel.enableInput

                onClicked: {
                    answer = answer.substring(0,answer.length - 1)
                }
                onPressed: {
                    backspaceButton.color = Qt.lighter(GCStyle.whiteBg)
                    backspaceButton.border.width = GCStyle.midBorder
                }

                onReleased: {
                    backspaceButton.color = GCStyle.whiteBg
                    backspaceButton.border.width = GCStyle.thinBorder
                }
            }
        }
    }

    function resetText() {
        answer = ""
    }

    function updateAnswer(key, isKeyPressed) {
        if(!containerPanel.enableInput)
            return;

        var keyValue;

        switch(key)
        {
        case Qt.Key_0:
            keyValue = 0;
            break;
        case Qt.Key_1:
            keyValue = 1;
            break;
        case Qt.Key_2:
            keyValue = 2;
            break;
        case Qt.Key_3:
            keyValue = 3;
            break;
        case Qt.Key_4:
            keyValue = 4;
            break;
        case Qt.Key_5:
            keyValue = 5;
            break;
        case Qt.Key_6:
            keyValue = 6;
            break;
        case Qt.Key_7:
            keyValue = 7;
            break;
        case Qt.Key_8:
            keyValue = 8;
            break;
        case Qt.Key_9:
            keyValue = 9;
            break;
        case Qt.Key_Backspace:
            keyValue = 10;
            break;
        case Qt.Key_Period:
        case Qt.Key_Comma:
            keyValue = containerPanel.decimalPoint;
        }

        if(isKeyPressed && !answerFlag)
        {
            if(keyValue < 5 && answer.length < maxDigit)
            {
                answer += keyValue;
                leftPanel.children[keyValue].color = Qt.lighter(colours[keyValue])
                leftPanel.children[keyValue].border.width = GCStyle.midBorder
            }
            else if(keyValue < 10 && answer.length < maxDigit)
            {
                answer += keyValue;
                rightPanel.children[keyValue - 5].color = Qt.lighter(colours[keyValue - 5])
                rightPanel.children[keyValue - 5].border.width = GCStyle.midBorder
            }
            else if(keyValue === 10)
            {
                answer = answer.substring(0,answer.length - 1);
                backspaceButton.color = Qt.lighter(GCStyle.whiteBg)
                backspaceButton.border.width = GCStyle.midBorder
            }
            //In case the button for the decimal point character is enabled, and
            //In case the key entered by the user is a decimal point character, and
            //In case the length of the answer is less than the maximum digits, and
            //In case the answer isn't empty string (to avoid having decimal point as a first character in the answer), and
            //In case the answer doesn't contain a decimal point (to avoid having 2 decimal point characters in the answer).
            else if(containerPanel.displayDecimalButton && keyValue === containerPanel.decimalPoint && answer.length < maxDigit && answer.length != 0 && answer.indexOf(keyValue) == -1)
            {
                answer += keyValue;
                decimalPointButton.color = Qt.lighter(GCStyle.whiteBg)
                decimalPointButton.border.width = GCStyle.midBorder
            }
        }
        else
        {
            if(keyValue < 5)
            {
                leftPanel.children[keyValue].color = colours[keyValue]
                leftPanel.children[keyValue].border.width = GCStyle.thinBorder
            }
            else if(keyValue < 10)
            {

                rightPanel.children[keyValue - 5].color = colours[keyValue - 5]
                rightPanel.children[keyValue - 5].border.width = GCStyle.thinBorder
            }
            else if(keyValue === 10)
            {
                backspaceButton.color = GCStyle.whiteBg
                backspaceButton.border.width = GCStyle.thinBorder
            }
            else if(keyValue === containerPanel.decimalPoint)
            {
                decimalPointButton.color = GCStyle.whiteBg
                decimalPointButton.border.width = GCStyle.thinBorder
            }
        }
    }
}

