/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *   Timothée Giet <animtim@gmail.com> (New images and coordinates)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

QtObject {
   property string instruction: qsTr("Moonwalker")
   property var levels: [
      {
          "pixmapfile": "images/moon-04.svg",
          "x": "0.75",
          "y": "0.65",
          "width": 0.4,
          "height": 0.3
      },
      {
          "pixmapfile": "images/moon-03.svg",
          "x": "0.25",
          "y": "0.65",
          "width": 0.4,
          "height": 0.3
      },
      {
          "pixmapfile": "images/moon-02.svg",
          "x": "0.75",
          "y": "0.2",
          "width": 0.4,
          "height": 0.3
      },
      {
          "pixmapfile": "images/moon-01.svg",
          "x": "0.25",
          "y": "0.2",
          "width": 0.4,
          "height": 0.3
      },
      {
		  "text": qsTr("1"),
		  "x": "0.25",
		  "y": 0.4,
		  "width": "0.1",
          "height": 0.075,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("2"),
		  "x": "0.75",
		  "y": 0.4,
		  "width": "0.1",
          "height": 0.075,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("3"),
		  "x": "0.25",
		  "y": 0.85,
		  "width": "0.1",
          "height": 0.075,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("4"),
		  "x": "0.75",
		  "y": 0.85,
		  "width": "0.1",
          "height": 0.075,
		  "type": "DisplayText"
      }
   ]
}
