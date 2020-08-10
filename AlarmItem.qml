import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

Rectangle
{
    property bool selected: false
    color: selected ? "#474747" : "black"

    signal alarmClicked

    property string timeText: "time"
    property bool isSwitchEnabled: false

    RowLayout
    {
        anchors.fill: parent

        ColumnLayout
        {
            Text
            {
                text: timeText
                color: "white"
                font.pixelSize: 30
            }
        }

        CustomSwitch
        {
            id: customSwitch

            isEnabled: isSwitchEnabled

            Layout.alignment: Qt.AlignRight
        }
    }

    MouseArea
    {
        id: mouseArea

        width: parent.width - customSwitch.width
        height: parent.height

        onClicked:
        {
            alarmClicked()
        }
    }
}
