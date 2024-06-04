/* GCompris - GroupDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import "../singletons"
import "../components"

Popup {
    id: addModifyGroupDialog
    enum DialogType { Add, Modify, Remove }
    property string label
    property bool textInputReadOnly: false
    property int mode: GroupDialog.DialogType.Modify
    // Database columns
    property int modelIndex: 0      // index in Master.groupModel
    property int group_Id: 0
    property string group_Name: ""
    property string group_Description: ""

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 250
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    function openGroupDialog(index, group_name, group_id, group_description) {
        modelIndex = index
        group_Name = group_name
        group_Id = group_id
        group_Description = group_description
        open()
    }

    // Always force focus on the text input when displaying the popup
    onAboutToShow: {
        groupNameInput.text = group_Name
        groupDescriptionInput.text = group_Description
        groupNameInput.forceActiveFocus();
    }

    function saveGroup() {
        if (groupNameInput.text !== "") {
            switch (mode) {
            case GroupDialog.DialogType.Add:
                if (Master.createGroup(groupNameInput.text, groupDescriptionInput.text) !== -1)
                    addModifyGroupDialog.close()
                break
            case GroupDialog.DialogType.Modify:
                if (Master.updateGroup(modelIndex, groupNameInput.text, groupDescriptionInput.text))
                    addModifyGroupDialog.close()
                break
            case GroupDialog.DialogType.Remove:
                if (Master.deleteGroup(modelIndex))
                    addModifyGroupDialog.close()
                break
            }
        } else {
            addModifyGroupDialog.close()
        }
        Master.loadGroups()
        Master.loadUsers()
        Master.filterUsers(Master.filteredUserModel, false)
    }

    background: Rectangle {
        color: Style.colorBackgroundDialog
        radius: 5
        border.color: "darkgray"
        border.width: 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent

        Text {
            id: groupDialogText
            Layout.fillWidth: true
            height: 40
            horizontalAlignment: Text.AlignHCenter
            text: label
            font.bold: true
            font {
                pixelSize: 20
            }
        }

        Text {
            Layout.fillWidth: true
            height: 40
            text: qsTr("Name")
            font.bold: true
            font.pixelSize: 15
        }

        UnderlinedTextInput {
            id: groupNameInput
            Layout.fillWidth: true
            Layout.preferredHeight: Style.defaultLineHeight
            activeFocusOnTab: true
            readOnlyText: textInputReadOnly
        }

        Text {
            Layout.fillWidth: true
            height: 40
            text: qsTr("Description")
            font.bold: true
            font.pixelSize: 15
        }

        UnderlinedTextInput {
            id: groupDescriptionInput
            Layout.fillWidth: true
            Layout.preferredHeight: Style.defaultLineHeight
            activeFocusOnTab: true
            readOnlyText: textInputReadOnly
        }

        OkCancelButtons {
            onCancelled: addModifyGroupDialog.close()
            onValidated: saveGroup()
        }

        Keys.onReturnPressed: saveGroup()
        Keys.onEnterPressed: saveGroup()
        Keys.onEscapePressed: addModifyGroupDialog.close()
    }
}
