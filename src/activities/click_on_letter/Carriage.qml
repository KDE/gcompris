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

import QtQuick
import core 1.0
import QtQuick.Effects
import "../../core"
import "click_on_letter.js" as Activity

Image {
    id: carriageItem
    required property int index
    required property string letter
    property ErrorRectangle errorRectangle
    property int nbCarriage
    property bool isCarriage: index <= nbCarriage
    property bool clickEnabled
    property bool isSelected
    property bool keyNavigationMode
    property alias successAnimation: successAnimation
    property alias particle: particle
    property alias carriageBg: carriageBg

    sourceSize.width: width
    fillMode: Image.PreserveAspectFit
    source: isCarriage ?
                Activity.url + "carriage.svg":
                Activity.url + "cloud.svg"
    z: (state == 'scaled') ? 1 : -1

    signal clicked

    Rectangle {
        id: carriageBg
        visible: carriageItem.isCarriage
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.13
        anchors.bottomMargin: parent.height * 0.325
        radius: GCStyle.halfMargins
        color: "#f0d578"
        border.color: "#b98a1c"
        border.width: GCStyle.thinBorder
    }

    Rectangle {
        id: selector
        visible: carriageItem.isSelected && carriageItem.keyNavigationMode
        width: parent.width
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: carriageItem.isCarriage ?
            carriageBg.horizontalCenter : parent.horizontalCenter
        radius: GCStyle.halfMargins
        color: GCStyle.highlightColor
        border.color: GCStyle.whiteBorder
        border.width: GCStyle.thinBorder
    }

    GCText {
        id: text
        anchors.centerIn: carriageItem.isCarriage ? carriageBg : parent
        text: carriageItem.letter
        width: carriageBg.width
        height: carriageBg.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.Fit
        minimumPointSize: 7
        fontSize: largeSize
        font.bold: true
        style: Text.Outline
        styleColor: GCStyle.darkerText
        color: GCStyle.whiteText
    }

    MultiEffect {
        anchors.fill: text
        source: text
        shadowEnabled: true
        shadowBlur: 1.0
        blurMax: 6
        shadowHorizontalOffset: 1
        shadowVerticalOffset: 1
        shadowOpacity: 0.25
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: ApplicationInfo.isMobile ? false : true

        onClicked: {
            if(carriageItem.clickEnabled) {
                carriageItem.clicked()
                if (Activity.checkAnswer(carriageItem.index)) {
                    successAnimation.restart();
                    particle.burst(30);
                } else {
                    carriageItem.errorRectangle.moveErrorRectangle(carriageItem);
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
            carriageItem {
                scale: 1.2
                z: 2
            }
        }
    }

    transitions: Transition {
        NumberAnimation { properties: "scale"; easing.type: Easing.OutCubic }
    }

    SequentialAnimation {
        id: successAnimation
        NumberAnimation {
            target: carriageItem
            easing.type: Easing.InOutQuad
            property: "rotation"
            to: 20; duration: 100
        }
        NumberAnimation {
            target: carriageItem
            easing.type: Easing.InOutQuad
            property: "rotation"; to: -20
            duration: 100 }
        NumberAnimation {
            target: carriageItem
            easing.type: Easing.InOutQuad
            property: "rotation"
            to: 0; duration: 50
        }
    }
}
