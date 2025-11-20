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
    objective: qsTr("The daisy")
    difficulty: 2
    data: [
        {   "title": objective,
            "size": 600,
            "gridStep": 50,
            "steps": [
                {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 200,
                    "start": 0,
                    "end": 360
                }, {
                    "centerX": -200,
                    "centerY": 0,
                    "radius": 200,
                    "start": 30,
                    "end": 150
                }, {
                    "centerX": -100,
                    "centerY": -173,
                    "radius": 200,
                    "start": 90,
                    "end": 210
                }, {
                    "centerX": 100,
                    "centerY": -173,
                    "radius": 200,
                    "start": 150,
                    "end": 270
                }, {
                    "centerX": 200,
                    "centerY": 0,
                    "radius": 200,
                    "start": 210,
                    "end": 330
                }, {
                    "centerX": 100,
                    "centerY": 173,
                    "radius": 200,
                    "start": 270,
                    "end": 30
                }, {
                    "centerX": -100,
                    "centerY": 173,
                    "radius": 200,
                    "start": 330,
                    "end": 90
                }
            ]
        }
    ]
}
