/* GCompris - ActivityInfo.qml
 *
 * Copyright (C) 2022-2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
    name: "grammar_classes/GrammarClasses.qml"
    difficulty: 3
    icon: "grammar_classes/grammar_classes.svg"
    author: "Bruno ANSELME &lt;be.root@free.fr&gt;"
    //: Activity title
    title: qsTr("Grammatical classes")
    //: Help title
    description: qsTr("Identify grammatical classes in the given sentences.")
    //intro: "Assign the requested grammatical classes to the corresponding words."
    //: Help goal
    goal: qsTr("Learn to identify grammatical classes.")
    prerequisite: ""
    //: Help manual
    manual: qsTr("Assign the requested grammatical class to the corresponding words.") + ("<br>") +
            qsTr("Select the grammatical class from the list, then select the box under a word and assign it the class.") + ("<br>") +
            qsTr("Leave the box blank if the class doesn't match.") + ("<br>") +
            qsTr("<b>Keyboard controls:</b>") + "<ul>" +
            "<li>" +qsTr("Up and down arrows or tabulation: switch between classes and words") + "</li>" +
            "<li>" +qsTr("Left and right arrows: select items in classes or words") + "</li>" +
            "<li>" +qsTr("Space: assign the selected class to the selected word and then select the next word") + "</li>" +
            "<li>" +qsTr("Backspace: select the previous word") + "</li>" +
            "<li>" +qsTr("Enter: validate your answer") + "</li>" +
              ("</ul>")
    credit: ""
    section: "reading words"
    createdInVersion: 40000
}
