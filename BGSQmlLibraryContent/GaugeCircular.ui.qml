// GaugeMeter.ui.qml
import QtQuick 2.11
import QtQuick.Shapes 1.11

Item {
    id: root

    // ===== Public API =====
    property real value: 30
    property real minimumValue: 0
    property real maximumValue: 100
    property real majorStep: 10
    property int minorPerMajor: 5

    property string unitText: "ms"
    property string label: "Airspeed"

    property color tickColor: "#ffffff"
    property color textColor: "#ffffff"
    property color needleColor: "#e53935"
    property color borderColor: "#2f7fd6"
    property bool showBorder: true
    property bool animated: true
    property int animationDuration: 200

    property real startAngle: 135
    property real sweepAngle: 225

    implicitWidth: 420
    implicitHeight: 480

    property real ratio: (maximumValue > minimumValue) ? (Math.max(
                                                              minimumValue,
                                                              Math.min(
                                                                  maximumValue,
                                                                  value)) - minimumValue)
                                                         / (maximumValue - minimumValue) : 0

    property real minorStep: majorStep / minorPerMajor
    property int totalTicks: Math.round(
                                 (maximumValue - minimumValue) / minorStep)
    property int totalMajors: Math.floor(
                                  (maximumValue - minimumValue) / majorStep) + 1

    Item {
        id: gaugeArea
        width: Math.min(root.width, root.height - labelText.implicitHeight - 20)
        height: width
        visible: true
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        property real cx: width / 2
        property real cy: height / 2
        property real r: width / 2 - 30

        // Rectangle {
        //     visible: root.showBorder
        //     anchors.fill: parent
        //     color: "transparent"
        //     border.color: "#eaeaea"
        //     border.width: 1
        // }

        // Text {
        //     visible: root.showBorder
        //     text: "Gauge"
        //     color: root.borderColor
        //     font.pixelSize: 12
        //     anchors.top: parent.top
        //     anchors.left: parent.left
        //     anchors.margins: 6
        // }

        // ===== Tick marks (deklaratif, tanpa Canvas) =====
        // Repeater {
        //     model: root.totalTicks + 1

        //     delegate: Item {
        //         id: tickItem
        //         property real val: root.minimumValue + index * root.minorStep
        //         property bool isMajor: (index % root.minorPerMajor) === 0

        //         x: gaugeArea.cx
        //         y: gaugeArea.cy
        //         width: gaugeArea.r
        //         height: isMajor ? 2 : 1
        //         transformOrigin: Item.Left
        //         rotation: root.startAngle + ((tickItem.val - root.minimumValue)
        //                                      / (root.maximumValue - root.minimumValue))
        //                   * root.sweepAngle

        //         Rectangle {
        //             anchors.right: parent.right
        //             width: tickItem.isMajor ? 16 : 8
        //             height: parent.height
        //             color: root.tickColor
        //         }
        //     }
        // }

        // ===== Label angka mayor =====
        Repeater {
            model: root.totalMajors

            delegate: Text {
                property real val: root.minimumValue + index * root.majorStep
                property real t: (val - root.minimumValue) / (root.maximumValue - root.minimumValue)
                property real angleDeg: root.startAngle + t * root.sweepAngle
                property real rad: angleDeg * Math.PI / 180
                property real labelR: gaugeArea.r - 40

                text: Math.round(val)
                color: root.textColor
                font.pixelSize: gaugeArea.width * 0.06
                x: gaugeArea.cx + Math.cos(rad) * labelR - implicitWidth / 2
                y: gaugeArea.cy + Math.sin(rad) * labelR - implicitHeight / 2
            }
        }

        // ===== Needle (jarum penunjuk) =====
        Item {
            id: needlePivot
            x: gaugeArea.cx
            y: gaugeArea.cy
            width: gaugeArea.r * 0.65
            height: 6
            transformOrigin: Item.Left

            rotation: root.startAngle + root.ratio * root.sweepAngle

            Behavior on rotation {
                enabled: root.animated
                NumberAnimation {
                    duration: root.animationDuration
                    easing.type: Easing.OutCubic
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 10
                height: 4
                color: root.needleColor
            }

            // Kepala panah (Shape deklaratif, bukan Canvas)
            Shape {
                width: 14
                height: 14
                x: needlePivot.width - 10
                anchors.verticalCenter: parent.verticalCenter
                antialiasing: true

                ShapePath {
                    fillColor: root.needleColor
                    strokeColor: "transparent"
                    startX: 0
                    startY: -7

                    PathLine {
                        x: 14
                        y: 0
                    }
                    PathLine {
                        x: 0
                        y: 7
                    }
                    PathLine {
                        x: 0
                        y: -7
                    }
                }
            }
        }

        // ===== Nilai tengah (angka besar + satuan) =====
        Row {
            anchors.horizontalCenter: gaugeArea.horizontalCenter
            anchors.top: gaugeArea.verticalCenter
            anchors.topMargin: gaugeArea.height * 0.06
            spacing: 4

            Text {
                text: Math.round(root.value)
                color: root.textColor
                font.pixelSize: gaugeArea.width * 0.18
            }
            Text {
                text: root.unitText
                color: root.textColor
                font.pixelSize: gaugeArea.width * 0.06
                anchors.bottom: parent.bottom
                anchors.bottomMargin: gaugeArea.width * 0.02
            }
        }
    }

    Text {
        id: labelText
        text: root.label
        color: root.textColor
        font.pixelSize: root.width * 0.08
        anchors.top: gaugeArea.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
