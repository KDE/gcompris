/* GCompris - chess.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

Image {
    id: piece
    property int pos
    Behavior on opacity { PropertyAnimation { easing.type: Easing.InOutQuad; duration: 200 } }
    Behavior on x { PropertyAnimation { easing.type: Easing.InOutQuad; duration: items.noPieceAnimation ? 0 : 200 } }
    Behavior on y { PropertyAnimation { easing.type: Easing.InOutQuad; duration: items.noPieceAnimation ? 0 : 200 } }
    z: 10

    property string img
    property bool acceptMove: false
    property int newPos
    // color = -1 if no piece, 0 is black and 1 is white
    property int isWhite: img[0] == 'w' ? 1 : img[0] == 'b' ? 0 : -1

    onImgChanged: {
        if(img == 'W')
            img = 'wk'
        else if(img == 'B')
            img = 'bk'
    }

    SequentialAnimation {
        id: hideAnim
        NumberAnimation {
            target: piece
            property: "scale"
            duration: 200
            to: 0
        }
        PropertyAction {
             target: piece
             property: 'img'
             value: ""
        }
        PropertyAction {
            target: piece
            property: 'pos'
            value: piece.newPos
        }
        PropertyAction {
            target: piece
            property: 'scale'
            value: 1
        }
        PropertyAction {
            target: piece
            property: 'z'
            value: 2
        }
    }

    SequentialAnimation {
        id: promotionAnim
        PauseAnimation {
            duration: 200
        }
        NumberAnimation {
            target: piece
            property: 'scale'
            to: 0
        }
        PropertyAction {
            target: piece
            property: 'img'
            value: isWhite ? 'wk' : 'bk'
        }
        NumberAnimation {
            target: piece
            property: 'scale'
            to: 1
            easing.type: Easing.OutElastic
        }
    }

    function hide(newPos: int) {
        piece.newPos = newPos
        hideAnim.start()
    }

    function promotion() {
        promotionAnim.start()
    }

    function move(to: int) {
        piece.newPos = to
        piece.pos = to
        piece.z = 2
    }
}

