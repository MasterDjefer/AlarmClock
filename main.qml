import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

import Sessions 1.0
import Models 1.0

Window
{
    id: window

    visible: true
    width: 400
    height: 480
    title: "Hello World"
    color: "black"
    minimumWidth: 400
    minimumHeight: 600


    Component.onCompleted:
    {
        appState.state = "MainWindow"
        alarmModel.setSession(alarmSession)
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
            },
            State
            {
               name: "AlarmRingTime"
               PropertyChanges { target: mainWindow; enabled: false }
               PropertyChanges { target: alarmOption; visible: false }
            }
       ]
    }

    AlarmModel
    {
        id: alarmModel
    }

    AlarmSession
    {
        id: alarmSession

        onAlarmRingTime:
        {
            var component = Qt.createComponent("AlarmRingForm.qml")
            var item = component.createObject(window, { "width": 320, "height": 200, "color": "grey", "radius": 5,
                                                        "timeText": alarmModel.getTime(index),
                                                        "descriptionText": alarmModel.getDescription(index) })

            item.okButtonClicked.connect(function()
            {
                listView.itemAtIndex(index).changeChecked(false)
                appState.state = "MainWindow"
                item.destroy()
            })

            appState.state = "AlarmRingTime"
        }
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

            delegate: AlarmItem
            {
                color: model.isSelected ? selectedColor : primeryColor

                width: listView.width
                height: 70

                //models data
                timeText: model.time
                createDate: model.createDate

                readonly property color primeryColor: "black"
                readonly property color selectedColor: "#474747"

                onAlarmClicked:
                {
                    if (!model.isSelected)
                    {
                        alarmModel.unselectItems()

                        var desc = model.description
                        //for issue with empty description
                        if (desc === "")
                        {
                            alarmOption.description = "temp"
                        }

                        addAlarmForm.hour = model.hour
                        addAlarmForm.minute = model.minute
                        alarmOption.description = desc
                        addAlarmForm.title = "Edit alarm"
                        appState.state = "EditAlarm"
                        //for issue with position item in view
                        timer.start()
                    }
                    else
                    {
                        appState.state = "MainWindow"
                    }

                    model.isSelected = !model.isSelected
                }

                onSwitchClicked:
                {
                    model.isEnabled = value
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
                listView.positionViewAtIndex(alarmModel.selectedItemIndex(), ListView.Contain)
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
                alarmModel.updateDescription(alarmModel.selectedItemIndex(), desc)
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
                alarmModel.remove(alarmModel.selectedItemIndex())
                appState.state = "MainWindow"
            }
            onAddButtonClicked:
            {
                addAlarmForm.hour = 0
                addAlarmForm.minute = 0
                addAlarmForm.title = "Add new alarm"
                appState.state = "AddNewAlarm"
                alarmModel.unselectItems()
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
            alarmModel.unselectItems()
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
                alarmModel.updateTime(alarmModel.selectedItemIndex(), hour, minute)
                alarmModel.unselectItems()
            }

            appState.state = "MainWindow"
        }
    }
}
