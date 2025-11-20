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
    //: The flower
    objective: qsTr("The periwinkle")
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
                    "centerX": 0,
                    "centerY": -200,
                    "radius": 200,
                    "start": 120,
                    "end": 240
                }, {
                    "centerX": 200,
                    "centerY": 0,
                    "radius": 200,
                    "start": 210,
                    "end": 330
                }, {
                    "centerX": 0,
                    "centerY": 200,
                    "radius": 200,
                    "start": 300,
                    "end": 60
                }
            ]
        }
    ]
}
