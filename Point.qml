import QtQuick 2.12
import QtLocation 5.6

MapCircle {
    objectName: "mark"
    property int myId: 0
    id: circle
    color: 'black'
    radius: rad[Math.floor(map.zoomLevel)]
    visible: true

    signal newPoint(var coord, int iD)
    signal del(var center, int iD)

    Drag.dragType: Drag.Automatic

    MouseArea {
        id: circleMa
        anchors.fill: parent
        drag.target: parent

        onClicked: {
            del(center, myId)
        }
        onReleased: {
            newPoint(center, myId)
        }
    }
}
