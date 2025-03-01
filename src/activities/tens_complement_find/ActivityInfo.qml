/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "tens_complement_find/Tens_complement_find.qml"
  difficulty: 4
  icon: "tens_complement_find/tens_complement_find.svg"
  author: "Samarth Raj &lt;mailforsamarth@gmail.com&gt;"
  //: Activity title
  title: qsTr("Find ten's complement")
  //: Help title
  description: qsTr("Find the ten's complement of each number.")
  //intro: "Create pairs of numbers equal to ten. Select a number in the list, then select an empty spot of an operation to move the selected number there."
  //: Help goal
  goal: qsTr("Learn to find ten's complement.")
  //: Help prerequisite
  prerequisite: qsTr("Numbers from 1 to 10 and addition.")
  //: Help manual
  manual: qsTr("Create pairs of numbers equal to ten. Select a number in the list, then select an empty spot of an operation to move the selected number there.") + "<br>" + qsTr("When all the lines are completed, press the OK button to validate the answers. If some answers are incorrect, a cross icon will appear on the corresponding lines. To correct the errors, click on the wrong numbers to remove them and repeat the previous steps.")
  credit: ""
  section: "math arithmetic"
  createdInVersion: 30000
  levels: ["1", "2", "3", "4"]
}
