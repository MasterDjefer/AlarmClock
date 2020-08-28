import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

Rectangle
{
    property string timeText: "time"
    property string createDate: ""

    signal alarmClicked()
    signal switchClicked(bool value)

    function changeChecked(value)
    {
        customSwitch.checked = value
    }

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

            checked: false
            Layout.alignment: Qt.AlignRight

            onCheckedChanged:
            {
                switchClicked(checked)
            }
        }
    }

    MouseArea
    {
        width: parent.width - customSwitch.width
        height: parent.height

        onClicked:
        {
            alarmClicked()
        }
    }
}
