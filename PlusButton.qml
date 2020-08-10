import QtQuick 2.0

Rectangle
{
    width: 50
    height: 50
    radius: 25
    anchors.centerIn: parent

    signal buttonClicked

    color: mouseArea.containsMouse ? "#d9d8ae" : "grey"

    Text
    {
        text: "+"
        font.pixelSize: 40
        anchors.centerIn: parent
    }

    MouseArea
    {
        id: mouseArea

        anchors.fill: parent

        onClicked:
        {
            buttonClicked()
        }
    }
}

