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
          "pixmapfile" : "images/postcard.svg",
          "x" : "0.2",
          "y" : "0.7",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/tuxplane.svg",
          "x" : "0.5",
          "y" : "0.7",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/minivan.svg",
          "x" : "0.8",
          "y" : "0.7",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/pencil.svg",
          "x" : "0.2",
          "y" : "0.3",
          "type" : "SHAPE_BACKGROUND",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/tuxhelico.svg",
          "x" : "0.5",
          "y" : "0.3",
          "type" : "SHAPE_BACKGROUND",
          "height" : 0.25,
          "width" : 0.25
      },
      {
          "pixmapfile" : "images/truck.svg",
          "x" : "0.8",
          "y" : "0.3",
          "type" : "SHAPE_BACKGROUND",
          "height" : 0.25,
          "width" : 0.25
      }
   ]
}
