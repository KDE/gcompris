/* GCompris - TheCompass.qml
 *
 * SPDX-FileCopyrightText: 2026 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import "../../core"
import "compass.js" as Activity

Item {
    id: compass

    required property var drawingCanvas
    required property int tipPenInit
    required property var svgTank
    required property real viewSize
    required property real canvasScale

    readonly property real minTipPenDistance: 1

    // Properties saved in UndoStack
    property real compassAngle: 0    // Global compass orientation
    property color penColor: "black"
    property real penWidth: 2
    property real penOpacity: 1.0
    property point compassPen: Qt.point(0, 0)

    // Other properties
    property point compassTip: Qt.point(0, 0)
    property point hinge: apexIsosceles(compassTip, compassPen, legLength)
    property real tipPenDistance: {     // Avoid division by zero
        const dist = distance(compassTip, compassPen)
        return (dist < minTipPenDistance) ? minTipPenDistance : dist
    }
    property real dragZoneWidth: Math.max(parent.width / 10, penWidth)
    property real legLength: parent.width / 3
    property real legWidth: parent.width / 15
    property bool magnetism: true
    property int gridStep: 10

    property real tipPenAngle: pointsToDegrees(compassTip, compassPen) + 90     // Angle between tip and pen
    property int hingeAngle: Math.abs(penLegRotation.angle - tipLegRotation.angle) % 360        // Angle between two legs
    property point lastPoint: Qt.point(0, 0)
    property real degreesPerPixel: (tipPenDistance === minTipPenDistance) ? 1.0 : (360 / (tipPenDistance * 2 * Math.PI))  // Avoid division by zero

    width: parent.width
    height: parent.height
    readonly property int dragLimit: width * 0.5

    signal drawingCompleted()
    signal redrawCanvas(var savedFile)
    signal pushUndo()
    signal updateUndo()

    function initCompass() {
        x = y = 0
        compassTip = Qt.point(0, 0)
        compassPen = Qt.point(-tipPenInit, 0)
        compassAngle = 0
    }

    function logicalXor(a,b) {
      return ( a || b ) && !( a && b )
    }

    function distance(a, b) {   //  Distance between two points
        return Math.hypot(a.x - b.x, a.y - b.y)
    }

    function pointsToDegrees(a, b) {    // Angle between two points (returns degrees)
        var angle =  Math.atan2(b.x - a.x, b.y - a.y) * 180 / Math.PI
        if (angle < 0)
            angle += 360
        return angle
    }

    function apexIsosceles(a, b, maxLength) {
        var dist = distance(a, b)
        const angle = Math.atan2(b.y - a.y, b.x - a.x)
        if (2 * maxLength < dist)   // Impossible isosceles triangle
            dist = 2 * maxLength
        const triangleHeight = Math.sqrt(maxLength * maxLength - (dist / 2) * (dist / 2))
        const rightAngle = angle + Math.PI / 2
        const apexX = (a.x + b.x) / 2 + triangleHeight * Math.cos(rightAngle)
        const apexY = (a.y + b.y) / 2 + triangleHeight * Math.sin(rightAngle)
        return Qt.point(apexX, apexY)
    }

    function getPenPosition(angle) {
        angle = angle - tipPenAngle
        return Qt.point((parent.width / 2) + compass.x - (tipPenDistance * Math.cos(angle * Math.PI / 180))
                      , (parent.height /2) + compass.y - (tipPenDistance * Math.sin(angle * Math.PI / 180)))
    }

    function magneticAlign(aPoint) {
        aPoint.x = Math.round(aPoint.x / compass.gridStep) * compass.gridStep
        aPoint.y = Math.round(aPoint.y / compass.gridStep) * compass.gridStep
    }

    Item {
        id: tipPoint
        width: 0
        height: 0
        x: (parent.width * 0.5)
        y: (parent.height * 0.5)

        property point globalTipPosition: Qt.point(0, 0)

        transform: [
            Rotation {
                origin.x: 0
                origin.y: 0
                angle: compassAngle
            }
        ]

        Rectangle {
            x: -1
            y: -1
            width:  2
            height: 2
            radius: 2
            color: "black"
        }

        Image { // Tip leg, used to move whole compass and adjust tip position, doesn't draw
            id: tipLeg
            source: "qrc:/gcompris/src/activities/compass/resource/leg.svg"
            x: hinge.x - (width  * 0.5)
            y: hinge.y
            width: legWidth
            height: legLength
            sourceSize.width: legWidth * compass.canvasScale
            sourceSize.height: legLength * compass.canvasScale
            opacity: (tipLegArea.containsMouse || tipLegArea.dragging) ? 1.0 : 0.8
            transform: [
                Rotation {
                    id: tipLegRotation
                    origin.x: legWidth / 2
                    origin.y: 0
                    angle: (Math.atan2(-hinge.y, -hinge.x) * 180 / Math.PI) - 90
                }
            ]

            MouseArea {
                id: tipLegArea
                width: parent.width
                height: parent.height
                x: width * 0.5
                y: 0
                hoverEnabled: true
                drag.target: compass
                drag.axis: Drag.XAndYAxis
                drag.minimumX: -dragLimit
                drag.maximumX: dragLimit
                drag.minimumY: -dragLimit
                drag.maximumY: dragLimit

                property bool dragging: false

                onPressed: (mouse) => {
                    dragging = true;
                }

                onReleased: (mouse) => {
                    if (logicalXor(magnetism, mouse.modifiers & Qt.ControlModifier)) {
                        magneticAlign(compass);
                    }
                    dragging = false;
                }
            }
        }

        Item {
            id: penLeg
            x: tipLeg.x
            y: tipLeg.y
            transform: [
                Rotation {
                    id: penLegRotation
                    origin.x: legWidth / 2
                    origin.y: 0
                    angle: (Math.atan2(compassPen.y - hinge.y, compassPen.x - hinge.x) * 180 / Math.PI) - 90
                }
            ]

            Image {
                id: penLegImage
                source: "qrc:/gcompris/src/activities/compass/resource/leg.svg"
                mirror: true
                width: legWidth
                height: legLength
                sourceSize.width: tipLeg.sourceSize.width
                sourceSize.height: tipLeg.sourceSize.height
                opacity: penHandle.penHandleFocus ? 1.0 : 0.8

                MouseArea {
                    id: penLegArea
                    width: parent.width
                    height: parent.height
                    x: -width * 0.5
                    y: 0
                    hoverEnabled: true
                    drag.target: penHandleTarget

                    onPressed: (mouse) => {
                        penHandleTarget.pressedLogic(mouse);
                    }
                    onReleased: (mouse) => {
                        penHandleTarget.releasedLogic(mouse);
                    }
                    onPositionChanged: (mouse) => {
                        penHandleTarget.positionChangedLogic(mouse);
                    }
                }
            }

            Image { // Pencil, used to turn and/or draw without changing the compass width
                id: penImage
                source: "qrc:/gcompris/src/activities/compass/resource/pen.svg"
                x: (penLegImage.width - width) / 2
                y: penLegImage.height - height
                width: legWidth * 0.8
                height: width * 4
                sourceSize.width: width * compass.canvasScale
                sourceSize.height: height * compass.canvasScale
                opacity: (penImageArea.containsMouse || penImageArea.drawing) ? 1.0 : 0.8

                transform: [
                    Rotation {
                        origin.x: penImage.width / 2
                        origin.y: penImage.height
                        angle: -45
                    }
                ]

                MouseArea {
                    id: penImageArea
                    property bool dragging: false
                    property bool drawing: false
                    property real previousAngle: 0
                    property real minAngle: 0
                    property real maxAngle: 0
                    property real lastAngle: 0

                    anchors.centerIn: parent
                    width: parent.width * 2
                    height: parent.height + parent.width
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onPressed: (mouse) => {
                        updateUndo();   // Signal to undoStack to save pen changes since last image stacked
                        tipPoint.globalTipPosition = tipPoint.mapToGlobal(compass.compassTip);
                        previousAngle = pointsToDegrees(tipPoint.globalTipPosition, mapToGlobal(mouse.x, mouse.y));
                        if(mouse.button === Qt.LeftButton) {
                            drawing = true;
                        }
                        if(mouse.button === Qt.RightButton) {
                            dragging = true;
                        }
                        if(drawing) {
                            beginTrace();
                        }
                        mouse.accepted = true;
                    }

                    onReleased: (mouse) => {
                        if (drawing) {
                            endTrace()
                            pushUndo()  // Signal to undoStack
                        }
                        dragging = false
                        drawing = false
                        mouse.accepted = true
                    }

                    onPositionChanged: (mouse) => {
                        if (dragging || drawing) {
                            var angle = pointsToDegrees(tipPoint.globalTipPosition, mapToGlobal(mouse.x, mouse.y))
                            var delta = angle - previousAngle
                            if (delta > 300)        // Prevents the angle from turning the other way round.
                                delta -= 360
                            else if (delta < -300)
                                delta += 360
                            compassAngle -= delta
                            previousAngle = angle
                            if (drawing)
                                drawTrace()
                            mouse.accepted = true
                        }
                    }

                    function beginTrace() {
                        minAngle = maxAngle = compassAngle
                        lastPoint = getPenPosition(compassAngle)
                        lastAngle = compassAngle
                        drawingCanvas.ctx.strokeStyle = compass.penColor
                        drawingCanvas.ctx.lineWidth = compass.penWidth
                        drawingCanvas.ctx.lineCap = drawingCanvas.ctx.lineJoin = "round"
                    }

                    function drawTrace() {
                        var angle = lastAngle
                        var nextPt = getPenPosition(angle)
                        drawingCanvas.ctx.beginPath()
                        drawingCanvas.ctx.moveTo(lastPoint.x, lastPoint.y)
                        if (lastAngle < compassAngle) { // clockwise
                            for (angle = lastAngle; angle <= compassAngle; angle += degreesPerPixel) {
                                nextPt = getPenPosition(angle)
                                drawingCanvas.ctx.lineTo(nextPt.x, nextPt.y)
                            }
                        } else {    // counter clockwise
                            for (angle = lastAngle; angle >= compassAngle; angle -= degreesPerPixel) {
                                nextPt = getPenPosition(angle)
                                drawingCanvas.ctx.lineTo(nextPt.x, nextPt.y)
                            }
                        }
                        maxAngle = (compassAngle > maxAngle) ? compassAngle : maxAngle
                        minAngle = (compassAngle < minAngle) ? compassAngle : minAngle
                        lastAngle = compassAngle
                        lastPoint = nextPt
                        drawingCanvas.ctx.stroke()
                        drawingCanvas.requestPaint()
                    }

                    function endTrace() {   // Save trace into svgTank
                        svgTank.strokeColor = compass.penColor
                        svgTank.strokeWidth = compass.penWidth
                        svgTank.svgOpacity = compass.penOpacity
                        minAngle += ((-compass.tipPenAngle + 180) % 360)
                        maxAngle += ((-compass.tipPenAngle + 180) % 360)
                        svgTank.addArcSegment(compass.x, compass.y, tipPenDistance, minAngle, maxAngle)
                        compassAngle = compassAngle % 360
                        drawingCompleted()
                    }
                }
            }
        }

        Rectangle {
            id: penDot
            x: penHandle.x + (penHandle.width - width) * 0.5
            y: penHandle.y + (penHandle.width - width) * 0.5
            visible: !penImageArea.dragging
            width:  penWidth
            height: penWidth
            radius: penWidth
            color: penColor
            opacity: compass.penOpacity
            z: -1
        }

        Rectangle { // Visual of the handle
            id: penHandle
            width:  dragZoneWidth
            height: dragZoneWidth
            radius: dragZoneWidth / 2
            color: "transparent"
            border.color: "gray"
            border.width: penHandleFocus ? 3 : 1
            x: compassPen.x - radius
            y: compassPen.y - radius
            visible: !penImageArea.drawing

            property bool penHandleFocus: (penHandleTarget.dragging || penArea.containsMouse || penLegArea.containsMouse)

            MouseArea {
                id: penArea
                drag.target: penHandleTarget
                anchors.fill: parent
                hoverEnabled: true
                onPressed: (mouse) => {
                    penHandleTarget.pressedLogic(mouse);
                }

                onReleased: (mouse) => {
                    penHandleTarget.releasedLogic(mouse);
                }

                onPositionChanged: (mouse) => {
                    penHandleTarget.positionChangedLogic(mouse);
                }
            }
        }

        Item { // Target of the handle, used to move pencil, changes the compass width, doesn't draw
            id: penHandleTarget
            width:  dragZoneWidth
            height: dragZoneWidth
            x: compassPen.x - penHandle.radius
            y: compassPen.y - penHandle.radius

            property bool dragging: false

            readonly property point centerPoint: Qt.point(width * 0.5, height * 0.5)

            function pressedLogic(mouse_) {
                penHandleTarget.x = penHandle.x
                penHandleTarget.y = penHandle.y
                penHandleTarget.dragging = true
                mouse_.accepted = true
            }

            function releasedLogic(mouse_) {
                penHandleTarget.x = penHandle.x
                penHandleTarget.y = penHandle.y
                penHandleTarget.dragging = false
                mouse_.accepted = true;
            }

            function positionChangedLogic(mouse_) {
                if(penHandleTarget.dragging) {
                    var point = mapToItem(drawingCanvas, penHandleTarget.centerPoint)
                    point.x -= drawingCanvas.width / 2
                    point.y -= drawingCanvas.height / 2
                    if(logicalXor(magnetism, mouse_.modifiers & Qt.ControlModifier) &&
                        (tipPenDistance > gridStep - 2)) {    // Disable magnetism to avoid unexcepted behavior with short distance
                            magneticAlign(point)
                        }
                        point.x -= compass.x
                        point.y -= compass.y
                        var dist = distance(compassTip, point)
                        if (dist > 2 * legLength) {
                            dist = 2 * legLength
                        }
                        var angle = pointsToDegrees(compassTip, point) + compassAngle
                        compassPen.x = (dist * Math.sin(angle * Math.PI / 180)) // + compass.x
                        compassPen.y = (dist * Math.cos(angle * Math.PI / 180)) // + compass.y
                        compassPen = compass.mapFromItem(drawingCanvas, compassPen)
                        compassPen.x += compass.x
                        compassPen.y += compass.y
                }
                mouse_.accepted = true
            }
        }

        Rectangle { // Handle, used to turn compass without changing the compass width, doesn't draw
            id: hingeHandle
            width: legWidth
            height: width
            radius: width * 0.5
            color: "#536069"
            x: hinge.x - radius
            y: hinge.y - radius

            Rectangle {
                id: hingeInside
                width: legWidth * 0.75
                height: width
                radius: width
                color: "#424e56"
                border.color: "#bfcad9"
                border.width: ((hingeArea.dragging || hingeArea.containsMouse)) ? 3 : 1
                x: (parent.width - width) * 0.5
                y: x
            }

            MouseArea {
                id: hingeArea
                property bool dragging: false
                property real previousAngle: 0
                anchors.fill: parent
                hoverEnabled: true
                onPressed: (mouse) => {
                    tipPoint.globalTipPosition = tipPoint.mapToGlobal(compass.compassTip);
                    previousAngle = pointsToDegrees(tipPoint.globalTipPosition, mapToGlobal(mouse.x, mouse.y));
                    dragging = true;
                    mouse.accepted = true;
                }
                onReleased: (mouse) => {
                    dragging = false;
                    mouse.accepted = true;
                }
                onPositionChanged: (mouse) => {
                    if (dragging) {
                        var angle = pointsToDegrees(tipPoint.globalTipPosition, mapToGlobal(mouse.x, mouse.y));
                        var delta = angle - previousAngle;
                        if (delta > 300)        // Prevents the angle from turning the other way round.
                            delta -= 360;
                        else if (delta < -300)
                            delta += 360;
                        compassAngle -= delta;
                        previousAngle = angle;
                        mouse.accepted = true;
                    }
                }
            }
        }
    }
}
