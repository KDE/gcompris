/* GCompris - SequenceElement.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls

import "../singletons"

Rectangle {
    id: sequenceItem
    required property var modelData
    required property int index

    width: parent.width
    height: 2 * Style.lineHeight
    color: mainMouseArea.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.base
    border.color: sequenceItem.activeFocus ? Style.selectedPalette.highlight :
    (mainMouseArea.hovered || (elements.current === index) ? Style.selectedPalette.text :
    Style.selectedPalette.accent)
    border.width: (sequenceItem.activeFocus || (elements.current === index)) ? 2 : 1
    activeFocusOnTab: true

    function selectItem() {
        elements.current = index;
    }

    MouseArea {
        id: mainMouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onClicked: {
            sequenceItem.selectItem();
        }
    }

    Keys.onPressed: (event) => {
        if(event.key == Qt.Key_Space) {
            sequenceItem.selectItem();
        }
    }

    DefaultLabel {
        id: titleText
        font.bold: true
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: Style.margins
            topMargin: Style.margins + Style.smallMargins
        }
        text: modelData.activity_title
    }

    DefaultLabel {
        id: datasetText
        anchors {
            top: titleText.bottom
            left: parent.left
            right: parent.right
            margins: Style.margins
        }
        //: Argument is dataset name
        text: qsTr("Dataset: %1").arg(modelData.dataset_name)
    }
}
