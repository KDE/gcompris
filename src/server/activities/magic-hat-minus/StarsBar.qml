/* GCompris - StarsBar.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import "../../components"
import "../../singletons"

Item {
    id: starsBar
    required property int index
    // modelData should be either an int if !isResult, or a list<bool> if isResult
    required property var modelData
    required property int coefficient
    required property bool coefficientVisible
    required property bool useDifferentStars
    property string starsColor: "1"

    property bool isResult: false

    height: Style.controlSize
    width: rowlayout.width

    Component.onCompleted: {
        starsColor = setStarColor();
    }

    function setStarColor() {
        if(starsBar.index === 0 || !starsBar.useDifferentStars) {
            return "1";
        } else if(starsBar.index === 1) {
            return "2";
        } else if(starsBar.index === 2) {
            return "3";
        }
    }

    Row {
        id: rowlayout
        height: Style.controlSize
        width: childrenRect.width
        spacing: Style.tinyMargins

        DefaultLabel {
            id: text
            visible: starsBar.coefficientVisible
            //: text displaying coefficient with which the set of stars is to be multiplied along with multiplication symbol.
            text: qsTr("%1x").arg(starsBar.coefficient)
            font.bold: false
            height: Style.controlSize
            width: Style.controlSize * 2
            minimumPointSize: 6
            fontSizeMode: Text.Fit
        }

        Repeater {
            id: repeaterStars
            model: starsBar.visible ? 10 : 0
            delegate: Star {
                selected: starsBar.isResult ?
                    starsBar.modelData[index] : index < starsBar.modelData
                starsColor: starsBar.starsColor
            }
        }
    }
}
