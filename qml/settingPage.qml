import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2
import "./storage.js" as ST
import Material 0.3

Item{

    id:settingPage
    //anchors.fill: parent
    property string todelete
    property int todeleteIndex
    width: parent.width
    height: parent.height
    z: 100

    ListModel{
        id:settingModel
    }

    MouseArea{
        id:msa
        focus: false
    }

    ListView {
        id: settingList
        spacing: 4
        clip: true
        header: listHeader
        anchors{
            left:parent.left
            right: parent.right
            top:parent.top
            bottom:listFotter.top
        }

        SwipeArea {
                id: mouse
                anchors.fill: parent

                onSwipe: {

                    switch (direction) {
                    case "left":

                        break
                    case "right":
                        ST.loadCombo(cbItems);
                        pageStack.pop();
                        break
                    }
                }

            }
        anchors.margins: 10
        model: settingModel

        delegate: Rectangle {
            color: "#00FFFFFF"
            width: settingList.width
            height: eventItemColumn.height
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                width: parent.width
                height: 1
                color: "#eee"
                visible: index > 0
                anchors.top:eventItemColumn.top
                anchors.topMargin: -8
            }

            Column {
                id: eventItemColumn
                anchors.top:parent.top
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.rightMargin:15
                height: nameLabel.height + 8

                Label {
                    id: nameLabel
                    width: parent.width
                    wrapMode: Text.Wrap
                    text:ctitle
                    font.pointSize: 15
                }
            }

            MouseArea{
                anchors.fill: parent
                onPressAndHold: {
                    todelete = cname;
                    todeleteIndex = index;
                    dialog.open()
                }
            }


        }

        //footer: listFotter
    }
    Component {
        id: listHeader
        Row {
            id: eventDateRow
            width: parent.width
            height: eventDayLabel.height
            spacing: 10
            layoutDirection:Qt.RightToLeft

            Label {
                id: eventDayLabel
                font.family: "Roboto"
                font.weight: Font.DemiBold
                font.pixelSize: 20
                text: "设置打卡内容"
                MouseArea{
                    anchors.fill: parent
                    onDoubleClicked: pageStack.pop();
                }
            }

        }
    }

    Item {
        id: listFotter
        width: parent.width
        height: parent.width > parent.height ? parent.height * 0.2 : parent.width * 0.2
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }
        TextField{
            id:toadded
            characterLimit: 10
            floatingLabel: true
            anchors{
                left: parent.left
                right: submit.left
                verticalCenter: submit.verticalCenter
                margins: 10
                }
            placeholderText:"输入你要做的事"
        }

        Image {
            id: submit
            source: "qrc:/images/yes.png";
            anchors.right: parent.right;
            width: parent.height * 0.7
            height: width
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    //console.log(toadded.text);
                    msa.focus = true;
                    if(toadded.text){
                        ST.addCombo(Qt.md5(toadded.text),toadded.text);
                        settingModel.insert(0,{
                                             "cname":Qt.md5(toadded.text),
                                             "ctitle":toadded.text
                                            })

                        toadded.text = "";
                      }

                }

            }
        }



    }
    MessageDialog {
        id:dialog
        title: "删除？";
        icon: StandardIcon.Question;
        text: "确定要删除？";
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            ST.removeCombo(todelete);
            settingModel.remove(todeleteIndex);

        }
        onNo: console.log("didn't delete")
        Component.onCompleted: visible = false
    }

    Component.onCompleted: {
        ST.initialize();
        ST.loadCombo(settingModel);
    }
    Component.onDestruction: {
        ST.loadCombo(cbItems);
    }


}


