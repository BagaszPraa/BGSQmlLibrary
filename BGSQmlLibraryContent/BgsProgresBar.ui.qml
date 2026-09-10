import QtQuick
import QtQuick.Controls

Item {
    id: _root
    anchors.fill: parent

    // ===== Public API =====
    property real value: 50
    property real minimumValue: 0
    property real maximumValue: 100
    property color bgColor: "#000000"
    property color fillColor: "#00ff09"
    property real bgOpacity: 0.5
    property color textColor: fillColor
    property real margin: 10
    property int textPixelSize: 40
    property bool textBold: true
    property bool animated: true
    property int animationDuration: 100
    property int animationEasing: Easing.OutCubic

    Text {
        id: textMeasurer
        visible: false
        text: "0000"
        font.pixelSize: _root.textPixelSize
        font.bold: _root.textBold
    }
    property real fixedTextWidth: textMeasurer.width

    Rectangle {
        id: frame
        anchors.fill: parent
        color: "#00000000"

        Rectangle {
            id: trackProgres
            width: frame.width - _root.fixedTextWidth * 1.3
            height: frame.height
            color: _root.bgColor
            opacity: _root.bgOpacity
            radius: height / 2
            border.color: "#00000000"
            border.width: 1
        }
        Rectangle {
            id: progress
            height: trackProgres.height
            color: _root.fillColor
            radius: parent.height / 2
            border.color: "#00000000"
            width: height + (trackProgres.width - height)
                   * (Math.max(_root.minimumValue,
                               Math.min(_root.maximumValue,
                                        _root.value)) - _root.minimumValue)
                   / (_root.maximumValue - _root.minimumValue)

            Behavior on width {
                enabled: _root.animated
                NumberAnimation {
                    duration: _root.animationDuration
                    easing.type: _root.animationEasing
                }
            }
        }

        Text {
            id: percentText
            text: Math.round(_root.value) + "%"
            width: _root.fixedTextWidth
            horizontalAlignment: Text.AlignRight
            font.family: "Arial"
            anchors.right: frame.right
            anchors.verticalCenter: frame.verticalCenter
            anchors.rightMargin: _root.margin
            color: _root.textColor
            font.pixelSize: _root.textPixelSize
            font.bold: _root.textBold
        }
    }
}
