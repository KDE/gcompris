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
    objective: qsTr("The spiral")
    difficulty: 3
    data: [
        {   "title": objective,
            "size": 850,
            "gridStep": 25,
            "steps": [
                {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 300,
                    "start": 0,
                    "end": 360
                },{
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 50,
                    "start": 270,
                    "end": 360
                },{
                    "centerX": 50,
                    "centerY": 0,
                    "radius": 100,
                    "start": 180,
                    "end": 270
                },{
                    "centerX": 50,
                    "centerY": -50,
                    "radius": 150,
                    "start": 90,
                    "end": 180
                },{
                    "centerX": 0,
                    "centerY": -50,
                    "radius": 200,
                    "start": 0,
                    "end": 90
                },{
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 250,
                    "start": 270,
                    "end": 360
                },{
                    "centerX": 50,
                    "centerY": 0,
                    "radius": 300,
                    "start": 185,
                    "end": 270
                },{
                    "centerX": 50,
                    "centerY": 0,
                    "radius": 50,
                    "start": 180,
                    "end": 270
                },{
                    "centerX": 50,
                    "centerY": -50,
                    "radius": 100,
                    "start": 90,
                    "end": 180
                },{
                    "centerX": 0,
                    "centerY": -50,
                    "radius": 150,
                    "start": 0,
                    "end": 90
                },{
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 200,
                    "start": 270,
                    "end": 360
                },{
                    "centerX": 50,
                    "centerY": 0,
                    "radius": 250,
                    "start": 180,
                    "end": 270
                },{
                    "centerX": 50,
                    "centerY": -50,
                    "radius": 300,
                    "start": 140,
                    "end": 180
                },{
                    "centerX": 50,
                    "centerY": -50,
                    "radius": 50,
                    "start": 90,
                    "end": 180
                },{
                    "centerX": 0,
                    "centerY": -50,
                    "radius": 100,
                    "start": 0,
                    "end": 90
                },{
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 150,
                    "start": 270,
                    "end": 360
                },{
                    "centerX": 50,
                    "centerY": 0,
                    "radius": 200,
                    "start": 180,
                    "end": 270
                },{
                    "centerX": 50,
                    "centerY": -50,
                    "radius": 250,
                    "start": 95,
                    "end": 180
                },{
                    "centerX": 0,
                    "centerY": -50,
                    "radius": 50,
                    "start": 0,
                    "end": 90
                },{
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 100,
                    "start": 270,
                    "end": 360
                },{
                    "centerX": 50,
                    "centerY": 0,
                    "radius": 150,
                    "start": 180,
                    "end": 270
                },{
                    "centerX": 50,
                    "centerY": -50,
                    "radius": 200,
                    "start": 90,
                    "end": 180
                },{
                    "centerX": 0,
                    "centerY": -50,
                    "radius": 250,
                    "start": 0,
                    "end": 90
                },{
                    "centerX": 0,
                    "centerY": -25,
                    "radius": 25,
                    "start": 0,
                    "end": 90
                },{
                    "centerX": 50,
                    "centerY": -25,
                    "radius": 25,
                    "start": 180,
                    "end": 270
                },{
                    "centerX": 25,
                    "centerY": 0,
                    "radius": 25,
                    "start": 270,
                    "end": 360
                },{
                    "centerX": 25,
                    "centerY": -50,
                    "radius": 25,
                    "start": 90,
                    "end": 180
                }
            ]
        }
    ]
}
