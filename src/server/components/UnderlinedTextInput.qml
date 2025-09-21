/* GCompris - UnderlinedTextInput.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Layouts 1.2
import "../../core"

Item {
    id: underlinedTextInput

    property string defaultText: "Default text, must be set in calling element"
    property alias text: textInput.text

    onFocusChanged: { if(focus) textInput.forceActiveFocus(); }
    TextInput {
        id: textInput

        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width * 5/6
        text: defaultText
        cursorVisible: false
        font {
            family: Style.fontAwesome
            pixelSize: 15
        }
        selectByMouse: true
        focus: true
    }

    Rectangle {
        id: underlinePupilNameTextInput
        anchors.left: textInput.left
        anchors.top: textInput.bottom

        width: textInput.width
        height: 1
        color: Style.colourNavigationBarBackground
    }
}
