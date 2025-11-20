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
    objective: qsTr("The rose")
    difficulty: 3
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
                    "radius": 282.5,
                    "start": 45,
                    "end": 135
                }, {
                    "centerX": -173.2,
                    "centerY": -100,
                    "radius": 282.5,
                    "start": 75,
                    "end": 165
                }, {
                    "centerX": -100,
                    "centerY": -173.2,
                    "radius": 282.5,
                    "start": 105,
                    "end": 195
                }, {
                    "centerX": 0,
                    "centerY": -200,
                    "radius": 282.5,
                    "start": 135,
                    "end": 225
                }, {
                    "centerX": 100,
                    "centerY": -173.2,
                    "radius": 282.5,
                    "start": 165,
                    "end": 255
                }, {
                    "centerX": 173.2,
                    "centerY": -100,
                    "radius": 282.5,
                    "start": 195,
                    "end": 285
                }, {
                    "centerX": 200,
                    "centerY": 0,
                    "radius": 282.5,
                    "start": 225,
                    "end": 315
                }, {
                    "centerX": 173.2,
                    "centerY": 100,
                    "radius": 282.5,
                    "start": 255,
                    "end": 345
                }, {
                    "centerX": 100,
                    "centerY": 173.2,
                    "radius": 282.5,
                    "start": 285,
                    "end": 15
                }, {
                    "centerX": 0,
                    "centerY": 200,
                    "radius": 282.5,
                    "start": 315,
                    "end": 45
                }, {
                    "centerX": -100,
                    "centerY": 173.2,
                    "radius": 282.5,
                    "start": 345,
                    "end": 75
                }, {
                    "centerX": -173.2,
                    "centerY": 100,
                    "radius": 282.5,
                    "start": 15,
                    "end": 105
                }
            ]
        }
    ]
}
