import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls

Scope {
    // Mocking the missing global contexts so it doesn't crash
    QtObject {
        id: color
        property color cbodyStroke: Qt.rgba(255, 1, 1, 0.5) // semi-transparent white stroke
    }

    QtObject {
        id: config
        readonly property int popupNone: 0
        readonly property int popupActive: 1
    }

    // Wrap in a real PanelWindow so Quickshell maps it to your desktop
    PanelWindow {
        id: smth

        // Correctly attaching Wayland protocols to a window type
        // WlrLayershell.namespace: "diinki_celestialantiquity:bars"
        exclusionMode: ExclusionMode.Ignore
        //WlrLayershell.keyboardFocus:

        // Fix the layout positioning so it hugs the left side of the screen
        anchors {
            top: true
            bottom: true
            left: true
            right: false
        }
        implicitWidth: 115
        color: Qt.rgba(0, 0, 0, 0) // Transparent window backdrop

        // State Properties
        property int currentPopup: config.popupNone
        property bool isOpen: false

        function closeAllPopups() {
            currentPopup = config.popupNone;
            isOpen = false;

        }
        // The Visual Curve
        Item {
            id: radialBarCurve
            anchors.fill: parent

            property point pointA: Qt.point(0, parent.height - parent.height / 1.38)

            property point pointB: Qt.point(0, parent.height / 1.38)
            property real curvature: mfmousearea.containsMouse ? 120 : 60
            onCurvatureChanged: {
                curveCanvas.requestPaint();
            }
            Behavior on curvature {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutSine
                }
            }
            Rectangle {
                color: "transparent"
                width: parent.width
                height: parent.height
                MouseArea {
                    id: mfmousearea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                }
            }
            function controlPoint(a, b, curve) {
                var midX = (a.x + b.x) / 2;
                var midY = (a.y + b.y) / 2;
                return Qt.point(midX + curve, midY);
            }
            Canvas {
                id: curveCanvas
                anchors.fill: parent
                property color curveblack: "black"

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    var cp = radialBarCurve.controlPoint(radialBarCurve.pointA, radialBarCurve.pointB, radialBarCurve.curvature);
                    ctx.beginPath();
                    ctx.moveTo(radialBarCurve.pointA.x, radialBarCurve.pointA.y);
                    ctx.quadraticCurveTo(cp.x, cp.y, radialBarCurve.pointB.x, radialBarCurve.pointB.y);
                     console.log(cp.x, cp.y, radialBarCurve.pointB.x, radialBarCurve.pointB.y, radialBarCurve.curvature )
                    // ctx.arcTo(cp.x, cp.y, radialBarCurve.pointB.x, radialBarCurve.pointB.y, cp.y);
                    ctx.closePath();

                    ctx.lineWidth = 1;
                    ctx.strokeStyle = color.cbodyStroke;
                    ctx.fillStyle = Qt.rgba(curveblack.r, curveblack.g, curveblack.b, 0.2);

                    ctx.fill();
                    ctx.stroke();
                }
            }
        }

        // Tap outside overlay (Fixing "somethingelse" to reference "smth")
        PanelWindow {
            id: closerPanel
            screen: smth.screen
            WlrLayershell.layer: WlrLayer.Top
            visible: smth.isOpen || smth.currentPopup != config.popupNone
            exclusionMode: ExclusionMode.Ignore
            color: Qt.rgba(0, 0, 0, 0)

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: smth.closeAllPopups()
            }
        }

    }
}
