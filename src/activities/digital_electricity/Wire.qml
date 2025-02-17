/* GCompris - Wire.qml
 *
 * SPDX-FileCopyrightText: 2016 Pulkit Gupta <pulkitnsit@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "digital_electricity.js" as Activity

Rectangle {
    id: wire

    property QtObject from
    property QtObject to
    property bool destructible

    height: 5 * ApplicationInfo.ratio
    color: from.value == 0 ? "#d21818" : "#6ce76c"
    radius: height / 2
    transformOrigin: Item.Left

    MouseArea {
        id: mouseArea
        enabled: destructible
        width: parent.width
        height: parent.height * 3
        anchors.centerIn: parent
        onPressed: {
            if(Activity.toolDelete) {
                Activity.removeWire(wire)
            }
        }
    }
}
