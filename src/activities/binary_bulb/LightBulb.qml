/* GCompris - LightBulb.qml
 *
 * SPDX-FileCopyrightText: 2018 Rajat Asthana <rajatasthana4@gmail.com>
 *
 * Authors:
 *   RAJAT ASTHANA <rajatasthana4@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import core 1.0
import "binary_bulb.js" as Activity

Item {
    id: bulb
    anchors.verticalCenter: parent.verticalCenter
    state: "off"
    focus: true

    property alias valueVisible: valueText.visible

    Rectangle {
        color: "transparent"
        width: parent.width + 10
        height: parent.height + 10
        border.color: "red"
        border.width: 3
        anchors.centerIn: bulbImage
        radius: 5
        visible: index == items.currentSelectedBulb
    }
    Image {
        id: bulbImage
        width: parent.width
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectFit
        source: "resource/bulb_off.svg"
    }
    property string bit: ""
    readonly property int value: Math.pow(2, items.numberOfBulbs - index - 1)

    GCText {
        id: valueText
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: value
        color: "white"
    }

    MouseArea {
        anchors.fill: parent
        enabled: !items.buttonsBlocked
        onClicked: Activity.changeState(index)
    }

    GCText {
        anchors.top: bulb.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: bit
        color: "white"
    }

    states: [
        State {
            name: "off"
            PropertyChanges {
                bulb {
                    bit: "0"
                }
            }
            PropertyChanges {
                bulbImage {
                    source: "resource/bulb_off.svg"
                }
            }
        },
        State {
            name: "on"
            PropertyChanges {
                bulb {
                    bit: "1"
                }
            }
            PropertyChanges {
                bulbImage {
                    source: "resource/bulb_on.svg"
                }
            }
        }
    ]
}
