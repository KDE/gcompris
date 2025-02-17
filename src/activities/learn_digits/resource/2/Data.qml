/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import core 1.0

Data {
    objective: qsTr("Digits from 1 to 3.")
    difficulty: 1

    data: [
        {
            questionsArray: [1, 2, 3],
            circlesModel: 3
        }
    ]
}
