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
    objective: qsTr("The face")
    difficulty: 4
    data: [
        {   "title": objective,
            "size": 850,
            "gridStep": 25,
            "steps": [
                {
                    "centerX": -175,
                    "centerY": -75,
                    "radius": 150,
                    "start": 300,
                    "end": 420
                },{
                    "centerX": 175,
                    "centerY": -75,
                    "radius": 150,
                    "start": 300,
                    "end": 420
                },
                {
                    "centerX": -175,
                    "centerY": -225,
                    "radius": 150,
                    "start": 120,
                    "end": 240
                },{
                    "centerX": 175,
                    "centerY": -225,
                    "radius": 150,
                    "start": 120,
                    "end": 240
                },{
                    "centerX": -175,
                    "centerY": -175,
                    "radius": 25,
                    "start": 0,
                    "end": 360
                },
                {
                    "centerX": 175,
                    "centerY": -175,
                    "radius": 25,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": -175,
                    "centerY": -175,
                    "radius": 75,
                    "start": 66,
                    "end": 294
                },{
                    "centerX": 175,
                    "centerY": -175,
                    "radius": 75,
                    "start": 66,
                    "end": 294
                },{
                    "centerX": 0,
                    "centerY": -25,
                    "radius": 125,
                    "start": 129,
                    "end": 231
                },{
                    "centerX": 0,
                    "centerY": 25,
                    "radius": 103,
                    "start": 104,
                    "end": 256
                },{
                    "centerX": 0,
                    "centerY": -50,
                    "radius": 250,
                    "start": 127,
                    "end": 233
                },{
                    "centerX": 0,
                    "centerY": 50,
                    "radius": 200,
                    "start": 110,
                    "end": 250
                },{
                    "centerX": -175,
                    "centerY": -75,
                    "radius": 257.5,
                    "start": 322,
                    "end": 390
                },
                {
                    "centerX": 175,
                    "centerY": -75,
                    "radius": 257.5,
                    "start": 330,
                    "end": 398
                }
            ]
        }
    ]
}
