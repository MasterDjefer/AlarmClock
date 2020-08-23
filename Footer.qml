import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle
{
    property bool addButtonVisible: true
    property bool deleteButtonVisible: false
    readonly property color primeryColor: "#666666"
    readonly property color pressedColor: "#d9d8ae"

    signal deleteButtonClicked()
    signal addButtonClicked()

    CustomButton
    {
        width: 80
        height: 30
        fontSize: 20
        buttonText: "Delete"
        radius: 4
        color: primeryColor
        textColor: "white"
        visible: deleteButtonVisible
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10

        onButtonClicked:
        {
            deleteButtonClicked()
        }
        onButtonPressed:
        {
            color = pressedColor
        }
        onButtonReleased:
        {
            color = primeryColor
        }
    }

    CustomButton
    {
        width: 50
        height: 50
        radius: 25
        buttonText: "+"
        fontSize: 40
        color: primeryColor
        anchors.centerIn: parent
        visible: addButtonVisible

        onButtonClicked:
        {
            addButtonClicked()
        }
        onButtonPressed:
        {
            color = pressedColor
        }
        onButtonReleased:
        {
            color = primeryColor
        }
    }
}
