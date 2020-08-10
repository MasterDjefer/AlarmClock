import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle
{
    color: "#646464"
    height: 50

    PlusButton
    {
        onButtonClicked:
        {
            appState.state = "AddNewAlarm"
        }
    }
}
