import QtQuick
import QtQuick.Shapes
import BGSQmlLibrary
import QtMultimedia
import Qt.SafeRenderer
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Studio.Components
import QtQuick.Studio.LogicHelper
import QtQuick3D
import SimulinkConnector
import QtCharts
import QtGraphs
import QtInsightTracker
import QtQuick3D.Xr
import QtQuick.Studio.DesignEffects
import QtQuick.Timeline
import QtQuick.VectorImage
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Components
import QtQuick.VirtualKeyboard.Layouts
import QtQuick.VirtualKeyboard.Settings
import QtQuick3D.SpatialAudio
import QtQuick.VirtualKeyboard.Styles
import QtQuick.Window
import QtQuick3D.AssetUtils
import QtQuick3D.Physics.Helpers
import QtQuick3D.Physics
import QtQuick3D.Effects
import QtQuick3D.Helpers
import QtQuick3D.Particles3D

Window {
    id: window
    width: 1080
    height: 1080
    visible: true
    color: "transparent"
    title: "BGSQmlLibrary"

    SLConnector {
        root: window
    }

    Column {
        id: barColumn
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Item {
            id: circSlot
            width: barColumn.width
            height: 300
            property bool countingUp: true

            BgsProgresCircle {
                id: circItem
                anchors.fill: parent
                value: 0
                minimumValue: 0
                maximumValue: 100
                thickness: 30
                bgColor: "black"
                fillColor: "#00ff09"
                bgOpacity: 0.5
            }

            Timer {
                interval: 50
                running: true
                repeat: true
                onTriggered: {
                    if (circSlot.countingUp) {
                        circItem.value += 1
                        if (circItem.value >= circItem.maximumValue) {
                            circItem.value = circItem.maximumValue
                            circSlot.countingUp = false
                        }
                    } else {
                        circItem.value -= 1
                        if (circItem.value <= circItem.minimumValue) {
                            circItem.value = circItem.minimumValue
                            circSlot.countingUp = true
                        }
                    }
                }
            }
        }

        Item {
            id: barSlot
            width: barColumn.width
            height: 50
            property bool countingUp: true

            BgsProgresBar {
                id: barItem
                anchors.fill: parent
                value: 0
                minimumValue: 0
                maximumValue: 100
                bgColor: "black"
                fillColor: "#00ff09"
            }

            Timer {
                interval: 50
                running: true
                repeat: true
                onTriggered: {
                    if (barSlot.countingUp) {
                        barItem.value += 1
                        if (barItem.value >= barItem.maximumValue) {
                            barItem.value = barItem.maximumValue
                            barSlot.countingUp = false
                        }
                    } else {
                        barItem.value -= 1
                        if (barItem.value <= barItem.minimumValue) {
                            barItem.value = barItem.minimumValue
                            barSlot.countingUp = true
                        }
                    }
                }
            }
        }
    }
}
