/* GCompris - AlgebraMinus.qml
 *
 * SPDX-FileCopyrightText: 2014 Aruna Sankaranarayanan <aruna.evam@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin (GTK+ version)
 *   Aruna Sankaranarayanan <aruna.evam@gmail.com> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core/GCompris"
import "../algebra_by/"
import "../algebra_by/algebra.js" as Activity

Algebra {
    onStart: {
        Activity.operandText = Activity.OperandsEnum.MINUS_SIGN
    }
}
