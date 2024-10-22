/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import GCompris 1.0
import "../../../memory/math_util.js" as Memory

Data {
    objective: qsTr("Multiplication table of 10.")
    difficulty: 5

    data: [
        { // Level 1
            columns: 5,
            rows: 2,
            texts: Memory.getMultTable(10)
        }
    ]
}
