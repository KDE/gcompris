/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "keyboard_training/Keyboard_training.qml"
  difficulty: 1
  icon: "keyboard_training/keyboard_training.svg"
  author: "Timothée Giet &lt;animtim@gmail.com&gt;"
  //: Activity title
  title: qsTr("Keyboard training")
  //: Help title
  description: qsTr("Find the requested character and type it on the keyboard.")
  //intro: "Find the requested character and type it on the keyboard."
  //: Help goal
  goal: qsTr("Learn to type on a keyboard.")
  //: Help prerequisite
  prerequisite: ""
  //: Help manual
  manual: qsTr("A character is displayed. Find it on the keyboard and type it.")
  credit: ""
  section: "computer keyboard letters"
  createdInVersion: 270000
}
