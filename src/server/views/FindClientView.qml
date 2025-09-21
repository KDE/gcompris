/* GCompris - FindClientView.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"

Item {
    Rectangle {
        anchors.fill: parent
        color: Style.colourBackground
        Text {
            anchors.centerIn: parent
            text: "Find Client View"
        }
    }
}
