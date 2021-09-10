import QtQuick 2.15
import QtLocation 5.11
import QtPositioning 5.11

Map {
    id: map
    property int iD: 0
    property var rad: [140500, 95500, 50200, 30200, 17200, 7000, 5000, 3250, 1500, 955, 455, 175, 90, 45, 25, 15, 9, 5, 2]
    property var objectsPool: []
    property double mx: 0.0
    property double my: 0.0

    property int distance: 0

    anchors.fill: parent
    zoomLevel: 15

    plugin: Plugin {
        id: plugin
        name: 'osm'
    }

    MapCircle {
        id: handle
        center: map.toCoordinate(line.mapToItem(map, map.mx, map.my))
        radius: rad[Math.floor(map.zoomLevel)]
        color: 'red'
        visible: line.onLine ? true : false
    }

    MouseArea {
        id: mapMa
        anchors.fill: parent
        onClicked: {
           let coord = map.toCoordinate(Qt.point(mouseX, mouseY))
           let m = createPoint(coord)
           line.addCoordinate(coord)
           objectsPool.push(m)
           calcDistance()
        }
    }

    MapPolyline {
        id: line
        line.width: 5
        property bool onLine: false
        MouseArea {
            anchors.fill: parent
            containmentMask: line
            hoverEnabled: true

            onHoveredChanged: {
                parent.onLine = !parent.onLine
            }

            onMouseXChanged: {
                map.mx = mouseX
            }
            onMouseYChanged: {
                map.my = mouseY
            }

            onClicked: {
                insertBetween(mouse.x, mouse.y)
            }
        }
    }

    function updatePath(coord, iD) {
        var path = line.path
        path[iD] = coord
        line.path = path
        calcDistance()
    }

    function insertBetween(x, y) {
        let newDot = map.toCoordinate(line.mapToItem(map, x, y))
        let arr = []

        for (let i = 0; i < objectsPool.length-1; i++) {
            let aLat = objectsPool[i].center.latitude
            let aLon = objectsPool[i].center.longitude
            let bLat = objectsPool[i+1].center.latitude
            let bLon = objectsPool[i+1].center.longitude

            let m = ( bLat - aLat ) * ( newDot.longitude - aLon ) - ( bLon - aLon ) * ( newDot.latitude - aLat )
            arr.push(Math.abs(m))
        }

        let min = Math.min.apply(Math, arr)
        let ind = arr.indexOf(min) + 1

        var point = createPoint(newDot)
        line.insertCoordinate(ind, newDot)
        objectsPool.splice(ind, 0, point)
        updateIndexes(ind)
        calcDistance()

    }

    function deletePoint(center, iD) {
        line.removeCoordinate(center)
        map.removeMapItem(objectsPool[iD])
        objectsPool.splice(iD, 1)
        updateIndexes(iD)
        calcDistance()
    }

    function updateIndexes(ind){
        for (let i = ind; i < objectsPool.length; i++) {
            objectsPool[i].myId = i
        }
    }

    function calcDistance(){
        let dist = 0
        for (let i = 0; i < objectsPool.length-1; i++) {
            dist += objectsPool[i].center.distanceTo(objectsPool[i+1].center)
        }
        distance = dist
    }

    function createPoint(coord){
       let elCount = objectsPool.length
       var component = Qt.createComponent("Point.qml");
       if (component.status === Component.Ready){
          var obj = component.createObject(map, { myId: elCount, center: coord });
          obj.newPoint.connect(updatePath)
          obj.del.connect(deletePoint)
          map.addMapItem(obj)
          return obj
       }
    }
}
