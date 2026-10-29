import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick 2.0
import Quickshell.Hyprland
import QtQuick.Controls.Basic
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Qt5Compat.GraphicalEffects

Scope{
        Variants {
            model: Quickshell.screenss
            Item {
                id: root
                required property var modelData

                // This is a "tap outside of popup to clise it" functionality. Might abstract it later.
                PanelWindow {
                    id: closerPanel
                    screen: root.modelData
                    WlrLayershell.layer: WlrLayer.Top
                    visible: !radialTaskbar.isOpen && radialTaskbar.currentPopup == Config.SidebarPopup.None ? false : true
                    //WlrLayershell.layer: WlrLayer.Bottom
                    exclusionMode: ExclusionMode.Ignore //Ignore
                    color: Qt.rgba(0, 0, 0, 0)
                    anchors {
                        top: true
                        bottom: true
                        left: true
                        right: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            radialTaskbar.closeAllPopups();
                        }
                    }
                }
                id: radialTaskbar
                screen: root.modelData
                WlrLayershell.layer: isOpen || currentPopup != Config.SidebarPopup.None ? WlrLayer.Top : WlrLayer.Bottom

                //WlrLayershell.layer: WlrLayer.Bottom
                exclusionMode: ExclusionMode.Ignore //Ignore
                WlrLayershell.namespace: "diinki_celestialantiquity:bars"

                property int currentPopup: Config.SidebarPopup.None

                property bool isOpen: false
                function refreshState(workspaceId) {
                    Hyprland.dispatch(`workspace ` + workspaceId);
                }
                function closeAllPopups() {
                    currentPopup = Config.SidebarPopup.None;

                    radialTaskbar.isOpen = false;
                }
                anchors {
                    top: true
                    bottom: true
                    left: true
                    right: false
                }
                implicitWidth: 115
                color: Qt.rgba(0, 0, 0, 0)

                /*
                // Close the popup when clicking outside of the window.

                */

                Item{
                    id: radialBarCurve
                    anchors.fill: parent
                    // This is kind of ugly, prolly a better way to get this kind of
                    // dynamic scale depending on screen size, but width of the screen
                    // divided by 3 is a reasonable width in my opinion.
                    property point pointA: Qt.point(0, parent.height - parent.height / 1.38)
                    property point pointB: Qt.point(0, parent.height / 1.38)
                    property real curvature: 175

                    property point innerPointA: Qt.point(0, parent.height - parent.height / 1.57)
                    property point innerPointB: Qt.point(0, parent.height / 1.57)

                    function controlPoint(a, b, curve) {
                        var midX = (a.x + b.x) / 2;
                        var midY = (a.y + b.y) / 2;
                        return Qt.point(midX + curve, midY);
                    }
                    function pointOnCurve(t, a, b) {
                        var cp = controlPoint(a, b, curvature);
                        var x = Math.pow(1 - t, 2) * pointA.x + 2 * (1 - t) * t * cp.x + Math.pow(t, 2) * pointB.x;

                        var y = Math.pow(1 - t, 2) * pointA.y + 2 * (1 - t) * t * cp.y + Math.pow(t, 2) * pointB.y;

                        return Qt.point(x, y);
                    }
                    Canvas{
                        id: curveCanvas
                        anchors.fill: parent
                        property color curveblack: "black"
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);

                            var cp = parent.controlPoint(parent.pointA, parent.pointB, parent.curvature);
                            ctx.beginPath();
                            ctx.moveTo(parent.pointA.x, parent.pointA.y);
                            ctx.quadraticCurveTo(cp.x, cp.y, parent.pointB.x, parent.pointB.y);
                            ctx.closePath();
                            ctx.lineWidth = 1;
                            ctx.strokeStyle = color.cbodyStroke;
                            ctx.fillStyle = Qt.rgba(curveblack.r, curveblack.g, curveblack.b, 0.2);

                            ctx.fill();
                            ctx.stroke();
                        }
                    }
                }

            }
        }
}
