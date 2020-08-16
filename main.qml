import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

import Models 1.0

Window
{
    visible: true
    width: 400
    height: 480
    title: "Hello World"
    color: "black"
    minimumWidth: 300
    minimumHeight: 400

    property int currentListIndex: -1


    Component.onCompleted:
    {
        appState.state = "MainWindow"
    }

    Item
    {
        id: appState

        states: [
            State
            {
               name: "MainWindow"
               PropertyChanges { target: mainWindow; visible: true; enabled: true }
               PropertyChanges { target: addAlarmForm; visible: false }
               PropertyChanges { target: footer; visible: true }
               PropertyChanges { target: alarmOption; visible: false }
               PropertyChanges { target: deleteAlarmButton; visible: false }
            },
            State
            {
               name: "AddNewAlarm"
               PropertyChanges { target: mainWindow; visible: true; enabled: false }
               PropertyChanges { target: addAlarmForm; visible: true }
               PropertyChanges { target: alarmOption; visible: false }
               PropertyChanges { target: deleteAlarmButton; visible: false }
            },
            State
            {
               name: "EditAlarm"
               PropertyChanges { target: alarmOption; visible: true }
               PropertyChanges { target: mainWindow; visible: true; enabled: true }
               PropertyChanges { target: addAlarmForm; visible: true }
               PropertyChanges { target: footer; visible: true }
               PropertyChanges { target: footer; addButtonVisible: false }
               PropertyChanges { target: deleteAlarmButton; visible: true }
            }
       ]
    }

    AlarmModel
    {
        id: alarmModel
    }

    ColumnLayout
    {
        id: mainWindow
        spacing: 1
        anchors
        {
            fill: parent
        }

        ListView
        {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: alarmModel

            function setUnselectedItems()
            {
                for (var i = 0; i < listView.count; ++i)
                {
                    listView.itemAtIndex(i).selected = false
                }
            }


            delegate: AlarmItem
            {
                width: listView.width
                height: 70

                //models data
                timeText: model.time
                isSwitchEnabled: model.isEnabled

                onAlarmClicked:
                {
                    if (!selected)
                    {
                        listView.setUnselectedItems()
                    }
                    selected = !selected


                    alarmOption.description = alarmModel.getDescription(index)

                    appState.state = selected ? "EditAlarm" : "MainWindow"
                    currentListIndex = index
                    timer.start()
                }
            }
        }

        Timer
        {
            id: timer
            interval: 10
            running: false
            repeat: false

            onTriggered:
            {
                if (currentListIndex !== -1)
                {
                    listView.positionViewAtIndex(currentListIndex, ListView.Contain)
                }
            }
        }

        AlarmOption
        {
            id: alarmOption

//            color: "#646464"
            color: "black"
            Layout.fillWidth: true
            height: 100
        }

        Footer
        {
            id: footer
            Layout.fillWidth: true

            CustomButton
            {
                id: deleteAlarmButton

                width: 80
                height: 30
                fontSize: 20
                buttonText: "Delete"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10

                onButtonClicked:
                {
                    alarmModel.remove(currentListIndex)
                    appState.state = "MainWindow"
                }
            }
        }
    }

    AddAlarmForm
    {
        id: addAlarmForm

        width: mainWindow.width * 0.5
        height: mainWindow.height * 0.7
        anchors.centerIn: parent
        visible: false
    }
}
