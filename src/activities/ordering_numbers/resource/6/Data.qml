/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 *
 * Authors:
 *   Harsh Kumar <hadron43@yahoo.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Descending order, 5 random numbers between 8 and 20.")
    difficulty: 4
    data: [
        {
            mode: "descending",
            random: true,          // Set this true to override values array with random values
            minNumber: 8,
            maxNumber: 20,
            numberOfElementsToOrder: 5
        }
    ]
}
