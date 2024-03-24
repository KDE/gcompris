/* GCompris - Chronos.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   José Jorge <jjorge@free.fr> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../babymatch"

Babymatch {
    id: activity
    onStart: focus = true
    onStop: {}

    useMultipleDataset: true
    boardsUrl: "qrc:/gcompris/src/activities/chronos/resource/"
    levelCount: 6
}
