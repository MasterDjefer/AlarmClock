import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle
{
    id: alarmRingTime

    anchors.centerIn: parent

    property int imageSize: height * 0.9
    property string timeText: ""
    property string descriptionText: ""

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
            Text
            {
                id: alarmTime
                text: timeText
                font.pixelSize: 30
                color: "white"
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                Layout.topMargin: (alarmRingTime.height - alarmRingTime.imageSize) / 2

            }
            Text
            {
                id: alarmDescription
                text: descriptionText
                elide: Text.ElideRight
                font.pixelSize: 20
                Layout.fillHeight: true
                color: "white"
                Layout.preferredWidth: alarmRingTime.width - alarmRingTime.imageSize - (alarmRingTime.height - alarmRingTime.imageSize)
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
            okButtonClicked()
        }
    }
}
