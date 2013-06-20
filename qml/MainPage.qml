import QtQuick 2.0
import QtMultimedia 5.0
import com.iktwo.components 1.0

Rectangle {
    function formatMilliseconds(ms) {
        var hours = Math.floor((((ms / 1000) / 60) / 60) % 60).toString()
        var minutes = Math.floor(((ms / 1000) / 60) % 60).toString()
        var seconds = Math.floor((ms / 1000) % 60).toString()

        var time = ""

        if (hours > 0)
            time += hours + ":"

        if (minutes < 10)
            time += "0" + minutes + ":"
        else
            time += minutes + ":"

        if (seconds < 10)
            time += "0" + seconds
        else
            time += seconds

        return time
    }

    anchors.fill: parent

    color: Styler.darkTheme ? Style.MENU_BACKGROUND_COLOR_DARK : Style.MENU_BACKGROUND_COLOR_LIGHT

    Audio {
        id: audio

        onSeekableChanged: console.log("Seekable", seekable) 
    }

    ListModel {
        id: playlist

        onRowsInserted: {
            if (count > 0 && audio.playbackState == Audio.StoppedState) {
                audio.source = playlist.get(0).url
                audio.play()
            }
        }
    }

    SearchDialog {
        id: searchDialog
    }

    TitleBar {
        id: titleBar

        title: "MusicGear"

        MouseArea {
            anchors.fill: parent
            onClicked: Styler.darkTheme = !Styler.darkTheme
        }

        TitleBarImageButton {
            anchors.right: parent.right

            source: Styler.darkTheme ? "qrc:/images/search_dark" : "qrc:/images/search_light"

            onClicked: searchDialog.open()
        }
    }

    ListView {
        anchors {
            top: titleBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        model: playlist
        clip: true

        delegate: PlaylistDelegate {
            onPlay: console.log("Play me!")

            onRemove: console.log("Remove me :( !)")
        }
    }

    Rectangle {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        color: Styler.darkTheme ? Style.MENU_TITLE_BACKGROUND_COLOR_DARK : Style.MENU_TITLE_BACKGROUND_COLOR_LIGHT
        height: 80

        Rectangle {
            anchors {
                left: parent.left; leftMargin: 15
                verticalCenter: parent.verticalCenter
            }

            width: 300
            height: 10

            color: "lightgray"

            Rectangle {
                color: "green"
                height: parent.height
                width: audio.duration === 0 ? 0 : (audio.position / audio.duration) * parent.width
            }

            Label {
                anchors.left: parent.left

                text: formatMilliseconds(audio.position)
            }

            Label {
                anchors.right: parent.right

                text: formatMilliseconds(audio.duration)
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (audio.seekable)
                        audio.seek((mouseX / parent.width) * audio.duration)
                }
            }
        }
    }
}
