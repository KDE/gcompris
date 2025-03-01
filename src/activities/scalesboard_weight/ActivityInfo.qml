/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "scalesboard_weight/ScalesboardWeight.qml"
  difficulty: 4
  icon: "scalesboard_weight/scalesboard_weight.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Balance using the International System of Units")
  //: Help title
  description: qsTr("Drag and Drop some masses to balance the scales and calculate the weight.")
//  intro: "Drag the weights up to balance the scales."
  //: Help goal
  goal: qsTr("Mental calculation, arithmetic equality, unit conversion.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("To balance the scales, move some masses to the left or the right side (on higher levels). They can be arranged in any order. Take care of the weight and the unit of the masses, remember that a kilogram (kg) is 1000 grams (g).")
  credit: ""
  section: "math measures"
  createdInVersion: 0
  levels: ["1", "2", "3", "4", "5", "6"]
}
