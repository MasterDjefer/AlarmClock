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
    minimumWidth: 400
    minimumHeight: 600

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
               PropertyChanges { target: footer; deleteButtonVisible: false }
            },
            State
            {
               name: "AddNewAlarm"
               PropertyChanges { target: mainWindow; visible: true; enabled: false }
               PropertyChanges { target: addAlarmForm; visible: true }
               PropertyChanges { target: alarmOption; visible: false }
               PropertyChanges { target: footer; deleteButtonVisible: false }
               StateChangeScript { script: changeAddAlarmFormTitle() }
            },
            State
            {
               name: "EditAlarm"
               PropertyChanges { target: alarmOption; visible: true }
               PropertyChanges { target: mainWindow; visible: true; enabled: true }
               PropertyChanges { target: addAlarmForm; visible: true }
               PropertyChanges { target: footer; visible: true }
               PropertyChanges { target: footer; addButtonVisible: false }
               PropertyChanges { target: footer; deleteButtonVisible: true }
               StateChangeScript { script: changeAddAlarmFormTitle() }
            }
       ]
    }

    function changeAddAlarmFormTitle()
    {
        addAlarmForm.title = appState.state === "AddNewAlarm" ? "Add new alarm" : "Edit alarm"
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
                color: selected ? selectedColor : primeryColor

                width: listView.width
                height: 70

                //models data
                timeText: model.time
                switchEnabled: model.isEnabled
                createDate: model.createDate

                property bool selected: false
                readonly property color primeryColor: "black"
                readonly property color selectedColor: "#474747"

                onAlarmClicked:
                {
                    if (!selected)
                    {
                        currentListIndex = index
                        listView.setUnselectedItems()
                        var desc = alarmModel.getDescription(currentListIndex)
                        if (desc === "")
                        {
                            alarmOption.description = "temp"
                        }

                        alarmOption.description = desc
                        appState.state = "EditAlarm"
                        timer.start()
                    }
                    else
                    {
                        appState.state = "MainWindow"
                        currentListIndex = -1
                    }

                    selected = !selected
                }

                onSwitchClicked:
                {
                    alarmModel.updateEnabledState(index, value)
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

            color: "black"
            Layout.fillWidth: true
            height: 100

            onDescChanged:
            {
                alarmModel.updateDescription(currentListIndex, desc)
            }
        }

        Footer
        {
            id: footer
            Layout.fillWidth: true
            color: "black"
            height: 50

            onDeleteButtonClicked:
            {
                alarmModel.remove(currentListIndex)
                appState.state = "MainWindow"
            }
            onAddButtonClicked:
            {
                appState.state = "AddNewAlarm"
                listView.setUnselectedItems()
            }
        }
    }

    AddAlarmForm
    {
        id: addAlarmForm

        color: "#646464"
        width: mainWindow.width * 0.5
        height: mainWindow.height * 0.5
        anchors.centerIn: parent
        visible: false

        onCancelButtonClicked:
        {
            listView.setUnselectedItems()
            appState.state = "MainWindow"
        }
        onOkButtonClicked:
        {
            if (appState.state === "AddNewAlarm")
            {
                alarmModel.add(hour, minute)
            }
            else
            {
                alarmModel.updateTime(currentListIndex, hour, minute)
                listView.setUnselectedItems()
            }

            appState.state = "MainWindow"
        }
    }
}
