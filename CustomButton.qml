import QtQuick 2.0

Rectangle
{
    signal buttonClicked()
    signal buttonPressed()
    signal buttonReleased()

    property string buttonText: "test"
    property int fontSize: 10
    property color textColor: "black"
    property bool changeColorOnClick: false
    property color colorOnPressed: "black"
    property color colorOnReleased: "black"

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
            if (changeColorOnClick)
            {
                colorOnReleased = color
                color = colorOnPressed
            }

            buttonPressed()
        }

        onReleased:
        {
            if (changeColorOnClick)
            {
                color = colorOnReleased
            }

            buttonReleased()
        }
    }
}

