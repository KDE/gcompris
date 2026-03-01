/* GCompris - OrderingNumbersDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick

import "../../components"
import "../../singletons"

Item {
    id: lineView
    required property var jsonData
    height: details.height

    InformationLine {
        required property var modelData
        width: lineView.width
        label: qsTr("My Result:")
        info: lineView.jsonData.originalElementsOrder + " +++ " + lineView.jsonData.results
        showResult: true
        resultSuccess: lineView.jsonData.originalElementsOrder
    }
}


