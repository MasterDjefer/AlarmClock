import QtQuick 2.0
import QtQuick.Controls 2.5


Rectangle
{
    property string description: ""

    Text
    {
        anchors.verticalCenter: parent.verticalCenter
        x: 5
        text: description

        font.pixelSize: 20
    }
}
