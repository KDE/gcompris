/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2025 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "compass/Compass.qml"
  difficulty: 1
  icon: "compass/compass.svg"
  author: "Bruno Anselme &lt;be.root@free.fr&gt;, Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Compass")
  //: Help title
  description: qsTr("Use the compass to draw.")
  //intro: "Use the compass to draw."
  //: Help goal
  goal: qsTr("Learn how to draw circles and arcs with a compass.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("In template mode, each level contains a template to replicate or to get inspiration from. In free mode, you can draw freely and adjust the canvas size and grid spacing as you want from the compass settings menu.") +
          qsTr("<br><b>Drawing with the compass:</b>") + "<ul><li>" +
          qsTr("Move the compass by dragging the leg without the pen.") + "</li><li>" +
          qsTr("Move the pen by dragging the other leg or the circle around the pen tip.") + "</li><li>" +
          qsTr("Rotate and draw by dragging the pen with the left mouse button.") + "</li><li>" +
          qsTr("Rotate without drawing by dragging the compass hinge, or by dragging the pen with the right mouse button.") + "</li></ul>" +
          qsTr("The snap to grid setting can be temporarily inverted by pressing the Control key.") + "<br>" +
          qsTr("<b>Templates:</b>") + "<ul><li>" +
          qsTr("Each level in template mode presents a template to replicate or to get inspiration from.") + "</li><li>" +
          qsTr("Each template is divided into steps which can be scrolled through using the arrows.") + "</li><li>" +
          qsTr("Each step shows where to place the tip of the compass and the circle or arc to be drawn.") + "</li><li>" +
          qsTr("You can change the position of the template by clicking on its corners.") + "</li></ul>" +
          qsTr("<b>Keyboard controls:</b>") + "<ul><li>" +
          qsTr("Ctrl + Z: undo last action") + "</li><li>" +
          qsTr("Ctrl + Y: redo last action") + "</li><li>" +
          qsTr("Ctrl + S: save the image") + "</li><li>" +
          qsTr("Ctrl + O: open an image") + "</li><li>" +
          qsTr("Ctrl: invert snap to grid while it is pressed") + "</li><li>" +
          qsTr("P: open the pen panel") + "</li><li>" +
          qsTr("Left arrow: previous template step") + "</li><li>" +
          qsTr("Right arrow: next template step") + "</li><li>" +
          qsTr("Tab: toggle the template visibility") + "</li><li>" +
          qsTr("Space: toggle the compass and grid visibility") + "</li></ul>"
  credit: ""
  section: "discovery arts fun"
  createdInVersion: 270000
  levels: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"]
}
