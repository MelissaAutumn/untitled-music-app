import json
import logging
import pathlib
import random
import signal
import string
import sys, os
from datetime import datetime

import PySide6
from PySide6 import QtCore
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication, QPalette, QColor
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType, QmlElement
from PySide6.QtQuickControls2 import QQuickStyle
from PySide6.QtWidgets import QApplication
from dotenv import load_dotenv
from platformdirs import user_data_dir, user_cache_dir

from untitledmusicplayer import config
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


def main():
    load_dotenv()
    logging.basicConfig(level=logging.DEBUG)

    # See if we have creds
    creds = config.load_server_creds()
    if creds:
        jellyfin_api.url = creds.get('host')
        jellyfin_api.port = creds.get('port')
        jellyfin_api.username = creds.get('username')
        jellyfin_api.access_token = creds.get('access_token')
        jellyfin_api.reauth()
        logging.info("Credentials found, skipping welcome page.")
    else:
        logging.info("No credentials found, will serve welcome page.")

    QtCore.qInstallMessageHandler(qt_message_handler)
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    """Needed to close the app with Ctrl+C"""
    signal.signal(signal.SIGINT, signal.SIG_DFL)

    # Register some python qml types
    qmlRegisterType(JellyfinAuthForm, 'com.melissaautumn.jellyfinAuthForm', 1, 0, 'JellyfinAuthForm')
    qmlRegisterType(JellyfinAPIBridge, 'com.melissaautumn.jellyfinAPIBridge', 1, 0, 'JellyfinAPIBridge')

    # Prints PySide6 version
    logging.info(f"Pyside Version: {PySide6.__version__}")

    # Prints the Qt version used to compile PySide6
    logging.info(f"QT Version: {PySide6.QtCore.__version__}")

    print("Loading main")
    engine.load(QUrl(f'file://{config.base_path}/qml/main.qml'))

    if not engine.rootObjects():
        print("No root object! Exiting :(")
        sys.exit(-1)

    print("Fin~")
    exit_code = app.exec()
    del engine
    sys.exit(exit_code)

if __name__ == "__main__":
    main()