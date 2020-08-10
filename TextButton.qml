import QtQuick 2.0

Text
{
    signal textClicked

    color: mouseArea.containsMouse ? "#F62828" : "#F38383"
    font.pixelSize: 17

    MouseArea
    {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
//        cursorShape: containsMouse ? Qt.OpenHandCursor : Qt.ArrowCursor

        onClicked:
        {
            textClicked()
        }
    }
}
