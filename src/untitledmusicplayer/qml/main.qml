
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
//import "Components" as Components

// Note: This is just sample code from kirigami gallery adjusted to display a list of whatever
Kirigami.ApplicationWindow {
    id: root

    minimumHeight: Kirigami.Units.gridUnit * 20
    minimumWidth: Kirigami.Units.gridUnit * 20

    pageStack.initialPage: Kirigami.ScrollablePage {
        id: page

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

        //Close the drawer with the back button
        onBackRequested: {
            if (sheet.sheetOpen) {
                event.accepted = true;
                sheet.close();
            }
        }

        function getAlbumImage(album) {
            if (album.images.length === 0 || album.images[0].type !== 'Primary') {
                return '';
            }
            return `${api_url}/Items/${album.id}/Images/Primary`;
        }

        Kirigami.CardsListView {
            id: view
            model: albums.length

            delegate: Kirigami.AbstractCard
            {
                //NOTE: never put a Layout as contentItem as it will cause binding loops
                //SEE: https://bugreports.qt.io/browse/QTBUG-66826
                contentItem: Item {
                    property var album : albums[modelData].model
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
                            visible: cardItem.album.images.length > 0
                            source: page.getAlbumImage(cardItem.album)
                            height: 64
                            mipmap: true
                            Layout.fillHeight: true
                            Layout.maximumHeight: Kirigami.Units.iconSizes.huge
                            Layout.preferredWidth: height
                        }
                        Rectangle {
                            visible: cardItem.album.images.length === 0
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
                            text: qsTr("Install")
                            onClicked: showPassiveNotification("Install for Product " + modelData + " clicked");
                        }
                    }
                }
            }
        }
    }

}