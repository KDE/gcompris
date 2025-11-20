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
    objective: qsTr("The soccer ball")
    difficulty: 2
    data: [
        {   "title": objective,
            "size": 720,
            "gridStep": 20,
            "steps": [
                {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 200,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 80,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": -300,
                    "centerY": 0,
                    "radius": 184.4,
                    "start": 50,
                    "end": 130
                },{
                    "centerX": 0,
                    "centerY": -300,
                    "radius": 184.4,
                    "start": 140,
                    "end": 220
                },{
                    "centerX": 300,
                    "centerY": 0,
                    "radius": 184.4,
                    "start": 230,
                    "end": 310
                },{
                    "centerX": 0,
                    "centerY": 300,
                    "radius": 184.4,
                    "start": 320,
                    "end": 400
                }
            ]
        }
    ]
}
