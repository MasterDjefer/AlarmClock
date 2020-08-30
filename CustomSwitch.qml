import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

Switch
{
    property int handleSize: 30

    indicator: Rectangle
    {
        implicitWidth: 60
        implicitHeight: 20
        radius: 13
        color: checked ? "#b40404" : "gray"

        Rectangle
        {
            x: checked ? parent.width - width : 0
            y: parent.height / 2 - height / 2
            width: handleSize
            height: handleSize
            radius: 25
            color: checked ? "#fb2828" : "#b5b5b5"
            Behavior on x { SmoothedAnimation { velocity: 150 } }
        }
    }
}
