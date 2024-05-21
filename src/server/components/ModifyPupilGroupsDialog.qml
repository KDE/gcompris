/* GCompris - ModifyPupilGroupsDialog.qml
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
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Popup {
    id: modifyPupilGroupsDialog

    property string label: "To be modified in calling element."
    property string inputText: "Group Name to be modified in calling element."
    property bool textInputReadOnly: false

    signal pupilGroupsModified(string pupilGroupsList)

    QtObject {
        id: items
        property alias groupNamesListView: groupNamesListView
    }

    signal accepted(string textInputValue)

    anchors.centerIn: Overlay.overlay
    width: 400
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    ColumnLayout {
        height: parent.height

        width: parent.width

        Rectangle {
            id: removePupilTextRectangle

            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: 40
            Layout.preferredHeight: 40
            Text {
                id: deletePupilGroupsText
                anchors.centerIn: parent
                text: qsTr("Remove pupil")
                font.bold: true
                color: "grey"
                font {
                  family: Style.fontAwesome
                  pixelSize: 15
                }
            }
        }

        Rectangle {
            id: deletePupilRectangle
            Layout.preferredWidth: parent.width
            Layout.minimumHeight: 40
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignCenter

            Rectangle {
                id: trashIconRectangle
                anchors.centerIn: parent
                width: 50
                height: deletePupilRectangle.height
                Text {
                    id: trashIcon
                    text: "\uf2ed"
                    anchors.centerIn: parent
                    color: "grey"
                    font {
                        family: Style.fontAwesome
                        pixelSize: Style.pixelSizeNavigationBarIcon / 2
                    }
                }
                MouseArea {
                   anchors.fill: parent
                   hoverEnabled: true
                   onClicked: {
                       //addAGroupText.color = Style.colourNavigationBarBackground
                       //removeGroupDialog.groupNameIndex = index
                   //    removeGroupDialog.open()
                       console.log("remove pupil...")
                   }
                   onEntered: { trashIcon.color = Style.colourNavigationBarBackground
                   }
                   onExited: { trashIcon.color = Style.colourCommandBarFontDisabled }
                }
            }
        }

        Rectangle {
            id: separatorLine

            Layout.alignment: Qt.AlignCenter
            Layout.minimumHeight: 1
            Layout.preferredHeight: 1
            Layout.preferredWidth: parent.width

            color: "grey"
        }


        Rectangle {
            id: modifyGroupsTextRectangle

            Layout.preferredWidth: parent.width
            Layout.minimumHeight: 50
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignCenter

            Text {
                id: modifyGroupsText
                anchors.centerIn: parent
                text: qsTr("Modify pupil groups")
                font.bold: true
                color: "grey"
                font {
                  family: Style.fontAwesome
                  pixelSize: 15
                }
            }
        }

        Rectangle {
            id: groupNamesRectangle
            Layout.preferredWidth: parent.width / 3
            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true

            Layout.minimumHeight: 50
            Layout.preferredHeight: 40

            border.color: "red"
            border.width: 3

            ListView {
                id: groupNamesListView
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height

                model: masterController.ui_groups
                delegate: CheckDelegate {
                    text: modelData.name

                    onCheckedChanged: {
                        print("checked changed: " + index)
                    }
                }
            }
        }
    }

    onClosed: {
        console.log("close popup")
        var pupilGroupsCheckedList = []

        groupNamesListView.contains()

        print("index: " + index)
    }

}
