import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle
{
    property string title: ""
    property int hour: 0
    property int minute: 0

    signal cancelButtonClicked()
    signal okButtonClicked()

    function formatText(value)
    {
        return value < 10 ? "0" + value : value
    }

    MouseArea
    {
        anchors.fill: parent
    }

    Component
    {
        id: delegateComponent

        Label
        {
            text: formatText(index)
            font.pixelSize: 20
            color: "white"
            opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Label
    {
        color: "white"
        text: title
        font.pixelSize: 17
    }


    RowLayout
    {
        anchors.fill: parent

        Tumbler
        {
            id: hoursTumbler
            model: 24
            Layout.alignment: Qt.AlignCenter
            delegate: delegateComponent
            currentIndex: hour
        }
        Tumbler
        {
            id: minutesTumbler
            model: 60
            Layout.alignment: Qt.AlignCenter
            delegate: delegateComponent
            currentIndex: minute
        }
    }

    RowLayout
    {
        anchors
        {
            bottom: parent.bottom
            right: parent.right
        }

        TextButton
        {
            text: "Cancel"

            onTextClicked:
            {
                cancelButtonClicked()
            }
        }
        TextButton
        {
            text: "Ok"

            onTextClicked:
            {
                hour = hoursTumbler.currentIndex
                minute = minutesTumbler.currentIndex
                okButtonClicked()
            }
        }
    }
}
