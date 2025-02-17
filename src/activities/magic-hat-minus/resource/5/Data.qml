/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Calculate remaining stars up to 30.")
    difficulty: 3
    data: [
        {
            "maxValue": 30,
            "minStars" : [2, 0, 0],
            "maxStars" : [5, 0, 0]
        },
        {
            "maxValue": 30,
            "minStars" : [2, 0, 0],
            "maxStars" : [10, 0, 0]
        },
        {
            "maxValue": 30,
            "minStars" : [2, 2, 0],
            "maxStars" : [8, 8, 0]
        },
        {
            "maxValue": 30,
            "minStars" : [2, 2, 0],
            "maxStars" : [10, 10, 0]
        },
        {
            "maxValue": 30,
            "minStars" : [2, 2, 2],
            "maxStars" : [9, 9, 7]
        },
        {
            "maxValue": 30,
            "minStars" : [2, 2, 2],
            "maxStars" : [10, 10, 10]
        }
    ]
}
