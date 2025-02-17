/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    //: \u002B is the unicode character for addition mathematical operator (+), \u2212 for subtraction (-), \u00D7 for multiplication (*)
    objective: qsTr("Small grids with \u002B, \u2212 and \u00D7 operators.")
    difficulty: 4

    property var symbols: [
        {"imgName": "1.svg", "text": '1'},
        {"imgName": "2.svg", "text": '2'},
        {"imgName": "3.svg", "text": '3'}
    ]

    data: [
        {
            "random": true,
            "length": 20,
            "symbols": symbols,
            "size": 3,
            "operators": ["+", "-", "*"]
        }
    ]
}
