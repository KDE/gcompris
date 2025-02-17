/* GCompris - PaintCursor.qml
 *
 * SPDX-FileCopyrightText: 2018 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "simplepaint.js" as Activity
import core 1.0


Item {
    id: cursor
    property int ix
    property int iy
    property int nbx
    property int nby
    property int initialX
    // Warning testing parent here, just to avoid an error at deletion time
    property int r: parent ? Math.min(Math.floor((parent.width - initialX) / nbx / 2), Math.floor((parent.height - bar.height) / nby / 2)) : 0
    property int offsetX: parent ? Math.floor((initialX + parent.width % (width * nbx)) / 2) : 0
    property int offsetY: parent ? 10 : 0
    x: width * ix + offsetX
    y: height * iy + offsetY
    width: r * 2
    height: r * 2

    Image {
        scale: 0.9
        width: parent.height
        height: parent.height
        sourceSize.width: height
        sourceSize.height: height
        source: Activity.url + "cursor.svg"
        visible: true
        anchors.centerIn: parent
    }


}
