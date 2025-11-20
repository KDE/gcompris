/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("The swirl")
    difficulty: 3
    data: [
        {   "title": objective,
            "size": 660,
            "gridStep": 30,
            "steps": [
                {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 60,
                    "start": 0,
                    "end": 360
                }, {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 120,
                    "start": 0,
                    "end": 360
                }, {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 180,
                    "start": 0,
                    "end": 360
                }, {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 240,
                    "start": 0,
                    "end": 360
                }, {
                    "centerX": -60,
                    "centerY": 0,
                    "radius": 60,
                    "start": 270,
                    "end": 90
                }, {
                    "centerX": 0,
                    "centerY": -60,
                    "radius": 60,
                    "start": 0,
                    "end": 180
                }, {
                    "centerX": 60,
                    "centerY": 0,
                    "radius": 60,
                    "start": 90,
                    "end": 270
                }, {
                    "centerX": 0,
                    "centerY": 60,
                    "radius": 60,
                    "start": 180,
                    "end": 360
                }, {
                    "centerX": -180,
                    "centerY": 0,
                    "radius": 60,
                    "start": 90,
                    "end": 270
                }, {
                    "centerX": 0,
                    "centerY": -180,
                    "radius": 60,
                    "start": 180,
                    "end": 360
                }, {
                    "centerX": 180,
                    "centerY": 0,
                    "radius": 60,
                    "start": 270,
                    "end": 90
                }, {
                    "centerX": 0,
                    "centerY": 180,
                    "radius": 60,
                    "start": 0,
                    "end": 180
                }
            ]
        }
    ]
}
