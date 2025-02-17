/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2015 Stephane Mankowski <stephane@mankowski.fr>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
  name: "color_mix_light/ColorMixLight.qml"
  difficulty: 4
  icon: "color_mix_light/color_mix_light.svg"
  author: "Stephane Mankowski &lt;stephane@mankowski.fr&gt;"
  //: Activity title
  title: qsTr("Mixing light colors")
  //: Help title
  description: qsTr("Discover light color mixing.")
//  intro: "Match the color by moving the sliders on the torches"
  //: Help goal
  goal: qsTr("Learn to mix primary light colors to match a given color.")
  prerequisite: ""
  //: Help manual
  manual: qsTr("This activity teaches how mixing primary light colors works (additive mixing).") + ("<br><br>") +
          qsTr("Change the color by moving the sliders on the flashlights or by clicking on the + and - buttons. Then click on the OK button to validate your answer.") + ("<br><br>") +
          qsTr("Mixing light colors is just the opposite of mixing paint colors. The more light you add, the lighter the resulting color becomes. The primary colors of light are red, green and blue.")

  credit: ""
  section: "sciences experiment color"
  createdInVersion: 0
}
