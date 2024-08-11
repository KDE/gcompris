/* GCompris - Hexagon.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Christof Petig and Ingo Konrad (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (add mode without OpenGL, port to QtQuick.Shapes)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Shapes 1.5
import "hexagon.js" as Activity
import "../../core"
import GCompris 1.0

Item {
    id: hexagon
    property GCSfx audioEffects
    property ParticleSystemStar particles
    property alias color: cellColor.fillColor
    property bool hasStrawberry: false
    property double ix
    property double iy
    property int nbx
    property int nby
    // Warning testing parent here, just to avoid an error at deletion time
    property double r: parent ? Math.min(parent.width / nbx / 2, (parent.height - 10) / nby / 2) : 0
    property double offsetX: parent ? (parent.width % (width * nbx)) / 2 : 0
    property double offsetY: parent ? (parent.height % (height * nby)) / 2 : 0
    x: (iy % 2 ? width * ix + width / 2 : width * ix) + offsetX
    y: height * iy - (Math.sin((Math.PI * 2) / 12) * r * 2 * iy) / 2 + offsetY
    width: Math.cos((Math.PI * 2) / 12) * r * 2
    height: r * 2

    Image {
        id: strawberry
        anchors.fill: parent
        opacity: 0
        onSourceChanged: opacity = 1
        Behavior on opacity { PropertyAnimation { duration: 2000; easing.type: Easing.OutQuad } }
    }

    Shape {
        id: cellFill
        anchors.fill: border
        opacity: 0.65
        onOpacityChanged: if(opacity == 0) Activity.strawberryFound()
        Behavior on opacity { PropertyAnimation { duration: 500 } }
        ShapePath {
            id: cellColor
            strokeWidth: 0
            startX: cellFill.width * 0.02; startY: cellFill.height * 0.25
            PathLine { x: cellFill.width * 0.51 ; y: cellFill.height * 0.02 }
            PathLine { x: cellFill.width * 0.98 ; y: cellFill.height * 0.22 }
            PathLine { x: cellFill.width * 0.98 ; y: cellFill.height * 0.77 }
            PathLine { x: cellFill.width * 0.51 ; y: cellFill.height * 0.97 }
            PathLine { x: cellFill.width * 0.02 ; y: cellFill.height * 0.75 }
            PathLine { x: cellFill.width * 0.02 ; y: cellFill.height * 0.25 }
        }
    }

    Image {
        id: border
        anchors.fill: parent
        source: Activity.url + "hexagon_border.svg"
        Behavior on opacity { PropertyAnimation { duration: 500 } }
    }

    // Create a particle only for the strawberry
    Loader {
        id: particleLoader
        anchors.fill: parent
        active: hasStrawberry
        sourceComponent: particle
    }

    Component {
        id: particle
        ParticleSystemStarLoader
        {
            id: particles
            clip: false
        }
    }

    property bool isTouched: false
    function touched() {
        if(hasStrawberry && !isTouched) {
            cellFill.opacity = 0
            border.opacity = 0
            isTouched = true
            strawberry.source = Activity.url + "strawberry.svg"
            audioEffects.play("qrc:/gcompris/src/core/resource/sounds/win.wav")
            Activity.strawberryFound()
            particleLoader.item.burst(40)
        } else {
            hexagon.color =
                    Activity.getColor(Activity.getDistance(hexagon.ix, hexagon.iy))
        }
    }
}
