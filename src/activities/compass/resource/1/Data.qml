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
    objective: qsTr("The target")
    difficulty: 1
    data: [
        {   "title": objective,
            "size": 600,
            "gridStep": 50,
            "steps": [
                {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 50,
                    "start": 0,
                    "end": 360
                },
                {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 100,
                    "start": 0,
                    "end": 360
                },
                {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 150,
                    "start": 0,
                    "end": 360
                },
                {
                    "centerX": 0,
                    "centerY": 0,
                    "radius": 200,
                    "start": 0,
                    "end": 360
                }
            ]
        }
    ]
}
