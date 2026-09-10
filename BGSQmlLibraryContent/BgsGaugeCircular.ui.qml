// GaugeMeter.qml
import QtQuick 2.11
import QtQuick.Shapes 1.11

Item {
    id: _root

    // ===== Public API =====
    property real value: 50
    property real minimumValue: 0
    property real maximumValue: 100
    property real bgOpacity: 0.5
    property color bgColor: "#000000"

    // ===== Warna gradien (menggantikan fillColor solid tunggal) =====
    property bool useGradient: true
    property color fillColor: "#0018ff" // dipakai kalau useGradient: false
    property color colorLow: "#00e676" // warna saat value mendekati minimumValue
    property color colorMid: "#ffea00" // warna saat value di tengah (opsional)
    property color colorHigh: "#ff1744" // warna saat value mendekati maximumValue
    property bool useMidColor: true // set false untuk gradien 2-warna saja (low -> high)

    property color textColor: _root.progressColor
    property int textPixelSize: 50
    property bool textBold: true
    property real thickness: 50
    property bool showText: true
    property bool animated: true
    property int animationDuration: 100
    property int animationEasing: Easing.OutCubic
    property real diameter: Math.min(width, height)
    property string textUnit: "m/s"
    property string textName: "Airspeed"

    property real ratio: (maximumValue > minimumValue) ? (Math.max(
                                                              minimumValue,
                                                              Math.min(
                                                                  maximumValue,
                                                                  value)) - minimumValue)
                                                         / (maximumValue - minimumValue) : 0

    // ===== Fungsi interpolasi linear antar 2 warna =====
    function lerpColor(c1, c2, t) {
        var tt = Math.max(0, Math.min(1, t))
        return Qt.rgba(c1.r + (c2.r - c1.r) * tt, c1.g + (c2.g - c1.g) * tt,
                       c1.b + (c2.b - c1.b) * tt, c1.a + (c2.a - c1.a) * tt)
    }

    // ===== Warna progress akhir: gradien 2 atau 3 stop, atau solid =====
    property color progressColor: {
        if (!useGradient) {
            return fillColor
        }
        if (useMidColor) {
            return (ratio <= 0.5) ? lerpColor(colorLow, colorMid,
                                              ratio / 0.5) : lerpColor(
                                        colorMid, colorHigh,
                                        (ratio - 0.5) / 0.5)
        }
        return lerpColor(colorLow, colorHigh, ratio)
    }
    Item {
        id: shapeWrapper
        anchors.centerIn: parent
        width: _root.diameter
        height: _root.diameter

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
                        startAngle: 160
                        sweepAngle: 220
                    }
                }
            }
        }

        Shape {
            id: shape
            anchors.fill: parent
            antialiasing: true

            ShapePath {
                id: progressPath
                strokeColor: _root.progressColor
                strokeWidth: _root.thickness
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                Behavior on strokeColor {
                    enabled: _root.animated
                    ColorAnimation {
                        duration: _root.animationDuration
                        easing.type: _root.animationEasing
                    }
                }

                PathAngleArc {
                    id: progressArc
                    centerX: shape.width / 2
                    centerY: shape.height / 2
                    radiusX: (shape.width - _root.thickness) / 2
                    radiusY: (shape.height - _root.thickness) / 2
                    startAngle: 160
                    sweepAngle: 220 * _root.ratio

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

    Column {
        anchors.centerIn: parent
        Text {
            id: valueText
            visible: _root.showText
            text: Math.round(_root.value)
            color: _root.textColor
            font.pixelSize: _root.textPixelSize * 2
            font.bold: _root.textBold
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: satuan
            visible: _root.showText
            text: textUnit
            color: _root.textColor
            font.pixelSize: _root.textPixelSize
            font.bold: _root.textBold
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
    Text {
        id: nameGauge
        y: 360
        visible: _root.showText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        text: textName
        color: _root.textColor
        font.pixelSize: _root.textPixelSize
        anchors.horizontalCenterOffset: 0
        font.bold: _root.textBold
    }
}
