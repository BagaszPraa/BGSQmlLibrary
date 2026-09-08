import QtQuick
import QtQuick.Shapes

Item {
    id: _root

    // ===== Public API =====
    property real value: 50
    property real minimumValue: 0
    property real maximumValue: 100
    property real bgOpacity: 0.5
    property color bgColor: "#000000"
    property color fillColor: "#00ff09"
    property color textColor: fillColor
    property real margin: 10
    property int textPixelSize: 40
    property bool textBold: true
    property real thickness: 50
    property bool showText: true
    property bool animated: true
    property int animationDuration: 100
    property int animationEasing: Easing.OutCubic
    property real diameter: Math.min(width, height)

    property real ratio: (maximumValue > minimumValue) ? (Math.max(
                                                              minimumValue,
                                                              Math.min(
                                                                  maximumValue,
                                                                  value)) - minimumValue)
                                                         / (maximumValue - minimumValue) : 0

    Item {
        id: shapeWrapper
        anchors.centerIn: parent
        width: _root.diameter
        height: _root.diameter

        // ===== Track layer: warna solid, opacity diterapkan sekali di sini =====
        Item {
            id: trackLayer
            anchors.fill: parent
            opacity: _root.bgOpacity
            layer.enabled: true

            Shape {
                id: trackShape
                anchors.fill: parent
                antialiasing: true

                ShapePath {
                    strokeColor: _root.bgColor
                    strokeWidth: _root.thickness
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap

                    PathAngleArc {
                        centerX: trackShape.width / 2
                        centerY: trackShape.height / 2
                        radiusX: (trackShape.width - _root.thickness) / 2
                        radiusY: (trackShape.height - _root.thickness) / 2
                        startAngle: 0
                        sweepAngle: 360
                    }
                }
            }
        }

        // ===== Progress arc (tetap solid, tidak perlu layer) =====
        Shape {
            id: shape
            anchors.fill: parent
            antialiasing: true

            ShapePath {
                strokeColor: _root.fillColor
                strokeWidth: _root.thickness
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    id: progressArc
                    centerX: shape.width / 2
                    centerY: shape.height / 2
                    radiusX: (shape.width - _root.thickness) / 2
                    radiusY: (shape.height - _root.thickness) / 2
                    startAngle: -90
                    sweepAngle: 360 * _root.ratio

                    Behavior on sweepAngle {
                        enabled: _root.animated
                        NumberAnimation {
                            duration: _root.animationDuration
                            easing.type: _root.animationEasing
                        }
                    }
                }
            }
        }
    }

    Text {
        visible: _root.showText
        anchors.centerIn: shapeWrapper
        text: Math.round(_root.value) + "%"
        color: _root.textColor
        font.pixelSize: _root.textPixelSize
        font.bold: _root.textBold
    }
}
