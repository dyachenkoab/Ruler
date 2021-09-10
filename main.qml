import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Map_{
        id: map_
        anchors.fill: parent

        Rectangle {
            width: text.width + 20
            height: 50
            color: 'white'
            border.color: 'black'
            border.width: 5
            z: 2
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            Text {
                id: text
                text: map_.distance + ' meters'
                anchors.centerIn: parent
            }
        }
    }
}
