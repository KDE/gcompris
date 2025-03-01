/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "money_back_cents/MoneyBackCents.qml"
  difficulty: 5
  icon: "money_back_cents/money_back_cents.svg"
  author: "Bruno Coudoin &lt;bruno.coudoin@gcompris.net&gt;"
  //: Activity title
  title: qsTr("Give Tux his change, including cents")
  //: Help title
  description: qsTr("Practice money usage by giving Tux his change.")
//  intro: "Click on the money at the bottom of the screen to give Tux his change."
  //: Help goal
  goal: qsTr("Practice counting and money usage, including cents.")
  //: Help prerequisite
  prerequisite: qsTr("Can count.")
  //: Help manual
  manual: qsTr("Click on the coins or on the notes at the bottom of the screen to give Tux his change. If you want to remove a coin or a note, click on it on the upper area of the screen.") + ("<br><br>") +
          qsTr("<b>Keyboard controls:</b>") + ("<ul><li>") +
          qsTr("Left and Right arrows: navigate inside an area") + ("</li><li>") +
          qsTr("Space or Enter: select an item") + ("</li><li>") +
          qsTr("Tab: navigate between the bottom and the top areas") + ("</li></ul>")
  credit: ""
  section: "math money measures"
  createdInVersion: 0
  levels: ["1", "2", "3"]
}
