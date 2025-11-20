/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2026 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("The bear")
    difficulty: 4
    data: [
        {   "title": objective,
            "size": 850,
            "gridStep": 25,
            "steps": [
                {
                    "centerX": 0,
                    "centerY": -50,
                    "radius": 225,
                    "start": 270,
                    "end": 450
                },{
                    "centerX": -100,
                    "centerY": -50,
                    "radius": 50,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": 100,
                    "centerY": -50,
                    "radius": 50,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": -100,
                    "centerY": -75,
                    "radius": 50,
                    "start": 105,
                    "end": 255
                },{
                    "centerX": 100,
                    "centerY": -75,
                    "radius": 50,
                    "start": 105,
                    "end": 255
                },{
                    "centerX": -200,
                    "centerY": -150,
                    "radius": 100,
                    "start": 195,
                    "end": 399
                },{
                    "centerX": 200,
                    "centerY": -150,
                    "radius": 100,
                    "start": 321,
                    "end": 525
                },{
                    "centerX": -200,
                    "centerY": -150,
                    "radius": 75,
                    "start": 198.5,
                    "end": 393.5
                },{
                    "centerX": 200,
                    "centerY": -150,
                    "radius": 75,
                    "start": 327.5,
                    "end": 521.5
                },{
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 250,
                    "start": 76.5,
                    "end": 283.5
                },{
                    "centerX": 0,
                    "centerY": 150,
                    "radius": 150,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": -75,
                    "centerY": -25,
                    "radius": 225,
                    "start": 125,
                    "end": 160
                },{
                    "centerX": 75,
                    "centerY": -25,
                    "radius": 225,
                    "start": 200,
                    "end": 235
                },{
                    "centerX": 0,
                    "centerY": -175,
                    "radius": 300,
                    "start": 160,
                    "end": 200
                }
            ]
        }
    ]
}
