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
    objective: qsTr("Travel to the Moon.")
    difficulty: 5
    data: [
        {
            // To override the default hardcoded instruction, define instruction string
            // instruction: "overridden instruction"
            values: [
                'qrc:/gcompris/src/activities/chronos/resource/images/moon-01.svg',
                'qrc:/gcompris/src/activities/chronos/resource/images/moon-02.svg',
                'qrc:/gcompris/src/activities/chronos/resource/images/moon-03.svg',
                'qrc:/gcompris/src/activities/chronos/resource/images/moon-04.svg'
            ]
        }
    ]
}
