import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle
{
    color: "#646464"
    height: 50

    CustomButton
    {
        radius: 25
        buttonText: "+"
        fontSize: 40
        anchors.centerIn: parent

        onButtonClicked:
        {
            appState.state = "AddNewAlarm"
            listView.setUnselectedItems()
        }
    }
}
