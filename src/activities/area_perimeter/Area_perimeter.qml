/* GCompris - area_perimeter.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../polygons"

Polygons {
    id: activity
    datasetSource: "qrc:/gcompris/src/activities/area_perimeter/TutorialDataset.qml"
    hasConfig: false // true if we switch to Dataset for this activity!
}
