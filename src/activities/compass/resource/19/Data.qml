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
    //: The animal
    objective: qsTr("The mouse")
    difficulty: 4
    data: [
        {   "title": objective,
            "size": 1040,
            "gridStep": 20,
            "steps": [
                {
                    "centerX": -260,
                    "centerY": 0,
                    "radius": 80,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": -20,
                    "centerY": 0,
                    "radius": 80,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": -280,
                    "centerY": 20,
                    "radius": 80,
                    "start": 334,
                    "end": 475
                },{
                    "centerX": 0,
                    "centerY": 20,
                    "radius": 80,
                    "start": 250,
                    "end": 384
                },{
                    "centerX": -140,
                    "centerY": 160,
                    "radius": 260,
                    "start": 335,
                    "end": 385
                },{
                    "centerX": 0,
                    "centerY": 20,
                    "radius": 331,
                    "start": 205,
                    "end": 266
                },{
                    "centerX": -280,
                    "centerY": 20,
                    "radius": 331,
                    "start": 92,
                    "end": 155
                },{
                    "centerX": -200,
                    "centerY": 160,
                    "radius": 40,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": -80,
                    "centerY": 160,
                    "radius": 40,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": -200,
                    "centerY": 140,
                    "radius": 20,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": -80,
                    "centerY": 140,
                    "radius": 20,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": -140,
                    "centerY": 320,
                    "radius": 40,
                    "start": 307,
                    "end": 413
                },{
                    "centerX": -200,
                    "centerY": -60,
                    "radius": 240,
                    "start": 205,
                    "end": 453
                },{
                    "centerX": 220,
                    "centerY": 60,
                    "radius": 242,
                    "start": 312,
                    "end": 425
                },{
                    "centerX": 200,
                    "centerY": 60,
                    "radius": 260,
                    "start": 319,
                    "end": 427
                }
            ]
        }
    ]
}
