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
    objective: qsTr("The snail")
    difficulty: 3
    data: [
        {   "title": objective,
            "size": 700,
            "gridStep": 50,
            "steps": [
                {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 50,
                    "start": 270,
                    "end": 90
                },
                {
                    "centerX": -50,
                    "centerY": 0,
                    "radius": 100,
                    "start": 90,
                    "end": 270
                },
                {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 150,
                    "start": 270,
                    "end": 90
                },
                {
                    "centerX": -50,
                    "centerY": 0,
                    "radius": 200,
                    "start": 90,
                    "end": 270
                },
                {
                    "centerX": -200,
                    "centerY": 50,
                    "radius": 70.7,
                    "start": 315,
                    "end": 45
                }
            ]
        }
    ]
}
