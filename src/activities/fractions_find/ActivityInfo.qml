/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "fractions_find/Fractions_find.qml"
  difficulty: 5
  icon: "fractions_find/fractions_find.svg"
  author: "Johnny Jazeix &lt;jazeix@gmail.com&gt;"
  //: Activity title
  title: qsTr("Find the fractions")
  //: Help title
  description: qsTr("Find the correct numerator and denominator of the represented fraction.")
  //intro: "Find the correct numerator and denominator of the represented fraction"
  //: Help goal
  goal: qsTr("Learn to write a fraction corresponding to a given fractional representation.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Write the fraction corresponding to the fractional representation: Count the total number of parts of the represented shape, and set it as the denominator. Then count the number of selected parts, and set it as the numerator.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 30000
  levels: ["1", "2", "3", "4", "5", "6"]
}
