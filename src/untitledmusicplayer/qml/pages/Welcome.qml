// "BasicPage.qml"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import com.melissaautumn.jellyfinAuthForm

Item {
    id: container

    JellyfinAuthForm {
        id: jellyfinAuthForm

    }
    Page {
        id: page

        anchors.fill: parent

        GridLayout {
            id: layout
            columns: 2

            Label {
                text: qsTr("Please enter your Jellyfin Server Details:")
                Layout.columnSpan: 2
            }

            Label {
                text: qsTr("Server Host")
                Layout.fillWidth: true
            }
            TextField {
                id: hostname
                focus: true
                text: 'localhost'
            }

            Label {
                text: qsTr("Server Port")
                Layout.fillWidth: true
            }
            TextField {
                id: port

                placeholderText: "Server Port"
                text: '8096'
            }

            Label {
                text: qsTr("Server Username")
                Layout.fillWidth: true
            }
            TextField {
                id: username

                placeholderText: "Server Username"
                text: ''
            }
            Button {
                Layout.columnSpan: 2
                text: qsTr("Quick Connect")

                onClicked: function () {
                    const code = jellyfinAuthForm.login(hostname.text, port.text, username.text);
                    if (code) {
                        routerPush(quickConnectStep);
                    }
                }
            }
        }
    }
    Component {
        id: quickConnectStep

        Page {
            ColumnLayout {
                id: quickConnectForm

                Label {
                    text: qsTr("Please enter the following code into Quick Connect")
                }
                Label {
                    id: codeLabel
                    font.pointSize: 20
                    font.weight: Font.DemiBold
                    text: jellyfinAuthForm.quickConnectCode
                }
                Button {
                    text: qsTr("Quick Connect")

                    onClicked: function () {
                        const success = jellyfinAuthForm.confirm();
                        if (success) {
                            finishWelcome();
                        }
                    }
                }
            }
        }
    }
}

