import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: page

    function getAlbumImage(album) {
        //if (album.images.length === 0 || album.images[0].type !== 'Primary') {
        //    return '';
        //}
        return `${jellyfinAPI.getAPIUrl}/Items/${album.id}/Images/Primary`;
    }

    /*
        Kirigami.CardsListView {
            id: view
            model: jellyfinAPI.getAlbums.length

            delegate: Kirigami.AbstractCard
            {
                //NOTE: never put a Layout as contentItem as it will cause binding loops
                //SEE: https://bugreports.qt.io/browse/QTBUG-66826
                contentItem: Item {
                    property var album : jellyfinAPI.getAlbums[modelData]
                    id: cardItem
                    implicitWidth: delegateLayout.implicitWidth
                    implicitHeight: delegateLayout.implicitHeight
                    GridLayout {
                        id: delegateLayout
                        anchors {
                            left: parent.left
                            top: parent.top
                            right: parent.right
                            //IMPORTANT: never put the bottom margin
                        }
                        rowSpacing: Kirigami.Units.largeSpacing
                        columnSpacing: Kirigami.Units.largeSpacing
                        columns: width > Kirigami.Units.gridUnit * 20 ? 4 : 2
                        Image {
                            visible: true //cardItem.album.images.length > 0
                            source: page.getAlbumImage(cardItem.album)
                            height: 64
                            mipmap: true
                            Layout.fillHeight: true
                            Layout.maximumHeight: Kirigami.Units.iconSizes.huge
                            Layout.preferredWidth: height
                        }
                        Rectangle {
                            visible: false //cardItem.album.images.length === 0
                            color: 'steelblue'
                            height: 64
                            Layout.fillHeight: true
                            Layout.maximumHeight: Kirigami.Units.iconSizes.huge
                            Layout.preferredWidth: height
                        }
                        ColumnLayout {
                            Kirigami.Heading {
                                level: 2
                                text: cardItem.album.name
                            }
                            Kirigami.Separator {
                                Layout.fillWidth: true
                            }
                            QQC2.Label {
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                text: cardItem.album.album_artists?.map((artist) => artist.name).join(', ')
                            }
                        }
                        QQC2.Button {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.columnSpan: 2
                            text: qsTr("Neat")
                            onClicked: showPassiveNotification("Neated for Product " + modelData + " clicked");
                        }
                    }
                }
            }
        }

 */

    title: qsTr("Album List Test")

    /*
        actions.main: Kirigami.Action {
            icon.name: "documentinfo"
            text: qsTr("Info")
            checkable: true
            onCheckedChanged: sheet.visible = checked;
            shortcut: "Alt+I"
        }
         */
    /*
        //Close the drawer with the back button
    onBackRequested: {
        if (sheet.sheetOpen) {
            event.accepted = true;
            sheet.close();
        }
    }
*/

    ScrollView {
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        clip: true                   // Prevent drawing column outside the scrollview borders

        contentHeight: delegateLayout.height  // Same
        contentWidth: delegateLayout.width    // The important part
        height: root.height
        width: root.width

        ListView {
            contentHeight: delegateLayout.height  // Same
            contentWidth: delegateLayout.width    // The important part
            model: jellyfinAPI.getAlbums.length

            delegate: ItemDelegate {
                property var album: jellyfinAPI.getAlbums[index]
                required property int index

                height: 128
                width: root.width

                RowLayout {
                    id: delegateLayout

                    anchors.fill: parent
                    spacing: 8

                    Image {
                        Layout.maximumHeight: 64
                        Layout.maximumWidth: 64
                        //Layout.fillHeight: true
                        //Layout.preferredWidth: height
                        height: 64
                        mipmap: true
                        source: page.getAlbumImage(album)
                        visible: true //cardItem.album.images.length > 0
                        width: 64
                    }
                    ColumnLayout {
                        //anchors.fill: parent
                        spacing: 8

                        Label {
                            text: album.name
                        }
                        Label {
                            Layout.fillWidth: true
                            text: album.album_artists?.map(artist => artist.name).join(', ')
                            wrapMode: Text.WordWrap
                        }
                    }
                    anchors {
                        left: parent.left
                        right: parent.right
                        //IMPORTANT: never put the bottom margin
                        top: parent.top
                    }
                }
            }
        }
    }
}
