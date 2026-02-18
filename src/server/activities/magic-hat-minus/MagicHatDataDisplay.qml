/* GCompris - MagicHatDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import "../../components"
import "../../singletons"

Item {
    id: lineItem
    required property var jsonData
    height: details.height + Style.hugeMargins
    width: childrenRect.width + Style.margins

    DefaultLabel {
        // The math operation
        id: operatorText
        width: Style.controlSize
        height: Style.controlSize
        text: lineItem.jsonData.mode == "minus" ? "-" : "+"
        fontSizeMode: Text.Fit
        font.bold: true
        y: secondOperandsColumn.y + details.y
    }

    Column {
        id: details
        x: operatorText.width + Style.margins
        y: Style.bigMargins
        spacing: Style.bigMargins
        height: childrenRect.height
        width: childrenRect.width

        Column {
            id: firstOperandsColumn
            spacing: Style.smallMargins
            width: childrenRect.width

            Repeater {
                id: firstOperandsRows
                model: lineItem.jsonData.questionContent.firstOperandRows
                delegate: StarsBar {
                    coefficient: lineItem.jsonData.questionContent.questionCoefficients[index]
                    coefficientVisible: lineItem.jsonData.useCoefficients
                    useDifferentStars: lineItem.jsonData.useDifferentStars
                    opacity: modelData > 0 ? 1 : 0
                    visible:  modelData > 0 ||
                        (index === 1 &&
                         lineItem.jsonData.questionContent.firstOperandRows[2] > 0)
                }
            }
        }

        Column {
            id: secondOperandsColumn
            spacing: Style.smallMargins

            Repeater {
                id: secondOperandsRows
                model: lineItem.jsonData.questionContent.secondOperandRows
                delegate: StarsBar {
                    coefficient: lineItem.jsonData.questionContent.questionCoefficients[index]
                    coefficientVisible: lineItem.jsonData.useCoefficients
                    useDifferentStars: lineItem.jsonData.useDifferentStars
                    opacity: lineItem.jsonData.questionContent.firstOperandRows[index] > 0 ? 1 : 0
                    visible: lineItem.jsonData.questionContent.firstOperandRows[index] > 0 ||
                        (index === 1 &&
                            lineItem.jsonData.questionContent.firstOperandRows[2] > 0)
                }
            }
        }

        Rectangle {
            width: firstOperandsColumn.width
            height: 4
            color: Style.selectedPalette.text
        }

        Column {
            spacing: Style.smallMargins

            Repeater {
                id: answerRows
                model: lineItem.jsonData.questionContent.answerRows
                delegate: StarsBar {
                    isResult: true
                    coefficient: lineItem.jsonData.questionContent.answerCoefficients[index]
                    coefficientVisible: lineItem.jsonData.useCoefficients
                    useDifferentStars: lineItem.jsonData.useDifferentStars
                    opacity: (lineItem.jsonData.useCoefficients ||
                        lineItem.jsonData.questionContent.firstOperandRows[index] > 0 ||
                        modelData.indexOf(true) != -1) ? 1 : 0
                    visible: (lineItem.jsonData.useCoefficients ||
                        lineItem.jsonData.questionContent.firstOperandRows[index] > 0 ||
                        (index === 1 &&
                            lineItem.jsonData.questionContent.firstOperandRows[2] > 0) ||
                        (modelData.indexOf(true) != -1))
                }
            }
        }
    }
}

