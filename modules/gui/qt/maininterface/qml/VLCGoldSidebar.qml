/*****************************************************************************
 * vlc-gold: navigation rail + library panel
 *
 * Implements the sidebar from the "VLC Redesign (Community)" Figma design,
 * frame 187:328 (canvas 1920x1080), extracted from the Figma REST API on
 * 2026-10-21 into design/layout-player.txt:
 *
 *   sidebar [427 x 986]
 *     icon rail [50 x 986]   bg #191919
 *       8 glyphs, 30x32, 46px pitch, first row at y = 25 from the top
 *     library  [377 x 986]   bg #0e0e0e
 *       header row 337x24   label #8f8f8f
 *       count row  337x24   label #6b6b6b
 *       hairline divider    #222222
 *       2 list rows, 337x32
 *
 * Colours are taken from ColorContext rather than hardcoded, so this follows
 * the vlc-gold palette (near-black surfaces, purple accent) that
 * systempalettethemeprovider.cpp sets up.
 *****************************************************************************/

import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import VLC.Style
import VLC.Widgets as Widgets

FocusScope {
    id: root

    implicitWidth: MainCtx.dp(427, VLCStyle.scale)
    implicitHeight: MainCtx.dp(986, VLCStyle.scale)

    readonly property ColorContext colorContext: ColorContext {
        palette: VLCStyle.palette
        colorSet: ColorContext.View
    }

    // Exposed so the surrounding interface can highlight the active page.
    property int currentIndex: 0

    readonly property var navItems: [
        { label: qsTr("Videos"),     icon: VLCIcons.topbar_video },
        { label: qsTr("Music"),      icon: VLCIcons.topbar_music },
        { label: qsTr("Playlists"),  icon: VLCIcons.playlist },
        { label: qsTr("Network"),    icon: VLCIcons.topbar_network },
        { label: qsTr("Discover"),   icon: VLCIcons.topbar_discover },
        { label: qsTr("Settings"),   icon: VLCIcons.more },
    ]

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ---- icon rail: 50px, #191919 -------------------------------------
        Rectangle {
            id: rail

            Layout.preferredWidth: MainCtx.dp(50, VLCStyle.scale)
            Layout.fillHeight: true

            color: root.colorContext.bg.secondary

            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: MainCtx.dp(25, VLCStyle.scale)
                spacing: MainCtx.dp(46, VLCStyle.scale)

                Repeater {
                    model: root.navItems

                    delegate: Widgets.IconLabel {
                        // modelData and index are injected by Repeater. Declaring them
                        // "required" makes the delegate fail to instantiate.

                        // VLCIcons are glyphs in the icon font, used directly as text.
                        text: modelData.icon
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter

                        width: rail.width
                        height: MainCtx.dp(32, VLCStyle.scale)

                        color: (root.currentIndex === index)
                               ? root.colorContext.accent
                               : root.colorContext.fg.secondary

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.currentIndex = parent.index
                        }
                    }
                }
            }
        }

        // ---- library panel: 377px, #0e0e0e ---------------------------------
        Rectangle {
            Layout.preferredWidth: MainCtx.dp(377, VLCStyle.scale)
            Layout.fillHeight: true

            color: root.colorContext.bg.primary

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: MainCtx.dp(20, VLCStyle.scale)
                anchors.rightMargin: MainCtx.dp(20, VLCStyle.scale)
                anchors.topMargin: MainCtx.dp(28, VLCStyle.scale)
                spacing: MainCtx.dp(12, VLCStyle.scale)

                // header row: section title, action control to the right
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: MainCtx.dp(24, VLCStyle.scale)

                    Text {
                        text: qsTr("Playlists")
                        color: root.colorContext.fg.secondary
                        font.pixelSize: MainCtx.dp(18, VLCStyle.scale)
                        font.weight: Font.Medium
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Widgets.IconLabel {
                        text: VLCIcons.topbar_sort
                        color: root.colorContext.fg.secondary
                        font.pixelSize: MainCtx.dp(16, VLCStyle.scale)
                    }
                }

                // count row
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: MainCtx.dp(24, VLCStyle.scale)

                    Text {
                        text: qsTr("%1 items").arg(2)
                        color: root.colorContext.fg.secondary
                        font.pixelSize: MainCtx.dp(14, VLCStyle.scale)
                        opacity: .6
                        Layout.fillWidth: true
                    }

                    Widgets.IconLabel {
                        text: VLCIcons.more
                        color: root.colorContext.fg.secondary
                        font.pixelSize: MainCtx.dp(16, VLCStyle.scale)
                    }
                }

                // hairline divider (#222222)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: MainCtx.dp(1, VLCStyle.scale)
                    color: root.colorContext.separator
                }

                // list rows
                Repeater {
                    model: [ qsTr("Favorites"), qsTr("Watch later") ]

                    delegate: FocusScope {
                        // modelData/index are injected by Repeater; not `required`.

                        Layout.fillWidth: true
                        implicitHeight: MainCtx.dp(32, VLCStyle.scale)

                        Rectangle {
                            anchors.fill: parent
                            color: parent.activeFocus
                                   ? root.colorContext.accent
                                   : "transparent"
                            opacity: parent.activeFocus ? .18 : 1.0
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: MainCtx.dp(8, VLCStyle.scale)
                            text: parent.modelData
                            color: root.colorContext.fg.primary
                            font.pixelSize: MainCtx.dp(15, VLCStyle.scale)
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: parent.forceActiveFocus()
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
