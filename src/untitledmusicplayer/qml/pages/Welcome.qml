// "BasicPage.qml"
import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import com.melissaautumn.jellyfinAuthForm

Item {
    id: container
    anchors.fill: parent

    JellyfinAuthForm {
        id: jellyfinAuthForm
    }

    Kirigami.Page {


        Kirigami.FormLayout {

            id: layout
            QQC2.Label {
                text: qsTr("Please enter your Jellyfin Server Details:")
            }
            QQC2.TextField {
                id: hostname

                Kirigami.FormData.label: "Server Host"
                focus: true
                text: 'goblinhoard.local'
            }
            QQC2.TextField {
                id: port

                Kirigami.FormData.label: "Server Port"
                text: '8096'
            }
            QQC2.TextField {
                id: username

                Kirigami.FormData.label: "Server Username"
                text: 'Mel'
            }
            QQC2.Button {
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

        Kirigami.Page {
            Kirigami.FormLayout {
                id: quickConnectForm

                QQC2.Label {
                    text: qsTr("Please enter the following code into Quick Connect")
                }
                QQC2.Label {
                    id: codeLabel

                    text: jellyfinAuthForm.quickConnectCode
                }
                QQC2.Button {
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

