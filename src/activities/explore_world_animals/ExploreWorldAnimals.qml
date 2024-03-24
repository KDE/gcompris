/* GCompris - explore_world_animals.qml
*
* SPDX-FileCopyrightText: 2015 Johnny Jazeix <jazeix@gmail.com>
*
* Authors:
*   Beth Hadley <bethmhadley@gmail.com> (GTK+ version)
*   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/

import GCompris 1.0

import "../explore_farm_animals"

ExploreLevels {
    id: activity

    numberOfLevels: 3
    url: "qrc:/gcompris/src/activities/explore_world_animals/resource/"
    hasAudioQuestions: false
}
