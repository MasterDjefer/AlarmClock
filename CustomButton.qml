import QtQuick 2.0

Rectangle
{
    width: 50
    height: 50

    signal buttonClicked

    color: mouseArea.containsMouse ? "#d9d8ae" : "grey"

    property string buttonText: ""
    property int fontSize: 10
    property color textColor: "black"

    Text
    {
        text: buttonText
        font.pixelSize: fontSize
        anchors.centerIn: parent
        color: textColor
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

