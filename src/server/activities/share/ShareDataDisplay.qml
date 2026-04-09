/* GCompris - ShareDataDisplay.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *  Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
pragma ComponentBehavior: Bound
import QtQuick
import "../../components"
import "../../singletons"

Item {
    id: lineItem
    required property var jsonData
    height: details.height

    Column {
        id: details

        Item {
            // top spacer
            height: Style.margins
            width: 1
        }

        DefaultLabel {
            font.pixelSize: Style.textSize
            height: contentHeight + Style.smallMargins
            width: lineItem.width - Style.bigMargins
            elide: Text.ElideNone
            wrapMode: Text.Wrap
            verticalAlignment: Text.AlignTop
            text: lineItem.jsonData.instruction
        }

        Row {
            spacing: Style.margins

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Number of candies:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: lineItem.jsonData.totalCandies
                }
            }
        }

        Row {
            spacing: Style.margins
            visible: lineItem.jsonData.totalGirls > 0

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Placed girls:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    //: Display a fraction
                    text: qsTr("%1 / %2").arg(lineItem.jsonData.girlsPlaced).arg(lineItem.jsonData.totalGirls)
                }
            }

            ResultIndicator {
                resultSuccess: lineItem.jsonData.girlsPlaced === lineItem.jsonData.totalGirls
            }
        }

        Row {
            spacing: Style.margins
            visible: lineItem.jsonData.totalBoys > 0

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Placed boys:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    //: Display a fraction
                    text: qsTr("%1 / %2").arg(lineItem.jsonData.boysPlaced).arg(lineItem.jsonData.totalBoys)
                }
            }

            ResultIndicator {
                resultSuccess: lineItem.jsonData.boysPlaced === lineItem.jsonData.totalBoys
            }
        }

        Row {
            spacing: Style.margins

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Expected candies per child:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: lineItem.jsonData.expectedShare
                }
            }
        }

        Row {
            spacing: Style.margins
            visible: lineItem.jsonData.girlsPlaced > 0

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Candies for girls:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: lineItem.jsonData.candiesInGirls.join(", ")
                }
            }

            ResultIndicator {
                resultSuccess: lineItem.jsonData.candiesInGirls.length === lineItem.jsonData.totalGirls &&
                    lineItem.jsonData.candiesInGirls.every(value => value === lineItem.jsonData.expectedShare)
            }
        }

        Row {
            spacing: Style.margins
            visible: lineItem.jsonData.boysPlaced > 0

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Candies for boys:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: lineItem.jsonData.candiesInBoys.join(", ")
                }
            }

            ResultIndicator {
                resultSuccess: lineItem.jsonData.candiesInBoys.length === lineItem.jsonData.totalBoys && lineItem.jsonData.candiesInBoys.every(value => value === lineItem.jsonData.expectedShare)
            }
        }

        Row {
            spacing: Style.margins

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Jar placed:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    text: lineItem.jsonData.basketPlaced ? qsTr("Yes") : qsTr("No")
                }
            }
        }


        Row {
            spacing: Style.margins
            visible: lineItem.jsonData.basketPlaced

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    text: qsTr("Candies in the jar:")
                }
            }

            Item {
                height: Style.lineHeight
                width: childrenRect.width

                DefaultLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    //: Display a fraction
                    text: qsTr("%1 / %2").arg(lineItem.jsonData.candiesInBasket).arg(lineItem.jsonData.expectedRest)
                }
            }

            ResultIndicator {
                resultSuccess: lineItem.jsonData.candiesInBasket === lineItem.jsonData.expectedRest
            }
        }
    }
}
