/* GCompris
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitgenius@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

QtObject {
   property var levels: [
      {
          "pixmapfile": "images/fusee.svg",
          "x": "0.2",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/star.svg",
          "x": "0.5",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/sofa.svg",
          "x": "0.8",
          "y": 0.2,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/house.svg",
          "x": "0.2",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/lighthouse.svg",
          "x": "0.5",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
          "pixmapfile": "images/sailingboat.svg",
          "x": "0.8",
          "y": 0.65,
          "height": 0.25,
          "width": 0.25
      },
      {
		  "text": qsTr("rocket"),
		  "x": "0.2",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("star"),
		  "x": "0.5",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("sofa"),
		  "x": "0.8",
		  "y": "0.4",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("house"),
		  "x": "0.2",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("light house"),
		  "x": "0.5",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      },
      {
		  "text": qsTr("sailing boat"),
		  "x": "0.8",
		  "y": "0.85",
		  "width": "0.25",
          "height": 0.1,
		  "type": "DisplayText"
      }
   ]
}
