import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components" as Comps

Page {
    id: page

    function getAlbumImage(album) {
        //if (album.images.length === 0 || album.images[0].type !== 'Primary') {
        //    return '';
        //}
        return `${jellyfinAPI.getAPIUrl}/Items/${album.id}/Images/Primary`;
    }

    title: qsTr("Album List Test")

    SystemPalette {
        id: myPalette

        colorGroup: SystemPalette.Active
    }

    ScrollView {
        clip: true

        height: root.height
        width: root.width

        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: 20
        anchors.rightMargin: 20

        topInset: 20


        ListView {
            model: jellyfinAPI.getAlbums.length
            spacing: 10
            clip: true



            delegate: ItemDelegate {
                property var album: jellyfinAPI.getAlbums[index]
                required property int index

                // Delegate must have width/height set, otherwise it will try and guess...and it sucks at that.
                height: 80
                width: ListView.view.width

                Layout.leftMargin: 8
                Comps.Card {
                    id: card
                    cardDesc: album.artists?.map(artist => artist.name).join(', ')
                    cardImage: page.getAlbumImage(album)
                    cardTitle: album.name

                    MouseArea {
                        id: hover
                        width: parent.width
                        height: parent.height
                        hoverEnabled: true
                        onEntered: {
                            console.log('im in')
                            parent.color = myPalette.accent
                        }
                        onExited: {
                            parent.color = myPalette.alternateBase
                        }
                        onClicked: { parent.color = myPalette.accent }
                    }
                }
            }
        }
    }
}
