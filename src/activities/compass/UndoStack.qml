/* GCompris - UndoStack.qml
 *
 * SPDX-FileCopyrightText: 2026 Bruno Anselme <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtCore
import core 1.0

Item {
    property alias undoCount: undoModel.count
    property alias redoCount: redoModel.count

    function clear() {                  // Reset models
        clearModel(undoModel)
        clearModel(redoModel)
    }

    function undoLast() {                   // Push last undoModel data to redoModel. Returns data to restore
        if (undoCount < 1) return           // Exit on empty stack, saving first data
        pushModel(redoModel, popModel(undoModel))          // move top element to redoModel
        var todo = undoModel.get(undoCount - 1)
        return todo
    }

    function redoLast() {                   // Push last redoModel data to undoModel. Returns data to restore
        if (redoCount < 1) return           // Exit on empty stack, should never happen
        var todo = popModel(redoModel)
        pushModel(undoModel, todo)
        return todo
    }

    function pushData(data) {    // Push new data to undoModel.
        pushModel(undoModel, data)
        clearModel(redoModel)                   // redoModel is cleared
        while (undoCount > 100) {                // Limited undo stack length
            var todo = shiftModel(undoModel)
        }
    }

    function getLastStacked() {             // Get data from undoModel last element
        return undoModel.get(undoCount - 1)
    }

    function setLastStacked(data) {         // Set data from undoModel last element
        undoModel.set(undoCount - 1, data)
    }

    // Following properties and functions don't need to be called from outer code (private)
    ListModel { id: undoModel }
    ListModel { id: redoModel }

    function clearModel(model) {            // Clear model
        while (model.count)
            var todo = popModel(model)
    }

    function pushModel(model, data) {       // Push data into model (undoModel or redoModel)
        model.append(data)
    }

    function popModel(model) {
        var data = JSON.parse(JSON.stringify(model.get(model.count - 1)))   // Clone data before removing
        model.remove(model.count - 1)
        return data
    }

    function shiftModel(model) {
        var data = JSON.parse(JSON.stringify(model.get(0)))                 // Clone data before removing
        model.remove(0)
        return data
    }
}
