/* GCompris - CheckSimpleDelegate.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../singletons"

Component {
    id: checkSimpleDelegate
    Control {
        id: lineBox
        font.pixelSize: Style.defaultPixelSize
        hoverEnabled: true
        Rectangle {
            anchors.fill: parent
            color: lineBox.hovered ? Style.colorHeaderPane : "transparent"
        }
        CheckBox {
            anchors.fill: parent
            anchors.leftMargin: 10
            text: eval(nameKey)         // In these cases, eval is safe because no code injection is possible
            checked: eval(checkKey)     // Eval's parameter is an internal column name
            ButtonGroup.group: childGroup
            onClicked: {
                currentChecked = index
                foldModel.setProperty(index, checkKey, checked)
                selectionClicked(foldModel.get(index)[indexKey], checked)
            }
        }
    }
}
