/* GCompris - Imagename.qml
 *
 * SPDX-FileCopyrightText: 2015 Pulkit Gupta <pulkitgenius@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin (bruno.coudoin@gcompris.net) / Andre Connes (andre.connes@toulouse.iufm.fr) (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com>  (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../babymatch"

Babymatch {
    id: activity

    onStart: focus = true
    onStop: {}

    imagesUrl: "qrc:/gcompris/src/activities/babymatch/resource/"
    boardsUrl: "qrc:/gcompris/src/activities/imagename/resource/"
    levelCount: 7
}
