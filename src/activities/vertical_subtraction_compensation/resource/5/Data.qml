/* GCompris - vertical_subtraction_compensation - Data.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 */
import core 1.0

Data {
    objective: qsTr("Write and solve subtraction, 2 or 3 digits, 3 lines.")
    difficulty: 1
    data: [
        {   "title": objective,
            "nbSubLevel": 10,
            "nbDigits": 2,
            "nbLines": 3,
            "alreadyLaid": false,
            "withCarry": true
        }
    ]
}
