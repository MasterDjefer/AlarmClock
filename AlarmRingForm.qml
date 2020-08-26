import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle
{
    id: alarmRingTime

    width: 320
    height: 200
    color: "grey"
    radius: 5

    property int imageSize: height * 0.9

    signal okButtonClicked()

    Text
    {
        text: "Alarm time!"
        font.pixelSize: 30
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        color: "grey"
    }

    RowLayout
    {
        id: man
        anchors.fill: parent

        AnimatedImage
        {
            id: animation
            source: "qrc:///images/alarm1.gif"
            Layout.preferredWidth: alarmRingTime.imageSize
            Layout.preferredHeight: alarmRingTime.imageSize
            Layout.leftMargin: (alarmRingTime.height - alarmRingTime.imageSize) / 2
        }

        ColumnLayout
        {
            id: lay
            Text
            {
                id: alarmTime
                text: "15:53"
                font.pixelSize: 30
                color: "white"
            }
            Text
            {
                id: alarmDescription
                text: "description"
                font.pixelSize: 20
                color: "white"
            }
        }
    }

    CustomButton
    {
        width: 80
        height: 50
        radius: 11
        anchors.top: parent.bottom
        fontSize: 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: "grey"
        buttonText: "Ok"
        textColor: "white"

        changeColorOnClick: true
        colorOnPressed: "#d9d8ae"

        onButtonClicked:
        {
            console.log(man.width, animation.width, lay.width)
            okButtonClicked()
        }
    }
}
