import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.melissaautumn.jellyfinAPIBridge

//import "Components" as Components

// Note: This is just sample code from kirigami gallery adjusted to display a list of whatever
ApplicationWindow {
    id: root

    function finishWelcome() {
        //showInitialPage();
        routerReplace(Qt.createComponent("pages/AlbumList.qml"));
    }
    function routerClear() {
        pageStack.clear();
    }
    function routerPop(amount = -1) {
        pageStack.pop();
    }
    function routerPush(item, properties, operation) {
        pageStack.push(item, properties, operation);
    }
    function routerReplace(item, properties, operation) {
        pageStack.replace(item, properties, operation);
    }
    function showInitialPage() {
        if (!jellyfinAPI.isAuthenticated) {
            routerReplace(Qt.createComponent("pages/Welcome.qml"));
        } else {
            console.log(jellyfinAPI.getAlbums);
            finishWelcome();
        }
    }

    visible: true

    StackView {
        id: pageStack

        anchors.fill: parent
    }
    Component.onCompleted: {
        console.log("Hello")
        showInitialPage();
    }

    //pageStack.initialPage: Qt.resolvedUrl("pages/Welcome.qml")

    //minimumHeight: Kirigami.Units.gridUnit * 20
    //minimumWidth: Kirigami.Units.gridUnit * 20

    JellyfinAPIBridge {
        id: jellyfinAPI

    }
}