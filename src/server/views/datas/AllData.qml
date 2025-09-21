/* GCompris - AllData.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import "../../singletons"
import "../../components"
import "../../panels"

Item {
    anchors.margins: 2

    function setRequest(i) {
        switch (i) {
        case 0 :
            reqView.request = "select * from _all_users_activities"
            reqView.wantedColumns = [ "user_name", "activity_name", "result_datetime", "result_success", "result_duration", "result_data"]
            break;
        case 1 :
            reqView.request = "select * from _user_activity_result"
            reqView.wantedColumns = [ "user_name", "activity_name", "count_activity", "count_success", "count_failed"]
            break;
        case 2 :
            reqView.request = "select * from _all_groups"
            reqView.wantedColumns = [ "group_name", "user_name", "user_password"]
            break;
        case 3 :
            reqView.request = "select * from _all_users_activities where result_success=0"
            reqView.wantedColumns = [ "user_name", "activity_name", "result_datetime", "result_data"]
            break;
        case 4 :
            reqView.request = "select * from _user_groups"
            reqView.wantedColumns = [ "user_id", "user_name", "groups_id", "groups_name"]
            break;
        case 5 :
            reqView.request = "select * from _group_users"
            reqView.wantedColumns = [ "group_name", "users_id", "group_description", "users_name"]
            break;
        case 6 :
            reqView.request = "SELECT * FROM _daily_activities"
            reqView.wantedColumns = [ "activity_name", "result_day", "count_activity" ]
            break;
        case 7 :
            reqView.request = "SELECT * FROM _daily_ratios"
            reqView.wantedColumns = [ "result_day", "user_name", "activity_name", "count_activity", "success_ratio" ]
            break;
        }
        reqView.sort = ""
        reqView.executeRequest()
    }

    Rectangle {
        anchors.fill: parent
        color: Style.colorBackground

        Row {
            id: selectionRow
            width: parent.width
            height: 40
            spacing:5
            Label {
                text: qsTr("Avalaible requests")
                width: 150
                height: parent.height
                font.bold: true
            }

            ComboBox {
                id: what
                width: 200
                height: parent.height
                model: [ "All users activities", "Pupils activities", "All groups", "Failed activities",
                    "User's groups", "Group's users", "Daily activities", "Daily ratios" ]
                onActivated: setRequest(index)
            }

            Button {
                text: "\uf021"
                width: 40
                height: parent.height
                onClicked: reqView.executeRequest()
            }

            Label {
                text: reqView.count + " " + qsTr("lines")
                width: 80
                height: parent.height
                font.bold: true
            }

            Label {
                text: reqView.request
                width: 500
                height: parent.height
            }
        }

        RequestPanel {
            id: reqView
            dynamicRoles: true      // required here because columns change with each request
            anchors { top: selectionRow.bottom; left: parent.left; bottom: parent.bottom; right: parent.right}
        }
    }
    Component.onCompleted: setRequest(what.currentIndex)
}
