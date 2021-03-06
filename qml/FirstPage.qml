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

import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
//import Qt.labs.controls 1.0

import "./getrandomTip.js" as TIP
import "./storage.js" as ST

Item {
    id:fristpage
    property date selectedDate: calendar.selectedDate
    property string currentSelectname
    property alias  eventsmodel: eventsModel
    property bool running:Qt.application.active
    width: parent.width
    height: parent.height
    z: 100
    onSelectedDateChanged: {
        eventsList.visible = true;
        eventsListView.model = ST.eventsForDate(eventsModel,calendar.selectedDate);
    }
    onRunningChanged: {
        refreshEvent();
        ST.loadCombo(cbItems);
    }

    SystemPalette {
        id: systemPalette
    }

    ListModel {
        id: eventsModel
    }

    ListModel{
        id:tmpModel
    }

    function getCurrentTime(){
        var date = new Date();
        var zero = new Date(date.getFullYear(),date.getMonth(),date.getDate(),0)
        var cha = (date.getTime() - zero.getTime())/1000;
        return cha;
    }



    function isSameday(){
        var date = calendar.selectedDate;
        if(date.toDateString() == new Date().toDateString()){
            return true;
        }else{
            return false;
        }

    }

    function refreshEvent(){
        calendar.selectedDate = getNextMonthDay();
        calendar.selectedDate = new Date();
        eventsListView.model = tmpModel;
        eventsListView.model = ST.eventsForDate(eventsModel,calendar.selectedDate);
    }


    function getNextMonthDay(){
        var date = new Date();
        var year = date.getFullYear();
        var month = date.getMonth();
        var day = date.getDate();
        if(month == 11){
            month = 1;
            year += 1;
        }else{
            month += 1;
        }

        return new Date(year,month,1,0)
    }




    Flow {
        id: row
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10
        layoutDirection: Qt.LeftToRight




        Calendar {
            id: calendar
            width: (parent.width > parent.height ? parent.width * 0.6 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.6 - parent.spacing : parent.height)
            frameVisible: true
            weekNumbersVisible: false
            selectedDate: new Date()
            focus: true

            Behavior on visible {
                NumberAnimation { duration: 500 }
            }

            style: CalendarStyle {
                dayDelegate: Item {
                    readonly property color sameMonthDateTextColor: "#444"
                    readonly property color selectedDateColor: Qt.platform.os === "osx" ? "#3778d0" : systemPalette.highlight
                    readonly property color selectedDateTextColor: "white"
                    readonly property color differentMonthDateTextColor: "#bbb"
                    readonly property color invalidDatecolor: "#dddddd"


                    Rectangle {
                        anchors.fill: parent
                        border.color: "transparent"
                        color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                        anchors.margins: styleData.selected ? -1 : 0
                    }

                    Image {
                        visible: ST.hasfeature(styleData.date)
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: -1
                        width: parent.width / 4
                        height: width
                        source: "qrc:/images/eventindicator.png"
                    }

                    Image {
                        visible: styleData.date.toDateString() == new Date().toDateString()
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: -1
                        width: parent.width / 4
                        height: width
                        source: "qrc:/images/today.png"
                    }

                    Label {
                        id: dayDelegateText
                        text: styleData.date.getDate()
                        anchors.centerIn: parent
                        color: {
                            var color = invalidDatecolor;
                            if (styleData.valid) {
                                // Date is within the valid range.
                                color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if (styleData.selected) {
                                    color = selectedDateTextColor;
                                }
                            }
                            color;
                        }
                    }
                }
            }
        }

        Component {
            id: eventListHeader

            Row {
                id: eventDateRow
                width: parent.width
                height: eventDayLabel.height
                spacing: 10

                Label {
                    id: eventDayLabel
                    text: calendar.selectedDate.getDate()
                    font.pointSize: 35
                }

                Column {
                    height: eventDayLabel.height

                    Label {
                        readonly property var options: { weekday: "long" }
                        text: Qt.locale().standaloneDayName(calendar.selectedDate.getDay(), Locale.LongFormat)
                        font.pointSize: 18
                    }
                    Label {
                        text: calendar.selectedDate.toLocaleDateString(Qt.locale(), " yyyy") +"年"+
                              Qt.locale().standaloneMonthName(calendar.selectedDate.getMonth())
                        font.pointSize: 12
                    }
                }
            }
        }


        MessageDialog {
            id:confirmDialog
            title: "删除？";
            icon: StandardIcon.Question;
            text: "确定删除今天的这条打卡记录吗？";
            standardButtons: StandardButton.Yes | StandardButton.No
            onYes: {
                console.log(currentSelectname)
                var flag = ST.deleteData(currentSelectname,calendar.selectedDate);
                if(flag){
                    ST.loadCombo(cbItems);
                    refreshEvent();
                }
            }
            onNo: console.log("didn't delete");
            Component.onCompleted: visible = false

        }


        Rectangle{
            width: (parent.width > parent.height ? parent.width * 0.1 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.1 - parent.spacing : parent.height)
            color: "#00FFFFFF"
            border.width:0
            MouseArea{
                anchors.fill: parent
                anchors.margins: -3
                onClicked: {
                    refreshEvent();
                    eventsList.visible = true;
                }
            }

            Image{
                id:settings
                width: addEvent.width
                height: width
                anchors.left:parent.left
                anchors.bottom: parent.bottom
                source: "qrc:/images/setting.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: pageStack.push(Qt.resolvedUrl("settingPage.qml"),false)
                }
            }

            Image{
                id:addEvent
                visible: calendar.selectedDate.toDateString() == new Date().toDateString()
                source: eventsList.visible?"qrc:/images/add.png":"qrc:/images/yes.png"
                anchors.right: parent.right
                width: (parent.width > parent.height ? parent.height:parent.width)
                height: width
                MouseArea{
                    anchors.fill: parent
                    onClicked: {

                        if(!eventsList.visible){
                            eventsList.visible = true;
                            refreshEvent();
                        }else{
                            eventsList.visible = false;
                        }


                    }
                }
            }
            Image{
                id:back
                visible: !addEvent.visible
                source: "qrc:/images/today.png"
                anchors.right: parent.right
                width: (parent.width > parent.height ? parent.height:parent.width)
                height: width
                MouseArea{
                    anchors.fill: parent
                    onClicked: calendar.selectedDate = new Date();
                }


            }
        }



        Rectangle {
            id:eventsList
            width: (parent.width > parent.height ? parent.width * 0.3 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.3 - parent.spacing : parent.height)
            border.color: Qt.darker(color, 1.2)
            
            Behavior on height {
                NumberAnimation { duration: 1000 }
            }
            
            ListView {
                id: eventsListView
                spacing: 4
                clip: true
                width: parent.width
                anchors.fill: parent
                anchors.margins: 10
                model: ST.eventsForDate(eventsModel,calendar.selectedDate)

                delegate: Rectangle {
                    width: parent.width
                    height: eventItemColumn.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image {
                        id:checked
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.height / 2
                        height: width
                        source: "qrc:/images/checked.png"
                    }

                    Rectangle {
                        color: "#f0f0f4"
                        height: eventItemColumn.height
                        width: parent.width
                        opacity: index%2 === 0 ? 0.5 : 0
                    }

                    Column {
                        id: eventItemColumn
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.rightMargin:15
                        anchors.right: checked.left
                        width: parent.width
                        spacing: 10

                        Label {
                            id: nameLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: name
                        }
                        Label {
                            id: timeLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: startTime
                            color: "#aaa"
                            font.pointSize: 10
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onPressAndHold: {
                            //本天的可以删除，其他不能
                            currentSelectname = name;
                            if(isSameday()){
                                confirmDialog.open();
                            }
                        }
                    }


                }
            }

            Label{
                id:fridenlyNotify
                anchors.fill: parent
                anchors.margins: 15
                font.pointSize: 15
                color: "#aaa"
                width: parent.width
                font.letterSpacing: 1;
                wrapMode: Text.Wrap
                visible: eventsListView.model.count < 1
                text:{
                    if(calendar.selectedDate > new Date()){
                        var f_len = TIP.futureDay.length;
                        return TIP.futureDay[Math.floor(Math.random() * f_len + 1)-1]
                    }else if(isSameday()){
                        var t_len = TIP.signToday.length;
                        return TIP.signToday[Math.floor(Math.random() * t_len + 1)-1]
                    }else{
                        var p_len = TIP.pastDay.length;
                        return TIP.pastDay[Math.floor(Math.random() * p_len + 1)-1]
                    }
                }
            }
        }

        Rectangle {
            id:toaddedlist
            width: (parent.width > parent.height ? parent.width * 0.3 - parent.spacing : parent.width)
            height: (parent.height > parent.width ? parent.height * 0.3 - parent.spacing : parent.height)
            visible: !eventsList.visible

            ListView {
                id: comboListView
                spacing: 4
                clip: true
                anchors.fill: parent
                anchors.margins: 10
                model: cbItems

                delegate: Rectangle {
                    width: comboListView.width
                    height: comboItemColumn.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    Image {
                        id:tochecked
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.height / 2
                        height: width
                        source: ST.isChecked(ctitle,calendar.selectedDate)?"qrc:/images/checked.png":"qrc:/images/unchecked.png"
                    }

                    Rectangle {
                        color: "#f0f0f4"
                        height: comboItemColumn.height
                        width: parent.width
                        opacity: index%2 === 0 ? 0.5 : 0
                    }

                    Column {
                        id: comboItemColumn
                        anchors.top:tochecked.top
                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.rightMargin:15
                        anchors.right: tochecked.left
                        height: comboLabel.height + timecomboLabel.height + 12

                        Label {
                            id: comboLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: ctitle
                        }
                        Label {
                            id: timecomboLabel
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: ""
                            color: "#aaa"
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(ST.isChecked(ctitle,calendar.selectedDate)){
                                ST.deleteData(ctitle,calendar.selectedDate);
                                tochecked.source = "qrc:/images/unchecked.png";
                            }else{
                                var flag = ST.insertData(ctitle,calendar.selectedDate,new Date().toLocaleTimeString(Qt.locale, Locale.ShortFormat));
                                if(flag){
                                    tochecked.source = "qrc:/images/checked.png";
                                }
                            }
                        }
                    }


                }
            }

            Label{
                id:settNotify
                anchors.fill: parent
                anchors.margins: 15
                font.pointSize: 15
                color: "#aaa"
                width: parent.width
                font.letterSpacing: 1;
                wrapMode: Text.Wrap
                visible: cbItems.count == 0
                text:"暂无事件，请点击设置添加"
            }
        }
    }

    Component.onCompleted: {
        ST.initialize();
        ST.loadCombo(cbItems);
    }


}
