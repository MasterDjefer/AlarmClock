import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle
{
    property string title: ""
    property int hour: 0
    property int minute: 0

    signal cancelButtonClicked()
    signal okButtonClicked()
    signal musicChooserClicked()

    function formatText(value)
    {
        return value < 10 ? "0" + value : value
    }

    MouseArea
    {
        anchors.fill: parent
    }

    MouseArea
    {
        width: parent.width
        height: titleLabel.height
        drag.target: parent
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
        id: titleLabel

        color: "white"
        text: title
        font.pixelSize: 17
        anchors.horizontalCenter: parent.horizontalCenter
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

    Rectangle
    {
        Rectangle
        {
            anchors.top: parent.top
            width: parent.width
            height: 2
            color: "grey"

        }

        Text
        {
            anchors.top: parent.top
            anchors.left: parent.left
            text: "Sound"
            color: "#C1C1C1"
            font.pixelSize: 20
            anchors.leftMargin: 5
            anchors.topMargin: 5
        }
        Text
        {
            width: parent.width - 10
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            text: "i love rock n rolsdfsdfsdfsdfsdfsdfdsfdsfdsfdsfdsfl"
            color: "#C1C1C1"
            font.pixelSize: 15
            elide: Text.ElideRight
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
        }
        Text
        {
            anchors.rightMargin: 5
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: ">"
            font.pixelSize: 30
            color: "#B6B6B6"
        }

        width: parent.width
        height: 50
        y: navigation.y - height - 10
        color: "#646464"

        MouseArea
        {
            anchors.fill: parent

            hoverEnabled: true
            onClicked:
            {
                musicChooserClicked()
            }            
            onEntered:
            {
                cursorShape = Qt.OpenHandCursor
            }
            onExited:
            {
                cursorShape = Qt.ArrowCursor
            }
        }

        Rectangle
        {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 2
            color: "grey"
        }
    }

    RowLayout
    {
        id: navigation
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
