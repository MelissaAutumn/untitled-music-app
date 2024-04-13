import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import com.melissaautumn.jellyfinAPIBridge

//import "Components" as Components

// Note: This is just sample code from kirigami gallery adjusted to display a list of whatever
Kirigami.ApplicationWindow {
    id: root

    function finishWelcome() {
        //showInitialPage();
        routerReplace(Qt.createComponent("pages/AlbumList.qml"));
    }
    function routerClear() {
        root.pageStack.layers.clear();
    }
    function routerPop(amount = -1) {
        root.pageStack.pop(amount);
    }
    function routerPush(page, args) {
        root.pageStack.push(page, args);
    }
    function routerReplace(page, args) {
        routerClear();
        if (root.pageStack.currentItem !== page) {
            while (root.pageStack.depth > 0) {
                routerPop();
            }
        }
        routerPush(page, args);
    }
    function showInitialPage() {
        if (!jellyfinAPI.isAuthenticated) {
            routerReplace(Qt.createComponent("pages/Welcome.qml"));
        } else {
            finishWelcome();
        }
    }

    globalDrawer: Kirigami.GlobalDrawer {
        isMenu: true

        actions: [
            Kirigami.Action {
                icon.name: "gtk-quit"
                shortcut: StandardKey.Quit
                text: qsTr("Quit")

                onTriggered: Qt.quit()
            },
            Kirigami.Action {
                icon.name: "help-about"
                //onTriggered: pageStack.layers.push(aboutPage)
                // <==== Action to open About page
                text: qsTr("About")
            }
        ]
    }

    Component.onCompleted: {
        showInitialPage();
    }

    //pageStack.initialPage: Qt.resolvedUrl("pages/Welcome.qml")

    //minimumHeight: Kirigami.Units.gridUnit * 20
    //minimumWidth: Kirigami.Units.gridUnit * 20

    JellyfinAPIBridge {
        id: jellyfinAPI

    }
}