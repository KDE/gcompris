/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 JB BUTET <ashashiwa@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "memory-math-div/MemoryMathDiv.qml"
  difficulty: 6
  icon: "memory-math-div/memory-math-div.svg"
  author: "JB BUTET &lt;ashashiwa@gmail.com&gt;"
  //: Activity title
  title: qsTr("Division memory game")
  //: Help title
  description: qsTr("Flip the cards to match a division with its result.")
//  intro: "Turn over two cards to match the calculation with its answer."
  //: Help goal
  goal: qsTr("Practice division.")
  //: Help prerequisite
  prerequisite: qsTr("Division")
  //: Help manual
  manual: qsTr("Each card is hiding either a division, or a result. You have to match the divisions with their result.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Arrows: navigate") + ("</li><li>") +
          qsTr("Space or Enter: flip the selected card") + ("</li></ul>")
  credit: ""
  section: "math memory arithmetic"
  createdInVersion: 0
  levels: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
}
