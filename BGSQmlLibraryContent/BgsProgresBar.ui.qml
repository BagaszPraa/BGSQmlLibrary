import QtQuick
import QtQuick.Timeline 1.0
import QtQuick.Controls
import QtQuick.Studio.DesignEffects

Item {
    id: root
    anchors.fill: parent

    // ===== Public API =====
    property real value: 100
    property real minimumValue: 0
    property real maximumValue: 100
    property color bgColor: "#b3000000"
    property color fillColor: "#00ff09"
    property color textColor: fillColor
    property real margin: 10
    property int textPixelSize: 40
    property bool textBold: true

    property bool animated: true
    property int animationDuration: 100
    property int animationEasing: Easing.OutCubic

    signal progressChanged(real value)

    // Elemen tersembunyi hanya untuk mengukur lebar teks terpanjang ("0000")
    Text {
        id: textMeasurer
        visible: false
        text: "0000"
        font.pixelSize: root.textPixelSize
        font.bold: root.textBold
    }
    property real fixedTextWidth: textMeasurer.width

    Rectangle {
        id: frame
        anchors.fill: parent
        color: "#00000000"

        Rectangle {
            id: trackProgres
            width: frame.width - root.fixedTextWidth * 1.3
            height: frame.height
            color: "#80000000"
            radius: height / 2
            border.color: "#00000000"
            border.width: 1

            Rectangle {
                id: progress
                height: trackProgres.height
                color: root.fillColor
                radius: parent.height / 2
                border.color: "#00000000"
                width: height + (trackProgres.width - height)
                       * (Math.max(root.minimumValue,
                                   Math.min(root.maximumValue,
                                            root.value)) - root.minimumValue)
                       / (root.maximumValue - root.minimumValue)

                Behavior on width {
                    enabled: root.animated
                    NumberAnimation {
                        duration: root.animationDuration
                        easing.type: root.animationEasing
                    }
                }
            }
        }

        Text {
            id: percentText
            text: Math.round(root.value) + "%"
            width: root.fixedTextWidth
            horizontalAlignment: Text.AlignRight
            font.family: "Arial"
            anchors.right: frame.right
            anchors.verticalCenter: frame.verticalCenter
            anchors.rightMargin: root.margin
            color: root.textColor
            font.pixelSize: root.textPixelSize
            font.bold: root.textBold
        }
    }
}
