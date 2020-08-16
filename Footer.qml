import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle
{
    //    color: "#646464"
    color: "black"
    height: 50

    property bool addButtonVisible: true

    CustomButton
    {
        radius: 25
        buttonText: "+"
        fontSize: 40
        anchors.centerIn: parent
        visible: addButtonVisible

        onButtonClicked:
        {
            appState.state = "AddNewAlarm"
            listView.setUnselectedItems()
        }
    }
}
