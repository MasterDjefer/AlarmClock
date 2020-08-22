import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3



Rectangle
{
    color: "#646464"

    property string title: ""

    function formatText(value)
    {
        return value < 10 ? "0" + value : value
    }

    MouseArea
    {
        anchors.fill: parent
    }

    Component
    {
        id: delegateComponent

        Label
        {
            text: formatText(index)
            color: "white"
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Label
    {
        color: "white"
        text: title
        font.pixelSize: 17
    }


    RowLayout
    {
        anchors.fill: parent

        Tumbler
        {
            id: hoursTumbler
            model: 24
            Layout.alignment: Qt.AlignCenter
            delegate: delegateComponent
        }
        Tumbler
        {
            id: minutesTumbler
            model: 60
            Layout.alignment: Qt.AlignCenter
            delegate: delegateComponent
        }
    }

    RowLayout
    {
        anchors
        {
            bottom: parent.bottom
            right: parent.right
        }

        TextButton
        {
            text: "Cancel"

            onTextClicked:
            {
                listView.setUnselectedItems()
                appState.state = "MainWindow"
            }
        }
        TextButton
        {
            text: "Ok"

            onTextClicked:
            {
                if (appState.state === "AddNewAlarm")
                {
                    alarmModel.add(hoursTumbler.currentItem.text, minutesTumbler.currentItem.text)
                }
                else
                {
                    alarmModel.updateTime(currentListIndex, hoursTumbler.currentItem.text, minutesTumbler.currentItem.text)
                    listView.setUnselectedItems()
                }

                appState.state = "MainWindow"
            }
        }
    }
}
