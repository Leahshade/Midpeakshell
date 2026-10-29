import Quickshell
import QtQuick 2.0
import QtQuick

Scope{
    PanelWindow{
        id: bar
        exclusionMode: ExclusionMode.Ignore
        // color: "transparent"
        anchors{
            top: true
            bottom: true
            left: true
            right: false
        }
        implicitWidth: 115
         color: Qt.rgba(255, 0, 0, 0.1) // Transparent window backdrop

        Item{
            id: barcurve
            anchors.fill: parent
            property var pointA: Qt.point(0, parent.height )
            property point pointB1: Qt.point(0, parent.height)





        }



    }





}
