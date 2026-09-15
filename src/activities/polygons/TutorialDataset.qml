/* GCompris - TutorialDataset.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "polygons.js" as Activity

QtObject {
    // tutorial levels. NOTE: the last line of introMessage must be a short sentence telling the shape to draw, as it will be reused on the overlay message.
    property var tutorialLevels: [
        // level 1
        {
            introMessage: [
                qsTr("A polygon is a closed shape made of connected lines."),
                qsTr("To draw a polygon, click on the grid to place the ends of the polygon's lines, then click the first point to close the shape."),
                qsTr("Draw any polygon.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/polygon.svg",
            validate: function() {
                return true;
            }
        },
        // level 2
        {
            introMessage: [
                qsTr("A triangle is a polygon with 3 sides."),
                qsTr("Draw any triangle.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/triangle.svg",
            validate: function() {
                if(items.points.count - 1 === 3) {
                    return true;
                }
                return false;
            }
        },
        // level 3
        {
            introMessage: [
                qsTr("A right triangle is a triangle in which two sides are perpendicular, forming a right angle (90 degrees)."),
                qsTr("Draw a right triangle.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/triangle-right.svg",
            validate: function() {
                if(items.points.count - 1 === 3) {
                    Activity.computeAngles();
                    if(items.polygonAngles.indexOf(90) != -1) {
                        return true;
                    }
                }
                return false;
            }
        },
        // level 4
        {
            introMessage: [
                qsTr("An isosceles triangle is a triangle that has two sides of equal length and two angles of equal measure.."),
                qsTr("Draw an isosceles triangle.")
            ],
            introImage: "qrc:/gcompris/src/activities/polygons/resource/triangle-isosceles.svg",
            validate: function() {
                if(items.points.count - 1 === 3) {
                    Activity.computeAngles();
                    for(var i = 0; i < items.polygonAngles.length; i++) {
                        var angle = items.polygonAngles[i];
                        for(var j = i + 1; j < items.polygonAngles.length; j++) {
                            if(items.polygonAngles[j] === angle) {
                                return true;
                            }
                        }
                    }
                }
                return false;
            }
        }
    ]
}


/*
 Draw the following form, a line will be drawn with the previous point.
 When you reach again the first point, the figure will be finished.

 Examples:
 - draw a triangle
 - draw a right triangle
 - draw an isoceles triangle which is not a rectangle triangle
 - draw a square
 - draw a rectangle that is not a square
 - draw a losange which is not a square
 - draw a parallelogram which is not a square

 */
