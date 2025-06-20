/* GCompris - arrow.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound

import QtQuick
import core 1.0
import "../../core"

Repeater {
    id: arrowRepeater
    model: 0
    
    signal init(int nbArrow)
    signal reattachArrow(Item arrow)
    
    onInit: (nbArrow) => {
        // Set to 0 to force a delete of previous arrows
        model = 0
        model = nbArrow
    }
    
    Rectangle {
        id: arrow
        width: 15 * ApplicationInfo.ratio
        height: 15 * ApplicationInfo.ratio
        radius: width / 2
        anchors.centerIn: parent
        border.width: GCStyle.thinnestBorder
        border.color: "#60000000"
        opacity: 0
        color: "#d6d6d6"
        scale: 2
        
        Behavior on scale {
            id: scale
            NumberAnimation {
                id: anim
                duration: 1000
                easing.type: Easing.InOutQuad
                onRunningChanged: {
                    if(!anim.running) {
                        // Reparent the arrow on the target
                        arrowRepeater.reattachArrow(arrow)
                    }
                }
            }
        }
    }
}
