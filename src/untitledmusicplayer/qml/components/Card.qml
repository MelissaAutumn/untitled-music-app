import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: rect

    property alias cardDesc: descLabel.text
    property alias cardImage: image.source
    property alias cardTitle: titleLabel.text

    color: myPalette.alternateBase
    height: parent.height
    radius: 8
    width: parent.width

    SystemPalette {
        id: myPalette

        colorGroup: SystemPalette.Active
    }
    RowLayout {
        spacing: 10
        Rectangle {
            clip: true
            color: myPalette.accent
            height: 80
            radius: 8
            width: 80

            Image {
                id: image

                height: parent.height
                mipmap: true
                visible: cardImage !== ''
                width: parent.width
            }
        }
        ColumnLayout {
            Label {
                id: titleLabel

                width: rect.width - 256
                wrapMode: Text.WordWrap
            }
            Label {
                id: descLabel

                elide: Text.ElideRight
                width: rect.width - 256
            }
        }
    }
}

