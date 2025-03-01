/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2021 Harsh Kumar <hadron43@yahoo.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "path_decoding_relative/PathDecodingRelative.qml"
  difficulty: 1
  icon: "path_decoding_relative/path_decoding_relative.svg"
  author: "Harsh Kumar &lt;hadron43@yahoo.com&gt;"
  //: Activity title
  title: qsTr("Relative path decoding")
  //: Help title
  description: qsTr("Follow the given directions to help Tux reach the target.")
  //intro: "Click on the grid squares following the given directions to help Tux reach the target."
  //: Help goal
  goal: qsTr("Develop skills in visualization and map reading, and learn to follow directions.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("Click on the grid squares to move Tux to the target following the arrow directions.") + "<br><br>" +
          qsTr("The directions are relative to the current orientation of Tux.") + "<br><br>" +
          qsTr("This means that UP moves forward, DOWN moves backward, LEFT moves to the left side of Tux and RIGHT moves to the right side of Tux.")
  credit: ""
  section: "discovery logic"
  createdInVersion: 20000
  levels: ["1", "2", "3", "4"]
}
