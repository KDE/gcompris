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
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: activityConfiguration
    property Item configBackground
    property string locale: "system"
    width: flick.width
    height: childrenRect.height
    property alias availableLangs: langs.languages
    LanguageList {
        id: langs
    }

    readonly property var availableModes: [
        { "text": qsTr("Uppercase letters"), "value": "uppercase" },
        { "text": qsTr("Lowercase letters"), "value": "lowercase" }
    ]

    Column {
        spacing: GCStyle.baseMargins
        width: activityConfiguration.width
        GCComboBox {
            id: localeBox
            model: langs.languages
            boxBackground: activityConfiguration.configBackground
            label: qsTr("Select your locale")
        }
        GCComboBox {
            id: modeBox
            model: availableModes
            boxBackground: activityConfiguration.configBackground
            label: qsTr("Select your mode")
        }
    }

    function setLocale(localeToSet: string) {
        activityConfiguration.locale = Core.resolveLocale(localeToSet);
    }

    property var dataToSave

    function setDefaultValues() {
        var localeUtf8 = dataToSave.locale;
        if(localeUtf8 !== "system") {
            localeUtf8 += ".UTF-8";
        }

        if(dataToSave.locale) {
            setLocale(localeUtf8)
        }
        else {
            localeBox.currentIndex = 0;
            setLocale(activityConfiguration.availableLangs[0].locale);
        }

        for(var i = 0 ; i < activityConfiguration.availableLangs.length ; i ++) {
            if(activityConfiguration.availableLangs[i].locale === localeUtf8) {
                localeBox.currentIndex = i;
                break;
            }
        }

        if(dataToSave["caseMode"] === undefined) {
            dataToSave["caseMode"] = "uppercase";
            modeBox.currentIndex = 0;
        }
        for( var i = 0 ; i < availableModes.length ; i++) {
            if(availableModes[i].value === dataToSave["caseMode"]) {
                modeBox.currentIndex = i;
                break;
            }
        }
    }

    function saveValues() {
        var newLocale = activityConfiguration.availableLangs[localeBox.currentIndex].locale;
        // Remove .UTF-8
        if(newLocale.indexOf('.') != -1) {
            newLocale = newLocale.substring(0, newLocale.indexOf('.'));
        }
        setLocale(newLocale);
        var newMode = availableModes[modeBox.currentIndex].value;
        dataToSave = {"locale": newLocale, "caseMode": newMode, "activityLocale": activityConfiguration.locale};
    }
}
