import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle
{
    property string title: ""
    property string hour: ""
    property string minute: ""

    signal cancelButtonClicked()
    signal okButtonClicked()

    function formatText(value)
    {
        return value < 10 ? "0" + value : value
    }

    function setTime(h, m)
    {
        hour = h
        minute = m
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
        }
        Tumbler
        {
            id: minutesTumbler
            model: 60
            Layout.alignment: Qt.AlignCenter
            delegate: delegateComponent
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
                setTime(hoursTumbler.currentItem.text, minutesTumbler.currentItem.text)
                okButtonClicked()
            }
        }
    }
}
