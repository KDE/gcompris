/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("The lion")
    difficulty: 4
    data: [
        {   "title": objective,
            "size": 650,
            "gridStep": 25,
            "steps": [
                {
                    "centerX": 0,
                    "centerY": -75,
                    "radius": 100,
                    "start": 221,
                    "end": 499
                },{
                    "centerX": 0,
                    "centerY": 75,
                    "radius": 100,
                    "start": 14,
                    "end": 346
                },{
                    "centerX": -75,
                    "centerY": 0,
                    "radius": 100,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": 75,
                    "centerY": 0,
                    "radius": 100,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": 0,
                    "centerY": -75,
                    "radius": 100,
                    "start": 167,
                    "end": 193
                },{
                    "centerX": 0,
                    "centerY": -175,
                    "radius": 125,
                    "start": 186,
                    "end": 231
                },{
                    "centerX": 0,
                    "centerY": -175,
                    "radius": 125,
                    "start": 128,
                    "end": 174
                },{
                    "centerX": -100,
                    "centerY": -100,
                    "radius": 75,
                    "start": 234,
                    "end": 397
                },{
                    "centerX": -100,
                    "centerY": -100,
                    "radius": 50,
                    "start": 241,
                    "end": 389
                },{
                    "centerX": 100,
                    "centerY": -100,
                    "radius": 75,
                    "start": 323,
                    "end": 486
                },{
                    "centerX": 100,
                    "centerY": -100,
                    "radius": 50,
                    "start": 331,
                    "end": 479
                },{
                    "centerX": 0,
                    "centerY": 175,
                    "radius": 125,
                    "start": 270,
                    "end": 338
                },{
                    "centerX": 0,
                    "centerY": 175,
                    "radius": 125,
                    "start": 24,
                    "end": 90
                },{
                    "centerX": 0,
                    "centerY": -175,
                    "radius": 275,
                    "start": 170,
                    "end": 190
                },{
                    "centerX": -50,
                    "centerY": -75,
                    "radius": 25,
                    "start": 55,
                    "end": 142
                },{
                    "centerX": -50,
                    "centerY": -75,
                    "radius": 25,
                    "start": 275,
                    "end": 334
                },
                {
                    "centerX": 50,
                    "centerY": -75,
                    "radius": 25,
                    "start": 218,
                    "end": 305
                },{
                    "centerX": 50,
                    "centerY": -75,
                    "radius": 25,
                    "start": 26,
                    "end": 85
                }
            ]
        }
    ]
}
