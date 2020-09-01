import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
import Qt.labs.settings 1.0

import Sessions 1.0
import Models 1.0

Window
{
    id: window

    visible: true
    width: 400
    height: 600
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

    Shortcut
    {
        sequence: "Esc"
        onActivated:
        {
            alarmModel.unselectItems()
            appState.state = "MainWindow"
        }
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
            var item = component.createObject(window, { "color": "grey", "radius": 5,
                                                        "timeText": alarmModel.getTime(index),
                                                        "descriptionText": alarmModel.getDescription(index) })

            item.width = Qt.binding(function() { return window.width * 0.35 * 1.8 })
            item.height = Qt.binding(function() { return window.width * 0.35 })
            item.x = Qt.binding(function() { return window.width / 2 - item.width / 2 })
            item.y = Qt.binding(function() { return window.height / 2 - item.height / 2 })

            item.okButtonClicked.connect(function()
            {
                listView.itemAtIndex(index).changeChecked(false)
                appState.state = "MainWindow"
                alarmSession.stopSong()
                item.destroy()
            })

            alarmModel.unselectItems()
            appState.state = "AlarmRingTime"
        }
    }

    ColumnLayout
    {
        id: mainWindow
        spacing: 1
        anchors.fill: parent

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
                        alarmOption.description = desc
                        alarmOption.setDays(model.repeatOnDays)

                        addAlarmForm.hour = model.hour
                        addAlarmForm.minute = model.minute
                        addAlarmForm.title = "Edit alarm"
                        addAlarmForm.songName = model.songName
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

            Layout.fillWidth: true
            height: 100

            onDescChanged:
            {
                alarmModel.updateDescription(alarmModel.selectedItemIndex(), desc)
            }

            onButtonDayPressed:
            {
                alarmModel.updateRepeatOnDays(alarmModel.selectedItemIndex(), index, value)
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
                addAlarmForm.songName = ""
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
        x: mainWindow.width / 2 - width / 2
        y: mainWindow.height / 2 - height / 2
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

        onMusicChooserClicked:
        {
            fileDialog.visible = true
        }
    }

    FileDialog
    {
        id: fileDialog

        title: "Please choose a file"
        folder: shortcuts.home
        nameFilters: [ "Music files (*.mp3 *.wav)" ]
        visible: false

        onAccepted:
        {
            var extraStr = "file://"
            var songPath = String(fileDialog.fileUrls)
            songPath = songPath.slice(extraStr.length)
            alarmModel.updateSong(alarmModel.selectedItemIndex(), songPath)
            addAlarmForm.songName = alarmModel.getSongName(alarmModel.selectedItemIndex())
        }
    }
}
