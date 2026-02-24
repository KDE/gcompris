/* GCompris - ActivityConfig.qml
 *
* SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../../core"

Item {
    id: activityConfiguration
    property Item configBackground
    property bool useDefaultHole: true
    width: flick.width
    height: childrenRect.height

    Column {
        spacing: GCStyle.baseMargins
        width: activityConfiguration.width
        GCDialogCheckBox {
            id: defaultHoleBox
            text: qsTr("Use default start hole")
            checked: activityConfiguration.useDefaultHole
        }
    }

    property var dataToSave
    function setDefaultValues() {
        // Recreate the binding
        defaultHoleBox.checked = Qt.binding(function(){return activityConfiguration.useDefaultHole;});
        activityConfiguration.useDefaultHole = (dataToSave.useDefaultHole === "true");
    }

    function saveValues() {
        activityConfiguration.useDefaultHole = defaultHoleBox.checked;
        dataToSave = {"useDefaultHole": "" + activityConfiguration.useDefaultHole};
    }
}
