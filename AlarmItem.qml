import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

Rectangle
{
    property bool selected: false
    color: selected ? "#474747" : "black"

    signal alarmClicked
    signal switchClicked(bool value)

    property string timeText: "time"
    property string createDate: ""
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
            Text
            {
                color: "white"
                text: createDate
            }
        }

        CustomSwitch
        {
            id: customSwitch

            isEnabled: isSwitchEnabled
            Layout.alignment: Qt.AlignRight

            onCheckedChanged:
            {
                switchClicked(checked)
            }
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
