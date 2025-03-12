/* GCompris - Lock.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

Rectangle {
    id: lock
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    height: maxHeight
    border.width: 0
    state: "close"

    property int minHeight
    property int maxHeight
    property int duration
    property bool opened: height == minHeight

    Behavior on height { NumberAnimation { duration: lock.duration } }

    states: [
        State {
            name: "open"
            PropertyChanges { lock { height: lock.minHeight } }
        },
        State {
            name: "close"
            PropertyChanges { lock { height: lock.maxHeight } }
        }
    ]
}
