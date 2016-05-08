/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import Material 0.2
//import Qt.labs.controls 1.0

import "./getrandomTip.js" as TIP
import "./storage.js" as ST

ApplicationWindow {
    id:appwindow
    visible: true
    width: isMobile() ? Screen.width : 800
    height: isMobile() ? Screen.height : 480

    minimumWidth: 350
    minimumHeight: 500
    color: "#f4f4f4"

    title: "卉打卡"

    onActiveFocusItemChanged: {
            if (activeFocusItem !== null
                    && activeFocusItem.Keys !== undefined)
            {
                activeFocusItem.Keys.onReleased.disconnect(onKeyReleased)
            }
            if (activeFocusItem !== null)
            {
                activeFocusItem.Keys.onReleased.connect(onKeyReleased)
            }
        }

        function onKeyReleased(event) {
            if (event.key === Qt.Key_Back
                    || event.key === Qt.Key_Escape)
            {
                //console.log("accepted now");
                if(pageStack.depth > 1) {
                    pageStack.pop()
                }
                else {
                    //msgDlgQuit.open()
                }

                event.accepted = true
            }
        }


    StackView{
        id:pageStack
        z: 101
        width: parent.width
        height: parent.height
        initialItem:Qt.resolvedUrl("FirstPage.qml")
        anchors.fill: parent
    }


    function isMobile() {
        console.log(Qt.platform.os)
         var b = false
         switch(Qt.platform.os) {
         case "ios":
             b = true
             break
         case "android":
             b = true
             break
         }
         return b
     }



    ListModel {
          id: cbItems
       }

    Component.onCompleted: {
        ST.initialize();
    }
}
