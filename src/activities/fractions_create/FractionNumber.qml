/* GCompris - FractionNumber.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../core"

Item {
    id: fractionNumber
    property int value: 0
    signal leftClicked
    signal rightClicked

    property bool interactive: true

    Image {
        id: shiftKeyboardLeft
        source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
        height: parent.height
        sourceSize.height: height
        opacity: fractionNumber.interactive ? 1 : 0
        fillMode: Image.PreserveAspectFit
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }
    MouseArea {
        enabled: fractionNumber.interactive && !items.buttonsBlocked
        width: parent.width * 0.5
        height: parent.height
        anchors.verticalCenter: parent. verticalCenter
        anchors.left: parent.left
        onClicked: {
            leftClicked();
        }
    }
    Item {
        z: 10
        height: fractionNumber.height
        width: shiftKeyboardLeft.width
        anchors.centerIn: parent
        GCText {
            id: valueText
            text: "" + value
            font.weight: Font.DemiBold
            anchors.centerIn: parent
            color: GCStyle.whiteText
        }
    }
    Image {
        id: shiftKeyboardRight
        source: "qrc:/gcompris/src/core/resource/bar_next.svg"
        height: parent.height
        sourceSize.height: height
        opacity: fractionNumber.interactive ? 1 : 0
        fillMode: Image.PreserveAspectFit
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
    MouseArea {
        enabled: fractionNumber.interactive && !items.buttonsBlocked
        width: parent.width * 0.5
        height: parent.height
        anchors.verticalCenter: parent. verticalCenter
        anchors.right: parent.right
        onClicked: {
            rightClicked();
        }
    }
}
