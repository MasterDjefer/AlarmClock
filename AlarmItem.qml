import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

Rectangle
{
    property string timeText: "time"
    property string createDate: ""
    property string days: ""
    property bool isEnabled: false

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
            RowLayout
            {
                Text
                {
                    color: "white"
                    text: createDate
                }
                Text
                {
                    color: "white"
                    text: days
                }
            }
        }

        CustomSwitch
        {
            id: customSwitch

            checked: isEnabled
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
