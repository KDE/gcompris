/* GCompris - ShareEditor.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../../singletons"
import "../../components"
import ".."
DatasetEditorBase {
    id: editor
    required property string textActivityData               // Json array stringified as stored in database (dataset_/dataset_content)
    property ListModel mainModel: ({})                      // The main ListModel, declared as a property for dynamic creation
    readonly property var prototypeStack: [ mainPrototype, subPrototype ]   // A stack of two prototypes

    teacherInstructions: ("<b>") + qsTr("Rules to create a valid dataset:") + ("</b><br><ul><li>") +

    qsTr("In general, there can not be more than 6 children, and 6 candies per child.") + ("</li></ul><ul><li>") +

    qsTr('If "Random numbers" is selected, the number of already placed candies per child must be defined such that not all candies are already placed.') + ("</li></ul><ul><li>") +

    qsTr('The "Instruction" field allows to give a specific instruction for each sublevel. If it is empty, a default instruction text is used.') + ("</li></ul>")

    ListModel {
        id: mainPrototype
        property bool multiple: true
        ListElement { name: "shuffle";      label: qsTr("Shuffle");     type: "boolean";    def: "false" }
        ListElement { name: "subLevels";    label: qsTr("Sublevels");   type: "model";      def: "[]" }
    }

    ListModel {
        id: subPrototype
        property bool multiple: true
        ListElement { name: "randomisedInputData";  label: qsTr("Random numbers");       type: "boolean";        def: "false" }
        // We can display max 6 children, and max 6 candies per child, so limit and validate values accordingly.

        // Elements for not Random numbers
        ListElement { name: "totalGirls"; label: qsTr("Number of girls"); type: "boundedDecimal"; def: "1"; decimalRange :'[0,6]' ; stepSize: 1 ; decimals: 0 }
        ListElement { name: "totalBoys"; label: qsTr("Number of boys"); type: "boundedDecimal"; def: "1"; decimalRange :'[0,6]' ; stepSize: 1 ; decimals: 0 }
        ListElement { name: "totalCandies"; label: qsTr("Number of candies"); type: "boundedDecimal"; def: "2"; decimalRange :'[2,36]' ; stepSize: 1 ; decimals: 0 }
        ListElement { name: "placedInGirls"; label: qsTr("Candies already placed per girl"); type: "boundedDecimal"; def: "0" ; decimalRange :'[0,5]' ; stepSize: 1  ; decimals: 0 }
        ListElement { name: "placedInBoys"; label: qsTr("Candies already placed per boy"); type: "boundedDecimal"; def: "0"; decimalRange :'[0,5]' ; stepSize: 1 ; decimals: 0 }
        ListElement { name: "forceShowBasket";  label: qsTr("Force showing the jar");       type: "boolean";        def: "false" }

        // Elements for Random numbers
        ListElement { name: "maxGirls"; label: qsTr("Maximum number of girls"); type: "boundedDecimal"; def: "1"; decimalRange :'[1,5]' ; stepSize: 1 ; decimals: 0 }
        ListElement { name: "maxBoys"; label: qsTr("Maximum number of boys"); type: "boundedDecimal"; def: "1"; decimalRange :'[1,5]' ; stepSize: 1 ; decimals: 0 }
        ListElement { name: "maxCandies"; label: qsTr("Maximum number of candies"); type: "boundedDecimal"; def: "2"; decimalRange :'[2,36]' ; stepSize: 1 ; decimals: 0 }
        ListElement { name: "alreadyPlaced";  label: qsTr("Already place some candies");       type: "boolean";        def: "false" }

        // Common element
        ListElement { name: "instruction";   label: qsTr("Instruction");    type: "string";  def: "" }
    }

    StyledSplitView {
        anchors.fill: parent

        EditorBox {
            id: levelEditor
            SplitView.minimumWidth: levelEditor.minWidth
            SplitView.preferredWidth: editor.width * 0.2
            SplitView.fillHeight: true
            editorPrototype: mainPrototype
            editorModel: editor.mainModel

            fieldsComponent: Component {
                Column {
                    // Properties required by FieldEdit. Must be in the parent
                    property ListModel currentPrototype: levelEditor.editorPrototype
                    property ListModel currentModel: levelEditor.editorModel
                    property int modelIndex: parent.index
                    x: Style.margins
                    y: Style.margins
                    spacing: Style.smallMargins
                    FieldEdit { name: "shuffle" }
                    FieldEdit { name: "subLevels" }
                }
            }

            onCurrentChanged: {
                subLevelEditor.current = -1;
                if(current > -1 && current < editorModel.count) {
                    subLevelEditor.editorModel = editor.mainModel.get(levelEditor.current).subLevels;
                } else {
                    subLevelEditor.editorModel = null;
                }
            }
        }

        EditorBox {
            id: subLevelEditor
            SplitView.minimumWidth: subLevelEditor.minWidth
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            editorPrototype: subPrototype
            editorModel: null // set in levelEditor onCurrentChanged

            toolBarEnabled: levelEditor.current != -1

            fieldsComponent: Component {
                Column {
                    id: fieldsColumn
                    // Properties required by FieldEdit. Must be in the parent
                    property ListModel currentPrototype: subLevelEditor.editorPrototype
                    property ListModel currentModel: subLevelEditor.editorModel
                    property int modelIndex: parent.index
                    x: Style.margins
                    y: Style.margins
                    spacing: Style.smallMargins

                    readonly property bool randomMode: currentModel && currentModel.get(fieldsColumn.modelIndex) ?
                    currentModel.get(fieldsColumn.modelIndex).randomisedInputData : false

                    // init with default values
                    property int totalGirls: 1
                    property int totalBoys: 1
                    property int totalCandies: 2

                    property int maxGirls: 1
                    property int maxBoys: 1
                    property int maxCandies: 2

                    function clampTotalBoys() {
                        if(totalGirls + totalBoys > 6) {
                            totalBoys = 6 - totalGirls;
                            totalBoysField.value = totalBoys.toString();
                        }
                    }

                    function clampTotalGirls() {
                        if(totalGirls + totalBoys > 6) {
                            totalGirls = 6 - totalBoys;
                            totalGirlsField.value = totalGirls.toString();
                        }
                    }

                    function clampTotalCandies() {
                        var minCandies = totalGirls + totalBoys;
                        var maxAllowedCandies = 6 * (minCandies + 1);
                        if(totalCandies > maxAllowedCandies) {
                            totalCandies = maxAllowedCandies;
                            totalCandiesField.value = totalCandies.toString();
                        } else if(totalCandies < minCandies) {
                            totalCandies = minCandies;
                            totalCandiesField.value = totalCandies.toString();
                        }
                    }

                    function clampMaxBoys() {
                        if(maxGirls + maxBoys > 6) {
                            maxBoys = 6 - maxGirls;
                            maxBoysField.value = maxBoys.toString();
                        }
                    }

                    function clampMaxGirls() {
                        if(maxGirls + maxBoys > 6) {
                            maxGirls = 6 - maxBoys;
                            maxGirlsField.value = maxGirls.toString();
                        }
                    }

                    function clampMaxCandies() {
                        var minCandies = maxGirls + maxBoys;
                        var maxAllowedCandies = 6 * (minCandies + 1);
                        if(maxCandies > maxAllowedCandies) {
                            maxCandies = maxAllowedCandies;
                            maxCandiesField.value = maxCandies.toString();
                        } else if(maxCandies < minCandies) {
                            maxCandies = minCandies;
                            maxCandiesField.value = maxCandies.toString();
                        }
                    }

                    FieldEdit { name: "randomisedInputData" }

                    // Fields for not random mode

                    // Auto-clamped
                    FieldEdit {
                        id: totalGirlsField
                        name: "totalGirls"
                        visible: !fieldsColumn.randomMode
                        onValueModified: {
                            fieldsColumn.totalGirls = parseInt(value);
                            fieldsColumn.clampTotalBoys();
                            fieldsColumn.clampTotalCandies();
                        }
                    }
                    // Auto-clamped
                    FieldEdit {
                        id: totalBoysField
                        name: "totalBoys"
                        visible: !fieldsColumn.randomMode
                        onValueModified: {
                            fieldsColumn.totalBoys = parseInt(value);
                            fieldsColumn.clampTotalGirls();
                            fieldsColumn.clampTotalCandies();
                        }
                    }
                    // Auto-clamped
                    FieldEdit {
                        id: totalCandiesField
                        name: "totalCandies"
                        visible: !fieldsColumn.randomMode
                        onValueModified: {
                            fieldsColumn.totalCandies = parseInt(value);
                            fieldsColumn.clampTotalCandies();
                        }
                    }
                    // Checked in validateDataset
                    FieldEdit {
                        id: placedInGirlsField
                        name: "placedInGirls"
                        visible: !fieldsColumn.randomMode
                    }
                    // Checked in validateDataset
                    FieldEdit {
                        id: placedInBoysField
                        name: "placedInBoys"
                        visible: !fieldsColumn.randomMode
                    }
                    FieldEdit {
                        name: "forceShowBasket"
                        visible: !fieldsColumn.randomMode
                    }

                    // Fields for random mode

                    // Auto-clamped
                    FieldEdit {
                        id: maxGirlsField
                        name: "maxGirls"
                        visible: fieldsColumn.randomMode
                        onValueModified: {
                            fieldsColumn.maxGirls = parseInt(value);
                            fieldsColumn.clampMaxBoys();
                            fieldsColumn.clampMaxCandies();
                        }
                    }
                    // Auto-clamped
                    FieldEdit {
                        id: maxBoysField
                        name: "maxBoys"
                        visible: fieldsColumn.randomMode
                        onValueModified: {
                            fieldsColumn.maxBoys = parseInt(value);
                            fieldsColumn.clampMaxGirls();
                            fieldsColumn.clampMaxCandies();
                        }
                    }
                    // Auto-clamped
                    FieldEdit {
                        id: maxCandiesField
                        name: "maxCandies"
                        visible: fieldsColumn.randomMode
                        onValueModified: {
                            fieldsColumn.maxCandies = parseInt(value);
                            fieldsColumn.clampMaxCandies();
                        }
                    }
                    FieldEdit {
                        name: "alreadyPlaced"
                        visible: fieldsColumn.randomMode
                    }

                    FieldEdit {
                        name: "instruction"
                        maxWidth: subLevelEditor.maxWidth
                    }
                }
            }
        }
    }

    function validateDataset() {
        var isValid = true;
        var globalError = "";
        var textError = "";
        var currentDataset = editor.mainModel.get(0);
        //check if dataset is not empty
        if(!currentDataset) {
            globalError = ("<ul><li>") + qsTr('Dataset is empty.') + ("</li></ul>");
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
            return false;
        }
        for(var datasetId = 0; datasetId < editor.mainModel.count; ++datasetId) {
            currentDataset = editor.mainModel.get(datasetId);
            var datasetQuestions = currentDataset.subLevels;
            if(datasetQuestions.count < 1) {
                isValid = false;
                textError = textError + ("<li>") + qsTr('Level %1 must not be empty.').arg(datasetId+1) + ("</li>");
            } else {
                for(var sublevelId = 0; sublevelId < datasetQuestions.count; ++sublevelId) {
                    var sublevel = datasetQuestions.get(sublevelId);
                    if(!sublevel.randomisedInputData) {
                        var totalGirls = parseInt(sublevel.totalGirls);
                        var totalBoys = parseInt(sublevel.totalBoys);
                        var totalChildren = totalGirls + totalBoys;
                        if(totalChildren === 0) {
                            isValid = false;
                            textError = textError + ("<li>") + qsTr('In Sublevel %2 of Level %1, the total number of children is 0.').arg(datasetId+1).arg(sublevelId+1) + ("</li>");
                        }
                        // Check that placedInGirls/Boys values do not place all the candies or more.
                        var totalCandies = parseInt(sublevel.totalCandies);
                        var totalPlacedIn = parseInt(sublevel.placedInGirls) * totalGirls + parseInt(sublevel.placedInBoys) * totalBoys;
                        var maxPlacedIn = totalCandies - totalChildren;
                        if(totalPlacedIn > maxPlacedIn) {
                            isValid = false;
                            textError = textError + ("<li>") + qsTr('In Sublevel %2 of Level %1, the number of already placed candies is too high.').arg(datasetId+1).arg(sublevelId+1) + ("</li>");
                        }
                    }
                }
            }
        }
        if(!isValid) {
            globalError = qsTr("The following errors need to be fixed:<ul>%1</ul>").arg(textError)
            instructionPanel.setInstructionText(false, globalError);
            instructionPanel.open();
        }
        return isValid;
    }

    Component.onCompleted: {
        mainModel = datasetEditor.jsonToListModel(prototypeStack, JSON.parse(textActivityData))
    }
}
