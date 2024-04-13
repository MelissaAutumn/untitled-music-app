from PySide6.QtCore import QObject, Slot, Signal, Property
from PySide6.QtQml import QmlElement

from untitledmusicplayer.audio.api.jellyfin import jellyfin_api
from untitledmusicplayer.models.album import Album, ItemRef

QML_IMPORT_NAME = "JellyfinAPIBridge"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class JellyfinAPIBridge(QObject):
    albums: list[Album] = []

    def __init__(self):
        super().__init__()

    onAlbumsChange = Signal()
    onAuthenticationChange = Signal()

    @Property(bool, notify=onAuthenticationChange)
    def isAuthenticated(self):
        return bool(jellyfin_api.access_token)

    @Property(str, constant=True)
    def getAPIUrl(self):
        return jellyfin_api.api_url()

    @Property('QVariant', notify=onAlbumsChange)
    def getAlbums(self):
        # Temp...
        if len(self.albums) == 0:
            albums = jellyfin_api.get_albums()
            for album in albums.get('Items', []):
                model = Album(
                    id=album.get('Id'),
                    name=album.get('Name'),
                    production_year=album.get('ProductionYear'),
                    artists=map(lambda a: ItemRef(id=a.get('Id'), name=a.get('Name')), album.get('ArtistItems', [])),
                    album_artists=map(lambda a: ItemRef(id=a.get('Id'), name=a.get('Name')), album.get('AlbumArtists', [])),
                    # We'll do this later...
                    # images=map(lambda i: Image(
                    #    id=i.get('ImageTag'),
                    #    type=i.get('ImageType'),
                    #    blur_hash=i.get('BlurHash'),
                    #    path=i.get('Path'),
                    #    width=i.get('Width'),
                    #    height=i.get('Height'),
                    #    size=i.get('Size')
                    # ), album.get('Images', []))
                )
                self.albums.append(model)

        models = list(map(lambda a: a.model_dump(), self.albums))
        return models
