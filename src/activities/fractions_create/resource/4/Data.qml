/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import GCompris 1.0

Data {
    objective: qsTr("Non-simplified fractions with a square.")
    difficulty: 5

    data: [
        [{
            "chartType": "rectangle",
            "numerator": 2,
            "denominator": 4,
            "instruction": qsTr("Select one half of the square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 4,
            "denominator": 8,
            "instruction": qsTr("Select one half of the square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 5,
            "denominator": 10,
            "instruction": qsTr("Select one half of the square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 3,
            "denominator": 9,
            "instruction": qsTr("Select one-third of the square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 4,
            "denominator": 6,
            "instruction": qsTr("Select two-thirds of the square.")
        }
        ],
        [
        {
            "chartType": "rectangle",
            "numerator": 2,
            "denominator": 6,
            "instruction": qsTr("Select one-third of the square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 6,
            "denominator": 9,
            "instruction": qsTr("Select two-thirds of the square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 2,
            "denominator": 8,
            "instruction": qsTr("Select one-quarter of the square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 4,
            "denominator": 10,
            "instruction": qsTr("Select two-fifths of the square.")
        },
        {
            "chartType": "rectangle",
            "numerator": 6,
            "denominator": 10,
            "instruction": qsTr("Select three-fifths of the square.")
        }
        ]
    ]
}
