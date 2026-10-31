import Quickshell
import QtQuick 2.0
import QtQuick
import Quickshell.Wayland
import QtQuick.Controls
import QtQuick.Shapes.DesignHelpers 6.12

Scope{
    QtObject {
        id: outline
        property color cbodyStroke: Qt.rgba(255, 1, 1, 0.5) // semi-transparent white stroke
    }

    PanelWindow{
        id: bar
        exclusionMode: ExclusionMode.Ignore
        // color: "transparent"
        anchors{
            top: true
            bottom: true
            left: false
            right: true
        }
        // margins{
        //     top: 100
        //     bottom: 100
        // }
        // implicitWidth: (barmousearea.containsMouse ? 50: 20) - 20
            // Keys.onPressed: (event) => {
            //     if ()

            // }
        implicitWidth: (barmousearea.containsMouse ? 50: 0)
        Behavior on implicitWidth{
            NumberAnimation{
                    duration: 175
                easing{
                    type: Easing.InOutQuad


                }
            }
        }
        implicitHeight: 270
        // implicitHeight: (barmousearea.containsMouse ? 50: 20) + 10
        // Behavior on implicitHeight{
        //     NumberAnimation{
        //         duration: 175
        //         easing{
        //             type: Easing.InOutQuad
        //         }
        //     }
        // }
          color: Qt.rgba(255, 0, 0, 0.1) // Transparent window backdrop

        Item{
            id: barcurve
            anchors.fill: parent
            property point pointA: Qt.point(0, parent.height )
            property point pointB1: Qt.point(0, parent.height)
            property real curvature: barmousearea.containsMouse ? 115: 12
            property real curveHeight: barmousearea.containsMouse ? 400: 400
            property real shift: barmousearea.containsMouse ?  -(bar.implicitHeight / 2 ) + 150 : 10
            onCurvatureChanged: {0
                curvemove.requestPaint()
            }
            Behavior on shift{
                NumberAnimation{
                    duration: 175
                    easing{
                        type: Easing.InOutQuad
                        amplitude: 1.0
                          period: 0.5
                    }

                }
            }
            Behavior on curvature{
                NumberAnimation{
                    duration: 2000
                    easing.type: Easing.OutExpo

                }
            }
            Behavior on curveHeight{
                NumberAnimation{
                    duration: 2000
                    easing.type: Easing.OutExpo
                }
            }

            // Rectangle{
            //     color: "white"
            //     width: parent.width
            //     height: parent.height
            // }

            function controlPoint(a, b, curve) {
                var midX = (a.x + b.x) / 2;
                var midY = (a.y + b.y) / 2;
                return Qt.point(midX + curve, midY);
            }


            Canvas{
                id: curvemove
                anchors.fill: parent
                property color curvecolor: "black"
                EllipseShape{
                    fillColor: "transparent"
                    strokeColor: "transparent"
                    height: 400
                    width: parent.width + 50
                    y: 270
                    x:  15
                }
                Rectangle{
                    color: Qt.rgba(0, 0, 0, 0) // Transparent window backdrop

                    // color: "transparent"
                    width: parent.width
                    height: 400
                    y: 270
                    MouseArea{
                        id: barmousearea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton

                    }
                }
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0,0, width, height);

                    ctx.beginPath();
                    ctx.ellipse(barcurve.shift, bar.implicitHeight , barcurve.curvature , barcurve.curveHeight);
                    console.log(barcurve.shift, bar.implicitHeight, barcurve.curvature, barcurve.curveHeight)
                    ctx.closePath()

                    ctx.lineWidth = 1;
                    ctx.strokeStyle = outline.cbodyStroke;
                    ctx.fillStyle = Qt.rgba(123, 24, 0, 0.1);

                    ctx.fill();
                    ctx.stroke();


                }


            }




        }



    }





}
