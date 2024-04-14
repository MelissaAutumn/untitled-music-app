import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.melissaautumn.jellyfinAPIBridge

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
            finishWelcome();
        }
    }

    height: 720
    title: qsTr("Untitled Music App")
    visible: true
    width: 1280

    Component.onCompleted: {
        showInitialPage();
    }


    StackView {
        id: pageStack
        padding: 10
        anchors.fill: parent
    }
    JellyfinAPIBridge {
        id: jellyfinAPI

    }
}