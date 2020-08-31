import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

ColumnLayout
{
    property string description: ""

    signal descChanged(string desc)
    signal buttonDayPressed(int index, bool value)

    function setDays(days)
    {
        for (var i  = 0; i < days.length; ++i)
        {
            repeater.itemAt(i).buttonChecked = days[i]
        }
    }

    RowLayout
    {
        Repeater
        {
            id: repeater

            model: ["M", "T", "W", "T", "F", "S", "S"]

            delegate: Item
            {
                Layout.fillWidth: true
                Layout.preferredHeight: dayButton.height

                property string buttonText: ""
                property bool buttonChecked: false

                CustomButton
                {
                    id: dayButton

                    anchors.horizontalCenter: parent.horizontalCenter
                    property bool checked: buttonChecked
                    buttonText: modelData
                    color: checked ? "white" : "grey"
                    width: 50
                    height: 50
                    radius: 26
                    fontSize: 18

                    onButtonPressed:
                    {
                        buttonChecked = !buttonChecked
                        buttonDayPressed(index, buttonChecked)
                    }
                }
            }
        }
    }

    TextField
    {
        text: description
        font.pixelSize: 20
        placeholderText: "Enter description here"

        style: TextFieldStyle
        {
            placeholderTextColor: "grey"
            textColor: "grey"
            background: Item
            {
                implicitWidth: 220
                    Rectangle
                    {
                        color: "grey"
                        height: 3
                        width: parent.width
                        anchors.bottom: parent.bottom
                    }
            }
        }

        onTextChanged:
        {
            descChanged(text)
        }
    }
}
