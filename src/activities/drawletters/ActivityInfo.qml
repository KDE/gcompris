/* GCompris - ActivityInfo.qml
 *
 * SPDX-FileCopyrightText: 2016 Nitish Chauhan <nitish.nc18@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

ActivityInfo {
    name: "drawletters/Drawletters.qml"
    difficulty: 1
    icon: "drawletters/drawletters.svg"
    author: "Nitish Chauhan &lt;nitish.nc18@gmail.com&gt;"
    //: Activity title
    title: qsTr("Draw letters")
    //: Help title
    description: qsTr("Connect the dots to draw the letters.")
    //  intro: "Click on the selected points and draw the letter"
    //: Help goal
    goal: qsTr("Learn how to draw letters in a fun way.")
    prerequisite: ""
    //: Help manual
    manual: qsTr("Draw the letters by connecting the dots in the correct order. You can click and drag from one point to the next ones, or click on each point one after the other.")
    credit: ""
    section: "reading letters"
    createdInVersion: 7000
}
