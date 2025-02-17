/* GCompris - graduated_line - Data.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Graduation to find between 0 and 50.")
    difficulty: 4
    data: [
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 5,
                "fitLimits": true,
                "range": [0, 50],
                "steps": [10],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": true,
                "range": [0, 50],
                "steps": [5],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": true,
                "range": [0, 50],
                "steps": [5, 10],
                "segments": []
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": false,
                "range": [0, 50],
                "steps": [2,4],
                "segments": [5, 10]
            }
        },
        {   "title": objective,
            "rules": {
                "nbOfQuestions": 10,
                "fitLimits": false,
                "range": [0, 50],
                "steps": [10],
                "segments": [5, 15]
            }
        }
    ]
}
