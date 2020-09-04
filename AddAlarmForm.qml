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

    property string songName: ""

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
    Rectangle
    {
        anchors.top: parent.top
        width: parent.width
        height: titleLabel.height
        color: "grey"
        Label
        {
            id: titleLabel

            color: "white"
            text: title
            font.pixelSize: 17
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }


    RowLayout
    {
        anchors.fill: parent
        anchors.bottomMargin: parent.height * 0.2

        Tumbler
        {
            id: hoursTumbler
            model: 24
            Layout.alignment: Qt.AlignCenter
            delegate: delegateComponent
            currentIndex: hour

            Rectangle
            {
                anchors.horizontalCenter: hoursTumbler.horizontalCenter
                y: hoursTumbler.height * 0.4
                width: 40
                height: 2
                color: "#8A7960"
            }

            Rectangle
            {
                anchors.horizontalCenter: hoursTumbler.horizontalCenter
                y: hoursTumbler.height * 0.6
                width: 40
                height: 2
                color: "#8A7960"
            }
        }
        Tumbler
        {
            id: minutesTumbler
            model: 60
            Layout.alignment: Qt.AlignCenter
            delegate: delegateComponent
            currentIndex: minute

            Rectangle
            {
                anchors.horizontalCenter: minutesTumbler.horizontalCenter
                y: minutesTumbler.height * 0.4
                width: 40
                height: 2
                color: "#8A7960"
            }

            Rectangle
            {
                anchors.horizontalCenter: minutesTumbler.horizontalCenter
                y: minutesTumbler.height * 0.6
                width: 40
                height: 2
                color: "#8A7960"
            }
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
            elide: Text.ElideRight
            font.pixelSize: 20
            anchors.leftMargin: 5
            anchors.verticalCenter: parent.verticalCenter
        }
        Text
        {
            width: parent.width * 0.85
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            text: songName
            color: "#C1C1C1"
            font.pixelSize: 15
            elide: Text.ElideRight
            anchors.bottomMargin: parent.height *0.1
            anchors.leftMargin: 2
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
        height: parent.height * 0.15
        anchors.bottom: navigation.top
        anchors.bottomMargin: 5
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
        width: parent.width
        height: parent.height * 0.1
        anchors
        {
            bottom: parent.bottom
        }
        TextButton
        {
            Layout.leftMargin: parent.width * 0.15
            Layout.bottomMargin: parent.height * 0.5
            text: "Cancel"
            Layout.alignment: Qt.AlignLeft
            onTextClicked:
            {
                cancelButtonClicked()
            }
        }
        TextButton
        {
            Layout.rightMargin: parent.width * 0.2
            Layout.bottomMargin: parent.height * 0.5
            text: "Ok"
            Layout.alignment: Qt.AlignRight
            onTextClicked:
            {
                hour = hoursTumbler.currentIndex
                minute = minutesTumbler.currentIndex
                okButtonClicked()
            }
        }
    }
}
