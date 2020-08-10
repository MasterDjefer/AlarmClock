import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Switch
{
    checked: isEnabled

    property bool isEnabled: false

    style: SwitchStyle
    {
        groove: Rectangle
        {
            id: switchGroove

            width: 60
            height: 20

            radius: 9
            border.color: "gray"
            color: control.checked ? "#b40404" : "gray"
            border.width: 1
        }

        handle: Rectangle
        {
            id: switchHandle

            width: 30
            height: 30

            radius: 9
            border.color: "gray"
            color: control.checked ? "#fb2828" : "#b5b5b5"
            border.width: 1
        }
    }
}
