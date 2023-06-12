/* GCompris - ConfigurationItem.qml
 *
 * SPDX-FileCopyrightText: 2014-2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0
import QtMultimedia 5.12

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Item {
    id: dialogConfig

    property var languages: allLangs.languages
    property int contentWidth: Math.floor(dialogConfig.width * 0.9)
    property var parentActivity
    height: contentColumn.height

    LanguageList {
        id: allLangs
        inMenu: true
    }

    Column {
        id: contentColumn
        spacing: 10 * ApplicationInfo.ratio
        width: parent.width

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 120 }
        }

        Flow {
            id: difficultyFlow
            width: dialogConfig.contentWidth
            spacing: 5 * ApplicationInfo.ratio
            visible: !ApplicationSettings.filterLevelOverridedByCommandLineOption
            property int starsSize: Math.floor(Math.min(50 * ApplicationInfo.ratio,
                                (dialogConfig.contentWidth - 25 * ApplicationInfo.ratio) * 0.166))

            GCText {
                text: qsTr("Difficulty filter:")
                fontSize: mediumSize
                width: dialogConfig.contentWidth
            }

            // Level filtering
            Repeater {
                id: filterRepeater
                model: 6

                property int minFilter: ApplicationSettings.filterLevelMin
                property int maxFilter: ApplicationSettings.filterLevelMax

                function setMin(value) {
                    var newMin
                    if(minFilter < 1) {
                        newMin = 1
                    }
                    else if(minFilter > 6) {
                        newMin = 6
                    }
                    else if(maxFilter >= value) {
                        newMin = value
                    }

                    if(newMin) {
                        minFilter = newMin
                    }
                }

                function setMax(value) {
                    var newMax
                    if(maxFilter < 1) {
                        newMax = 1
                    }
                    else if(maxFilter > 6) {
                        newMax = 6
                    }
                    else if(minFilter <= value) {
                        newMax = value
                    }

                    if(newMax) {
                        maxFilter = newMax
                    }
                }

                Image {
                    source: "qrc:/gcompris/src/core/resource/difficulty" +
                    (modelData + 1) + ".svg";
                    sourceSize.width: difficultyFlow.starsSize
                    opacity: modelData + 1 >= filterRepeater.minFilter &&
                    modelData + 1 <= filterRepeater.maxFilter
                    ? 1 : 0.4

                    property int value: modelData + 1

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if(parent.value < filterRepeater.maxFilter) {
                                if(parent.opacity == 1) {
                                    filterRepeater.setMin(parent.value + 1)
                                }
                                else {
                                    filterRepeater.setMin(parent.value)
                                }
                            } else if(parent.value > filterRepeater.minFilter) {
                                if(parent.opacity == 1) {
                                    filterRepeater.setMax(parent.value - 1)
                                }
                                else {
                                    filterRepeater.setMax(parent.value)
                                }
                            }
                        }
                    }
                }
            }
        }

        GCComboBox {
            id: languageBox
            model: dialogConfig.languages
            background: dialogActivityConfig
            onCurrentIndexChanged: voicesRow.localeChanged();
            label: qsTr("Language selector")
        }

        Flow {
            id: voicesRow
            width: dialogConfig.contentWidth
            spacing: 5 * ApplicationInfo.ratio

            property bool haveLocalResource: false

            function localeChanged() {
                var language = dialogConfig.languages[languageBox.currentIndex].text;
                voicesRow.haveLocalResource = DownloadManager.haveLocalResource(DownloadManager.getVoicesResourceForLocale(dialogConfig.languages[languageBox.currentIndex].locale))
            }

            Connections {
                target: DownloadManager

                onDownloadFinished: voicesRow.localeChanged()
            }

            GCDialogCheckBox {
                id: voicesText
                width: dialogConfig.contentWidth
                enabled: false
                text: qsTr("Localized voices")
                checked: voicesRow.haveLocalResource
            }

            GCButton {
                id: voicesButton
                height: 30 * ApplicationInfo.ratio
                width: dialogConfig.contentWidth
                visible: ApplicationInfo.isDownloadAllowed
                text: voicesRow.haveLocalResource ? qsTr("Check for updates") :
                qsTr("Download")

                onClicked: {
                    if (DownloadManager.downloadResource(
                            DownloadManager.getVoicesResourceForLocale(dialogConfig.languages[languageBox.currentIndex].locale)))
                    {
                        var downloadDialog = Core.showDownloadDialog(pageView.currentItem, {});
                    }
                }
            }
        }

        GCDialogCheckBox {
            id: enableAudioVoicesBox
            width: dialogConfig.contentWidth
            text: qsTr("Enable audio voices")
            checked: isAudioVoicesEnabled
            onCheckedChanged: {
                isAudioVoicesEnabled = checked;
            }
        }

        GCDialogCheckBox {
            id: enableAudioEffectsBox
            width: dialogConfig.contentWidth
            text: qsTr("Enable audio effects")
            checked: isAudioEffectsEnabled
            onCheckedChanged: {
                isAudioEffectsEnabled = checked;
            }
        }

        GCText {
            id: audioEffectsVolumeText
            text: qsTr("Audio effects volume")
            width: dialogConfig.contentWidth
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }

        GCSlider {
            id: audioEffectsVolumeSlider
            width: 250 * ApplicationInfo.ratio
            to: 10
            from: 0
            value: audioEffectsVolume * 10
            onValueChanged: ApplicationSettings.audioEffectsVolume = value / 10;
            wheelEnabled: false
        }

        GCButton {
            id: backgroundMusicButton
            height: 30 * ApplicationInfo.ratio
            width: dialogConfig.contentWidth
            visible: ApplicationInfo.isDownloadAllowed
            text: qsTr("Download background music")

            onClicked: {
                if(DownloadManager.downloadResource(DownloadManager.getBackgroundMusicResources()))
                    var downloadDialog = Core.showDownloadDialog(pageView.currentItem, {});
            }
        }

        GCDialogCheckBox {
            id: enableBackgroundMusicBox
            width: dialogConfig.contentWidth
            text: qsTr("Enable background music")
            checked: isBackgroundMusicEnabled
            onCheckedChanged: {
                isBackgroundMusicEnabled = checked;
            }
        }

        GCText {
            id: musicText
            text: qsTr("Background Music")
            width: dialogConfig.contentWidth
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }

        Row {
            height: 30 * ApplicationInfo.ratio
            width: background.width * 0.8
            spacing: 5 * ApplicationInfo.ratio
            GCButton {
                id: backgroundMusicName
                height: parent.height
                width: parent.width - 35 * ApplicationInfo.ratio
                enabled: backgroundMusic.playbackState === Audio.PlayingState
                text: {
                    if(backgroundMusic.playbackState !== Audio.PlayingState)
                        return qsTr("Not playing")
                    else if (backgroundMusic.metaDataMusic[0] !== undefined)
                        return (qsTr("Title: %1  Artist: %2").arg(backgroundMusic.metaDataMusic[0]).arg(backgroundMusic.metaDataMusic[1]))
                    else if (String(backgroundMusic.source).slice(0, 37) === "qrc:/gcompris/src/core/resource/intro")
                        return qsTr("Introduction music")
                    return ""
                }
                onClicked: {
                    dialogConfig.visible = false
                    backgroundMusicList.visible = true
                }
            }
            Image {
                source: "qrc:/gcompris/src/core/resource/bar_next.svg"
                height: 30 * ApplicationInfo.ratio
                sourceSize.width: height
                visible: (backgroundMusic.playbackState === Audio.PlayingState && !backgroundMusic.muted)
                MouseArea {
                    anchors.fill: parent
                    enabled: parent.visible
                    onClicked: backgroundMusic.nextAudio()
                }
            }
        }

        GCText {
            id: backgroundMusicVolumeText
            text: qsTr("Background music volume")
            fontSize: mediumSize
            width: dialogConfig.contentWidth
            wrapMode: Text.WordWrap
        }

        GCSlider {
            id: backgroundMusicVolumeSlider
            width: 250 * ApplicationInfo.ratio
            to: 10
            from: 0
            value: backgroundMusicVolume * 10
            onValueChanged: ApplicationSettings.backgroundMusicVolume = value / 10;
            wheelEnabled: false
        }

        GCDialogCheckBox {
            id: enableFullscreenBox
            width: dialogConfig.contentWidth
            text: qsTr("Fullscreen")
            checked: isFullscreen
            onCheckedChanged: {
                isFullscreen = checked;
            }
            visible: !ApplicationInfo.isMobile
        }

        GCDialogCheckBox {
            id: enableVirtualKeyboardBox
            width: dialogConfig.contentWidth
            text: qsTr("Virtual Keyboard")
            checked: isVirtualKeyboard
            onCheckedChanged: {
                isVirtualKeyboard = checked;
            }
        }

        GCDialogCheckBox {
            id: enableAutomaticDownloadsBox
            width: dialogConfig.contentWidth
            checked: isAutomaticDownloadsEnabled
            text: qsTr("Enable automatic downloads/updates of sound files")
            visible: ApplicationInfo.isDownloadAllowed
            onCheckedChanged: {
                isAutomaticDownloadsEnabled = checked;
            }
        }

        GCButton {
            id: wordsetButton
            height: 30 * ApplicationInfo.ratio
            width: dialogConfig.contentWidth
            visible: ApplicationInfo.isDownloadAllowed
            text: qsTr("Download full word image set")

            onClicked: {
                if(DownloadManager.downloadResource("data2/words/words-webp.rcc"))
                    var downloadDialog = Core.showDownloadDialog(pageView.currentItem, {});
            }
        }

        Connections {
            target: DownloadManager
            onDownloadFinished: wordsetBox.updateStatus()
        }

        /* Technically wordset config is a string that holds the wordset name or '' for the
        * internal wordset. But as we support only internal and words its best to show the
        * user a boolean choice.
        */
        GCDialogCheckBox {
            id: wordsetBox
            width: dialogConfig.contentWidth
            checked: useWordset && DownloadManager.isDataRegistered("words-webp")
            text: checked ? qsTr("Full word image set is installed") : qsTr("Full word image set is not installed")
            visible: ApplicationInfo.isDownloadAllowed
            enabled: false
            onCheckedChanged: {
                if(checked) {
                    wordset = "data2/words/words-webp.rcc";
                    useWordset = true;
                } else {
                    wordset = "";
                    useWordset = false;
                }
            }

            function updateStatus() {
                checked = DownloadManager.isDataRegistered("words-webp")
            }
        }

        GCDialogCheckBox {
            id: sectionVisibleBox
            width: dialogConfig.contentWidth
            checked: sectionVisible
            text: qsTr("The activity section menu is visible")
            onCheckedChanged: {
                sectionVisible = checked;
            }
        }

        GCDialogCheckBox {
            id: exitConfirmationBox
            width: dialogConfig.contentWidth
            checked: exitConfirmation
            text: qsTr("Ask for confirmation to exit")
            visible: ApplicationInfo.isMobile ? false : true
            onCheckedChanged: {
                exitConfirmation = checked;
            }
        }

        GCComboBox {
            id: fontBox
            model: fonts
            background: dialogActivityConfig
            label: qsTr("Font selector")
        }

        GCText {
            id: baseFontSizeText
            text: qsTr("Font size")
            width: dialogConfig.contentWidth
            fontSize: mediumSize
            wrapMode: Text.WordWrap
        }

        Flow {
            spacing: 5
            width: dialogConfig.contentWidth
            GCSlider {
                id: baseFontSizeSlider
                width: 250 * ApplicationInfo.ratio
                to: ApplicationSettings.baseFontSizeMax
                from: ApplicationSettings.baseFontSizeMin
                value: baseFontSize
                onValueChanged: ApplicationSettings.baseFontSize = value;
                wheelEnabled: false
            }
            GCButton {
                height: 30 * ApplicationInfo.ratio
                text: qsTr("Default");
                onClicked: baseFontSizeSlider.value = 0.0
            }
        }

        GCComboBox {
            id: fontCapitalizationBox
            model: fontCapitalizationModel
            background: dialogActivityConfig
            label: qsTr("Font Capitalization")
        }

        GCText {
            id: fontLetterSpacingText
            text: qsTr("Font letter spacing")
            fontSize: mediumSize
            width: dialogConfig.contentWidth
            wrapMode: Text.WordWrap
        }

        Flow {
            spacing: 5
            width: dialogConfig.contentWidth
            GCSlider {
                id: fontLetterSpacingSlider
                width: 250 * ApplicationInfo.ratio
                to: ApplicationSettings.fontLetterSpacingMax
                from: ApplicationSettings.fontLetterSpacingMin
                value: fontLetterSpacing
                onValueChanged: ApplicationSettings.fontLetterSpacing = value;
                wheelEnabled: false
            }
            GCButton {
                height: 30 * ApplicationInfo.ratio
                text: qsTr("Default");
                onClicked: fontLetterSpacingSlider.value = ApplicationSettings.fontLetterSpacingMin
            }
        }
    }

    property bool isAudioVoicesEnabled: ApplicationSettings.isAudioVoicesEnabled
    property bool isAudioEffectsEnabled: ApplicationSettings.isAudioEffectsEnabled
    property bool isBackgroundMusicEnabled: ApplicationSettings.isBackgroundMusicEnabled
    property bool isFullscreen: ApplicationSettings.isFullscreen
    property bool isVirtualKeyboard: ApplicationSettings.isVirtualKeyboard
    property bool isAutomaticDownloadsEnabled: ApplicationSettings.isAutomaticDownloadsEnabled
    property bool sectionVisible: ApplicationSettings.sectionVisible
    property bool exitConfirmation: ApplicationSettings.exitConfirmation
    property string wordset: ApplicationSettings.wordset
    property bool useWordset: ApplicationSettings.useWordset
    property var filteredBackgroundMusic: ApplicationSettings.filteredBackgroundMusic
    property var allBackgroundMusic: ApplicationInfo.getBackgroundMusicFromRcc()
    property int baseFontSize  // don't bind to ApplicationSettings.baseFontSize
    property real fontLetterSpacing // don't bind to ApplicationSettings.fontLetterSpacing
    // or we get a binding loop warning
    property real backgroundMusicVolume
    property real audioEffectsVolume

    function extractMusicNameFromPath(musicPath) {
        var musicDirectoryPath = ApplicationInfo.getAudioFilePath("backgroundMusic/")
        var musicName = String(musicPath)
        musicName = musicName.slice(musicDirectoryPath.length, musicName.length)
        return musicName.slice(0, musicName.lastIndexOf('.'))
    }

    function loadFromConfig() {
        // Synchronize settings with data
        isAudioVoicesEnabled = ApplicationSettings.isAudioVoicesEnabled
        enableAudioVoicesBox.checked = isAudioVoicesEnabled

        isAudioEffectsEnabled = ApplicationSettings.isAudioEffectsEnabled
        enableAudioEffectsBox.checked = isAudioEffectsEnabled

        isBackgroundMusicEnabled = ApplicationSettings.isBackgroundMusicEnabled
        enableBackgroundMusicBox.checked = isBackgroundMusicEnabled

        isFullscreen = ApplicationSettings.isFullscreen
        enableFullscreenBox.checked = isFullscreen

        isVirtualKeyboard = ApplicationSettings.isVirtualKeyboard
        enableVirtualKeyboardBox.checked = isVirtualKeyboard

        isAutomaticDownloadsEnabled = ApplicationSettings.isAutomaticDownloadsEnabled
        enableAutomaticDownloadsBox.checked = isAutomaticDownloadsEnabled

        filterRepeater.minFilter = ApplicationSettings.filterLevelMin
        filterRepeater.maxFilter = ApplicationSettings.filterLevelMax

        sectionVisible = ApplicationSettings.sectionVisible
        sectionVisibleBox.checked = sectionVisible

        exitConfirmation = ApplicationSettings.exitConfirmation
        exitConfirmationBox.checked = exitConfirmation

        wordset = useWordset ? ApplicationSettings.wordset : ""

        baseFontSize = ApplicationSettings.baseFontSize
        fontLetterSpacing = ApplicationSettings.fontLetterSpacing
        backgroundMusicVolume = ApplicationSettings.backgroundMusicVolume
        audioEffectsVolume = ApplicationSettings.audioEffectsVolume
        filteredBackgroundMusic = ApplicationSettings.filteredBackgroundMusic
        allBackgroundMusic = ApplicationInfo.getBackgroundMusicFromRcc()
        if(filteredBackgroundMusic.length === 0)
            filteredBackgroundMusic = allBackgroundMusic
        // Set locale
        for(var i = 0 ; i < dialogConfig.languages.length ; i ++) {
            if(dialogConfig.languages[i].locale === ApplicationSettings.locale) {
                languageBox.currentIndex = i;
                break;
            }
        }

        // Set font
        for(i = 0 ; i < fonts.count ; i ++) {
            if(fonts.get(i).text === ApplicationSettings.font) {
                fontBox.currentIndex = i;
                break;
            }
        }

        // Set font capitalization
        for(i = 0 ; i < fontCapitalizationModel.length ; i ++) {
            if(fontCapitalizationModel[i].value === ApplicationSettings.fontCapitalization) {
                fontCapitalizationBox.currentIndex = i;
                break;
            }
        }
    }

    function save() {
        ApplicationSettings.isAudioVoicesEnabled = isAudioVoicesEnabled
        ApplicationSettings.isAudioEffectsEnabled = isAudioEffectsEnabled
        ApplicationSettings.isBackgroundMusicEnabled = isBackgroundMusicEnabled
        ApplicationSettings.filteredBackgroundMusic = filteredBackgroundMusic
        ApplicationSettings.isFullscreen = isFullscreen
        ApplicationSettings.isVirtualKeyboard = isVirtualKeyboard
        ApplicationSettings.isAutomaticDownloadsEnabled = isAutomaticDownloadsEnabled
        ApplicationSettings.sectionVisible = sectionVisible
        ApplicationSettings.exitConfirmation = exitConfirmation
        ApplicationSettings.wordset = wordset
        ApplicationSettings.useWordset = useWordset
        ApplicationSettings.isEmbeddedFont = fonts.get(fontBox.currentIndex).isLocalResource;
        ApplicationSettings.font = fonts.get(fontBox.currentIndex).text
        ApplicationSettings.fontCapitalization = fontCapitalizationModel[fontCapitalizationBox.currentIndex].value

        if(ApplicationSettings.filterLevelMin !== filterRepeater.minFilter ||
           ApplicationSettings.filterLevelMax !== filterRepeater.maxFilter) {
               ApplicationSettings.filterLevelMin = filterRepeater.minFilter
               ApplicationSettings.filterLevelMax = filterRepeater.maxFilter
               ActivityInfoTree.minMaxFiltersChanged(filterRepeater.minFilter, filterRepeater.maxFilter)
        }

        ApplicationSettings.saveBaseFontSize();
        ApplicationSettings.notifyFontLetterSpacingChanged();

        if (ApplicationSettings.locale !== dialogConfig.languages[languageBox.currentIndex].locale) {
            ApplicationSettings.locale = dialogConfig.languages[languageBox.currentIndex].locale
            if(ApplicationInfo.isDownloadAllowed && !DownloadManager.isDataRegistered(
                        "voices-" + ApplicationInfo.CompressedAudio + "/" +
                        ApplicationInfo.getVoicesLocale(dialogConfig.languages[languageBox.currentIndex].locale)
                        ))
            {
                // ask for downloading new voices
                parentActivity.newVoicesSignal();
            } else {
                // check for updates or/and register new voices
                DownloadManager.updateResource(
                            DownloadManager.getVoicesResourceForLocale(ApplicationSettings.locale))
            }
        }
    }

    ListModel {
        id: fonts
        Component.onCompleted: {
            var systemFonts = Qt.fontFamilies();
            var rccFonts = ApplicationInfo.getFontsFromRcc();

            // Remove explicitly all *symbol* and *ding* fonts
            var excludedFonts = ApplicationInfo.getSystemExcludedFonts();
            excludedFonts.push("ding");
            excludedFonts.push("symbol");

            // first display fonts from rcc
            for(var i = 0 ; i < rccFonts.length ; ++ i) {
                // Append fonts from resources
                fonts.append({ "text": rccFonts[i], "isLocalResource": true });
            }

            for(i = 0 ; i < systemFonts.length ; ++ i) {
                var isExcluded = false;
                var systemFont = systemFonts[i].toLowerCase();
                // Remove symbol fonts
                for(var j = 0 ; j < excludedFonts.length ; ++ j) {
                    if(systemFont.indexOf(excludedFonts[j].toLowerCase()) !== -1) {
                        isExcluded = true;
                        break;
                    }
                }

                // Remove fonts from rcc (if you have a default font from rcc, Qt will add it to systemFonts)
                for(j = 0 ; j < rccFonts.length ; ++ j) {
                    if(rccFonts[j].toLowerCase().indexOf(systemFont) !== -1) {
                        isExcluded = true;
                        break;
                    }
                }

                // Finally, we know if we add this font or not
                if(!isExcluded) {
                    fonts.append({ "text": systemFonts[i], "isLocalResource": false });
                }
            }
        }
    }

    property var fontCapitalizationModel: [
        { text: qsTr("Mixed case (default)"), value: Font.MixedCase },
        { text: qsTr("All uppercase"), value: Font.AllUppercase },
        { text: qsTr("All lowercase"), value: Font.AllLowercase }
    ]

    function isFilteredBackgroundMusicChanged() {
        initialFilteredMusic = ApplicationSettings.filteredBackgroundMusic
        if(initialFilteredMusic.length !== filteredBackgroundMusic.length)
            return true
        for(var i = 0; i < initialFilteredMusic.length; i++)
            if(filteredBackgroundMusic.indexOf(initialFilteredMusic[i]) === -1)
                return true

        return false
    }

    function hasConfigChanged() {
        return (ApplicationSettings.locale !== dialogConfig.languages[languageBox.currentIndex].locale ||
        (ApplicationSettings.sectionVisible != sectionVisible) ||
        (ApplicationSettings.exitConfirmation != exitConfirmation) ||
        (ApplicationSettings.wordset != wordset) ||
        (ApplicationSettings.useWordset != useWordset) ||
        (ApplicationSettings.font = fonts.get(fontBox.currentIndex).text) ||
        (ApplicationSettings.isEmbeddedFont !== fonts.get(fontBox.currentIndex).isLocalResource) ||
        (ApplicationSettings.isEmbeddedFont !== fonts.get(fontBox.currentIndex).isLocalResource) ||
        (ApplicationSettings.fontCapitalization !== fontCapitalizationModel[(fontcapitalizationBox.currentIndex)].value) ||
        (ApplicationSettings.fontLetterSpacing != fontLetterSpacing) ||
        (ApplicationSettings.isAudioVoicesEnabled != isAudioVoicesEnabled) ||
        (ApplicationSettings.isAudioEffectsEnabled != isAudioEffectsEnabled) ||
        (ApplicationSettings.isBackgroundMusicEnabled != isBackgroundMusicEnabled) ||
        (ApplicationSettings.isFullscreen != isFullscreen) ||
        (ApplicationSettings.isVirtualKeyboard != isVirtualKeyboard) ||
        (ApplicationSettings.isAutomaticDownloadsEnabled != isAutomaticDownloadsEnabled) ||
        (ApplicationSettings.baseFontSize != baseFontSize) ||
        isFilteredBackgroundMusicChanged()
        );
    }
}
