import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

ColumnLayout
{
    property string description: ""

    signal descChanged(string desc)
    signal buttonDayPressed(int index, bool value)

    RowLayout
    {
        Repeater
        {
            model: ["M", "T", "W", "T", "F", "S", "S"]

            delegate: Item
            {
                Layout.fillWidth: true
                Layout.preferredHeight: dayButton.height

                property string buttonText: ""

                CustomButton
                {
                    id: dayButton

                    anchors.horizontalCenter: parent.horizontalCenter
                    property bool checked: false
                    buttonText: modelData
                    color: checked ? "white" : "grey"
                    width: 50
                    height: 50
                    radius: 26
                    fontSize: 18

                    onButtonPressed:
                    {
                        checked = !checked
                        buttonDayPressed(index, checked)
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
