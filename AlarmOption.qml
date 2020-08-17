import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4


Rectangle
{
    property string description: ""

    TextField
    {
        anchors.verticalCenter: parent.verticalCenter
        x: 5
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
            //here send new data to backend
            console.log(text)
        }
    }
}
