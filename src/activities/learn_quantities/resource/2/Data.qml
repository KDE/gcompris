/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Between 1 and 4.")
    difficulty: 2
    data: [
        {
            "numberOfSubLevels": 4,
            "minValue" : 1,
            "maxValue" : 4
        }
    ]
}
