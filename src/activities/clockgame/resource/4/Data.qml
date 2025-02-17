/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Time containing minutes.")
    difficulty: 5
    data: [
        {
            "numberOfSubLevels": 5,
            "displayMinutesHand": true,
            "fixedSeconds": 0,
            "displaySecondsHand": false
        }
    ]
}
