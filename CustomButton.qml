import QtQuick 2.0

Rectangle
{
    signal buttonClicked()
    signal buttonPressed()
    signal buttonReleased()

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

        onPressed:
        {
            buttonPressed()
        }

        onReleased:
        {
            buttonReleased()
        }
    }
}

