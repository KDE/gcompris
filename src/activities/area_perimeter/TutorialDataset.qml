/* GCompris - TutorialDataset.qml
 *
 * SPDX-FileCopyrightText: 2026 Johnny Jazeix
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../polygons/polygons.js" as Activity

QtObject {
    // tutorial levels
    property var tutorialLevels: [
        // level 1
        {
            introMessage: [
                qsTr("The perimeter is the length of all the lines of the shape."),
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/polygon.svg",
            instruction: qsTr("Draw a rectangle whose perimeter is 6."),
            validate: function() {
                // TODO validate it's a rectangle first
                Activity.computeSides();
                return (items.polygonSides[0] + items.polygonSides[1] + items.polygonSides[2] + items.polygonSides[3]) == 6;
            }
        },
        // level 2
        {
            introMessage: [],
            instruction: qsTr("What is the perimeter of this rectangle?"),
            disableDrawing: true,
            drawInitialShape: function(points) {
                var minX = 1;
                var maxX = 10;
                var firstX = Math.floor(minX + Math.random() * (maxX - minX));
                var firstY = Math.floor(minX + Math.random() * (maxX - minX));
                var lastX = Math.floor(minX + Math.random() * (maxX - minX));
                while (firstX == lastX) {
                    lastX = Math.floor(minX + Math.random() * (maxX - minX));
                }
                var lastY = Math.floor(minX + Math.random() * (maxX - minX));
                while (firstY == lastY) {
                    lastY = Math.floor(minX + Math.random() * (maxX - minX));
                }
                points.append({"x": firstX,"y": firstY });
                points.append({"x": firstX,"y": lastY });
                points.append({"x": lastX,"y": lastY });
                points.append({"x": lastX,"y": firstY });
                points.append({"x": firstX,"y": firstY });
            },
            validate: function() {
                Activity.computeSides();
                return Activity.inputAnswer == (items.polygonSides[0] + items.polygonSides[1]) * 2;
            }
        },
        // level 3
        {
            introMessage: [
                qsTr("The area is the surface taken by the shape."),
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/polygon.svg",
            instruction: qsTr("Draw a rectangle whose area is 6."),
            validate: function() {
                // TODO validate it's a rectangle first
                Activity.computeSides();
                return (items.polygonSides[0] * items.polygonSides[1]) == 6;
            }
        },
        // level 4
        {
            introMessage: [],
            instruction: qsTr("What is the area of this rectangle?"),
            drawInitialShape: function(points) {
                var minX = 1;
                var maxX = 10;
                var firstX = Math.floor(minX + Math.random() * (maxX - minX));
                var firstY = Math.floor(minX + Math.random() * (maxX - minX));
                var lastX = Math.floor(minX + Math.random() * (maxX - minX));
                while (firstX == lastX) {
                    lastX = Math.floor(minX + Math.random() * (maxX - minX));
                }
                var lastY = Math.floor(minX + Math.random() * (maxX - minX));
                while (firstY == lastY) {
                    lastY = Math.floor(minX + Math.random() * (maxX - minX));
                }
                points.append({"x": firstX,"y": firstY });
                points.append({"x": firstX,"y": lastY });
                points.append({"x": lastX,"y": lastY });
                points.append({"x": lastX,"y": firstY });
                points.append({"x": firstX,"y": firstY });
            },
            disableDrawing: true,
            validate: function() {
                Activity.computeSides();
                return Activity.inputAnswer == (items.polygonSides[0] * items.polygonSides[1]);
            }
        }
    ]
}
