/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2020 Shubham Mishra <email.shivam828787@gmail.com>
 *
 * Authors:
 *   shivam828787@gmail.com <email.shivam828787@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

Data {
    objective: qsTr("Play with words of 5 letters.")
    difficulty: 3
    data:  [
        [
            /* To add your words, replace "wordLength" key with "word".
              Example - replace "wordLength": 3 with "word": "pen".
            */
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": false,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": false,
                "rows": 4,
                "columns": 5
            }
        ],
        [
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": false,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": true,
                "inLine": false,
                "rows": 5,
                "columns": 6
            }
        ],
        [
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            }
        ],
        [
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": true,
                "rows": 4,
                "columns": 5
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": true,
                "rows": 5,
                "columns": 6
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            },
            {
                "isWord": true,
                "wordLength": 5,
                "showGrid": false,
                "inLine": false,
                "rows": 6,
                "columns": 7
            }
        ]
    ]
}
