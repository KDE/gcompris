/* GCompris - MasseArea.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Effects

import "../../core"
import "scalesboard.js" as Activity

Rectangle {
    id: masseArea
    height: itemWidth * 1.37
    color: dropArea.containsDrag ? "#33333333" : "#00000000"
    border.width: 2
    border.color: dropArea.containsDrag ? "#33666666" : "#00000000"

    property bool dropEnabled: true
    property bool dropEnabledForThisLevel: true
    property int nbColumns
    property int itemWidth: (width - masseFlow.spacing * (nbColumns - 1)) / nbColumns

    property Item masseAreaCenter
    property Item masseAreaLeft
    property Item masseAreaRight

    property alias masseModel: masseModel
    property alias dropArea: dropArea

    property int weight: 0


    function init() {
        weight = 0
        masseModel.clear()
    }

    function removeWeight(value) {
        weight -= value
    }

    function removeMasse(masseArea, index, weight) {
        masseArea.removeWeight(weight)
        masseArea.masseModel.remove(index)
    }

    /* weight is the absolute weight
     * text is the text being displayed on the masseAreaCenter
     */
    function addMasse(img, weight, text, index, dragEnabled) {
        masseModel.append( {
                              img: img,
                              weight: weight,
                              text: text,
                              masseIndex: index,
                              opacity: 1.0,
                              dragEnabled: dragEnabled
                          } )
        masseArea.weight += weight
    }

    function setAllZonesDropEnabled(enabled) {
        masseAreaCenter.dropEnabled = enabled
        masseAreaLeft.dropEnabled = enabled
        masseAreaRight.dropEnabled = enabled
    }

    function showMasseInMasseArea(index) {
        masseAreaCenter.masseModel.get(index).opacity = 1.0
    }

    function hideMasseInMasseArea(index) {
        masseAreaCenter.masseModel.get(index).opacity = 0.0
    }

    ListModel {
        id: masseModel

        function contains(masseIndex) {
            for(var i = 0; i < masseModel.count; i++) {
                if(masseModel.get(i).masseIndex == masseIndex) {
                    return masseModel.get(i).opacity == 1
                }
            }
            return false;
        }
    }

    DropArea {
        id: dropArea
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        height: parent.height * 2
        enabled: dropEnabledForThisLevel && dropEnabled
    }

    Flow {
        id: masseFlow
        anchors.fill: parent
        spacing: GCStyle.halfMargins

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: parent.width * 0.05
                easing.type: Easing.InOutQuad
            }
        }

        move: Transition {
            NumberAnimation {
                properties: "x,y"
                easing.type: Easing.InOutQuad
            }
        }

        Repeater {
            id: answer
            model: masseModel
            Image {
                source: Activity.url + img
                sourceSize.width: masseArea.itemWidth
                opacity: model.opacity

                property string img: model.img
                property int masseIndex: model.masseIndex
                property int modelIndex: index
                property int weight: model.weight
                property string text: model.text
                property int masseOriginX
                property int masseOriginY
                property int originX
                property int originY
                property Item currentMasseArea: masseArea

                Drag.active: dragArea.drag.active
                Drag.hotSpot.x: width * 0.5
                Drag.hotSpot.y: height * 0.5

                function initDrag() {
                    originX = x
                    originY = y
                    if(currentMasseArea == masseArea) {
                        masseOriginX = x
                        masseOriginY = y
                    }
                    z = 111
                }

                function replace() {
                    x = originX
                    y = originY
                }

                function replaceInMasse() {
                    x = masseOriginX
                    y = masseOriginY
                }

                onOpacityChanged: opacity == 1.0 ? currentMasseArea = masseAreaCenter : null

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: parent
                    enabled: model.dragEnabled && !items.buttonsBlocked

                    onPressed: {
                        if(masseModel.contains(parent.masseIndex)) {
                            parent.initDrag()
                        }
                        else {
                            setAllZonesDropEnabled(false)
                        }
                    }

                    function dropOnPlate(masseArea) {
                        parent.Drag.cancel()
                        if(parent.currentMasseArea == masseAreaCenter) {
                            masseArea.hideMasseInMasseArea(parent.masseIndex)
                            parent.replaceInMasse()
                        }
                        masseArea.addMasse(parent.img,
                                           parent.weight,
                                           parent.text,
                                           parent.masseIndex,
                                           /* dragEnabled */ true)
                        if(parent.currentMasseArea != masseAreaCenter) {
                            removeMasse(parent.currentMasseArea,
                                        parent.modelIndex, parent.weight)
                        }

                        parent.currentMasseArea = masseArea
                    }

                    onReleased: {
                        setAllZonesDropEnabled(true)
                        items.metalSound.play()
                        if(masseAreaLeft.dropArea.containsDrag &&
                           parent.currentMasseArea != masseAreaLeft) {
                            dropOnPlate(masseAreaLeft)
                        } else if (masseAreaRight.dropArea.containsDrag &&
                                   parent.currentMasseArea != masseAreaRight) {
                            dropOnPlate(masseAreaRight)
                        } else if (masseAreaCenter.dropArea.containsDrag &&
                                   parent.dropArea != masseAreaCenter) {
                            parent.Drag.cancel()
                            masseAreaCenter.showMasseInMasseArea(parent.masseIndex)
                            parent.replaceInMasse()
                            if(parent.currentMasseArea != masseAreaCenter) {
                                removeMasse(parent.currentMasseArea,
                                            parent.modelIndex, parent.weight)
                            }
                        } else {
                            parent.Drag.cancel()
                            parent.replace()
                        }

                    }
                }

                GCText {
                    id: text
                    anchors.fill: parent
                    anchors.topMargin: parent.height * 0.5
                    text: model.text
                    color: GCStyle.whiteText
                    fontSizeMode: Text.Fit
                    minimumPointSize: 8
                    fontSize: largeSize
                    font.bold : true
                    style: Text.Outline
                    styleColor: GCStyle.darkText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MultiEffect {
                    anchors.fill: text
                    source: text
                    shadowEnabled: true
                    shadowBlur: 1.0
                    blurMax: 16
                    shadowHorizontalOffset: 3
                    shadowVerticalOffset: 3
                    shadowOpacity: 0.5
                }
            }

        }
    }

    Behavior on y {
        NumberAnimation {
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }

}
