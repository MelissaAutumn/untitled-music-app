from PySide6.QtCore import QObject, Slot, Signal, Property
from PySide6.QtQml import QmlElement

from untitledmusicplayer.audio.api.jellyfin import jellyfin_api

QML_IMPORT_NAME = "JellyfinAuthForm"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class JellyfinAuthForm(QObject):
    hostname: str
    port: str
    username: str
    qcCode: str = ''
    qcSecret: str = ''

    def __init__(self):
        super().__init__()

    onQuickConnectCode = Signal()

    @Property(type=str, notify=onQuickConnectCode)
    def quickConnectCode(self):
        return self.qcCode

    @Slot(str, str, str, result=bool)
    def login(self, hostname, port, username):
        """Start the quick connect login process"""
        print(hostname, port, username)
        jellyfin_api.url = hostname
        jellyfin_api.port = port
        jellyfin_api.ssl = False
        jellyfin_api.username = username

        auth_response = jellyfin_api.auth()

        self.qcSecret = auth_response.get('Secret')
        self.qcCode = auth_response.get('Code')

        if not self.qcCode or not self.qcSecret:
            return False

        return True

    @Slot(result=bool)
    def confirm(self):
        """Finalize the quick connect process"""
        return jellyfin_api.auth_confirm(self.qcSecret)