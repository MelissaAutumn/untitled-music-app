import json
import logging
import pathlib
import random
import signal
import string
import sys, os
from datetime import datetime

from PySide6 import QtCore
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication, QPalette, QColor
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType, QmlElement
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtWidgets import QApplication
from dotenv import load_dotenv
from platformdirs import user_data_dir, user_cache_dir

from untitledmusicplayer.audio.api.jellyfin import JellyfinAPI, jellyfin_api
from untitledmusicplayer.elements.JellyfinAPIBridge import JellyfinAPIBridge
from untitledmusicplayer.elements.JellyfinAuthForm import JellyfinAuthForm
from untitledmusicplayer.models.album import Album, ItemRef, Image


class QAlbum(QtCore.QObject):
    album : Album
    def __init__(self, album: Album):
        super().__init__()
        self.album = album

    @QtCore.Property('QVariant', constant=True)
    def model(self):
        #print(self.album.model_dump())
        return self.album.model_dump()



def qt_message_handler(mode, context, message):
    level = logging.INFO
    if mode == QtCore.QtMsgType.QtInfoMsg:
        level = logging.INFO
    elif mode == QtCore.QtMsgType.QtWarningMsg:
        level = logging.WARNING
    elif mode == QtCore.QtMsgType.QtCriticalMsg:
        level = logging.ERROR
    elif mode == QtCore.QtMsgType.QtFatalMsg:
        level = logging.CRITICAL
    elif mode == QtCore.QtMsgType.QtDebugMsg:
        level = logging.DEBUG

    logging.log(level, f"{datetime.now()}: {message} ({context.file}:{context.line}, {context.file})")


# def old_test(album_cache_path, jellyfin_api, engine):
#
#     albums_with_images = []
#
#     try:
#         with open(album_cache_path, 'r') as fh:
#             albums_with_images = json.loads(fh.read())
#     except FileNotFoundError:
#         pass
#
#     if len(albums_with_images) == 0:
#         # QuickConnect auth flow
#         if not jellyfin_api.is_auth():
#             response = jellyfin_api.auth()
#
#             print(f"Enter [{response.get('Code')}] to connect!")
#
#             input("Press Enter to continue...")
#
#             jellyfin_api.auth_confirm(response.get('Secret'))
#
#         me = jellyfin_api.get_me()
#         views = jellyfin_api.get_views()
#
#         music_library = list(filter(lambda l: l.get('CollectionType') == 'music', views.get('Items', [])))
#         music_library_id = music_library[0].get('Id')
#
#         albums = jellyfin_api.get_albums()
#
#         for album in albums.get('Items', []):
#             album['Images'] = jellyfin_api.get_image_by_item_id(album.get('Id'))
#             albums_with_images.append(album)
#
#         print(albums)
#
#
#         with open(album_cache_path, 'w') as fh:
#             fh.write(json.dumps(albums_with_images))
#
#     api_url = jellyfin_api._api_url()
#     print("API URL >> ", api_url)
#
#     album_models = []
#     qalbums = []
#     if len(albums_with_images):
#         for album in albums_with_images:
#             model = Album(
#                 id=album.get('Id'),
#                 name=album.get('Name'),
#                 production_year=album.get('ProductionYear'),
#                 artists=map(lambda a: ItemRef(id=a.get('Id'), name=a.get('Name')), album.get('ArtistItems', [])),
#                 album_artists=map(lambda a: ItemRef(id=a.get('Id'), name=a.get('Name')), album.get('AlbumArtists', [])),
#                 images=map(lambda i: Image(
#                     id=i.get('ImageTag'),
#                     type=i.get('ImageType'),
#                     blur_hash=i.get('BlurHash'),
#                     path=i.get('Path'),
#                     width=i.get('Width'),
#                     height=i.get('Height'),
#                     size=i.get('Size')
#                 ), album.get('Images', []))
#             )
#             album_models.append(model)
#             qalbums.append(QAlbum(model))
#
#     engine.rootContext().setContextProperty('albums', qalbums)

def auth(jellyfin_api : JellyfinAPI):
    # QuickConnect auth flow
    response = jellyfin_api.auth()

    print(f"Enter [{response.get('Code')}] to connect!")

    input("Press Enter to continue...")

    jellyfin_api.auth_confirm(response.get('Secret'))

def main():
    # Only for now...

    load_dotenv()

    #logging.basicConfig(level=logging.INFO)

    """Needed to get proper KDE style outside of Plasma"""
    if not os.environ.get("QT_QUICK_CONTROLS_STYLE"):
        os.environ["QT_QUICK_CONTROLS_STYLE"] = "org.kde.desktop"

    base_path = os.path.abspath(os.path.dirname(__file__))
    data_path = user_data_dir('untitledmusicapp', 'melissaautumn')
    cache_path = user_cache_dir('untitledmusicapp', 'melissaautumn')
    album_cache_path = pathlib.Path(f'{cache_path}/tmp/albums.json')

    # Ensure the path is created
    album_cache_path.parent.mkdir(parents=True, exist_ok=True)

    #QtCore.qInstallMessageHandler(qt_message_handler)
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    """Needed to close the app with Ctrl+C"""
    signal.signal(signal.SIGINT, signal.SIG_DFL)

    qmlRegisterType(JellyfinAuthForm, 'com.melissaautumn.jellyfinAuthForm', 1, 0, 'JellyfinAuthForm')
    qmlRegisterType(JellyfinAPIBridge, 'com.melissaautumn.jellyfinAPIBridge', 1, 0, 'JellyfinAPIBridge')

    print("Loading main")
    engine.load(QUrl(f'file://{base_path}/qml/main.qml'))

    if not engine.rootObjects():
        sys.exit(-1)

    exit_code = app.exec()
    del engine
    sys.exit(exit_code)

if __name__ == "__main__":
    main()