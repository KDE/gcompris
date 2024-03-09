/* GCompris - Carriage.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0
import Qt5Compat.GraphicalEffects 1.0
import "../../core"
import "click_on_letter.js" as Activity

Item {
    id: carriageItem
    property int nbCarriage
    property bool isCarriage: index <= nbCarriage
    property bool clickEnabled
    property bool isSelected
    property alias successAnimation: successAnimation
    property alias particle: particle

    Image {
        id: carriageImage
        width: parent.width
        height: parent.height
        sourceSize.width: width
        fillMode: Image.PreserveAspectFit
        source: isCarriage ?
                    Activity.url + "carriage.svg":
                    Activity.url + "cloud.svg"
        z: (state == 'scaled') ? 1 : -1

        Rectangle {
            id: carriageBg
            visible: isCarriage
            width: parent.width - 8
            height: parent.height / 1.8
            anchors.bottom: parent.top
            anchors.bottomMargin: - parent.height / 1.5
            radius: height / 10
            color: "#f0d578"
            border.color: "#b98a1c"
            border.width: 3
        }

        Rectangle {
            id: selector
            z: 9
            visible: isSelected && items.keyNavigationMode
            anchors.fill: parent
            radius: 5
            color: "#800000ff"
        }

        GCText {
            id: text
            anchors.horizontalCenter: isCarriage ?
                                          carriageBg.horizontalCenter :
                                          parent.horizontalCenter
            anchors.verticalCenter: isCarriage ?
                                        carriageBg.verticalCenter :
                                        parent.verticalCenter
            z: 11
            text: letter
            width: parent.width * 0.9
            height: parent.height * 0.9
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            minimumPointSize: 7
            fontSize: largeSize
            font.bold: true
            style: Text.Outline
            styleColor: "#2a2a2a"
            color: "white"
        }

        DropShadow {
            anchors.fill: text
            cached: false
            horizontalOffset: 1
            verticalOffset: 1
            radius: 3
            samples: 16
            color: "#422a2a2a"
            source: text
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: ApplicationInfo.isMobile ? false : true

            onClicked: {
                if(carriageItem.clickEnabled) {
                    items.lastSelectedIndex = train.currentIndex
                    items.keyNavigationMode = false;
                    items.buttonsBlocked = true;
                    if (Activity.checkAnswer(index)) {
                        successAnimation.restart();
                        particle.burst(30);
                    } else {
                        background.moveErrorRectangle(carriageItem);
                    }
                }
            }
        }

        ParticleSystemStarLoader {
            z: 10
            id: particle
            clip: false
        }

        states: State {
            name: "scaled"; when: mouseArea.containsMouse
            PropertyChanges {
                target: carriageItem
                scale: /*carriageImage.scale * */ 1.2
                z: 2
            }
        }

        transitions: Transition {
            NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
        }

        SequentialAnimation {
            id: successAnimation
            NumberAnimation {
                target: carriageImage
                easing.type: Easing.InOutQuad
                property: "rotation"
                to: 20; duration: 100
            }
            NumberAnimation {
                target: carriageImage
                easing.type: Easing.InOutQuad
                property: "rotation"; to: -20
                duration: 100 }
            NumberAnimation {
                target: carriageImage
                easing.type: Easing.InOutQuad
                property: "rotation"
                to: 0; duration: 50
            }
        }
    }
}
