import os
import hashlib
from urllib import parse

import requests


class JellyfinAPI:
    url: str|None
    port: str|int|None
    ssl: bool
    auth_header: str|None
    username: str|None
    access_token: str|None
    user_id: str|None

    CLIENT_NAME = "Mels Media Player"
    CLIENT_VERSION = "0.0.1"

    def __init__(self, url:str|None = None, port:str|int|None = None, ssl:bool = False, username:str|None = None, access_token = None):
        self.url = url
        self.port = port
        self.ssl = ssl
        self.username = username
        self.access_token = access_token

    def _auth_headers(self):
        """Builds the authentication header which is annoying."""
        header = ['MediaBrowser']

        h = hashlib.new('sha256')
        h.update(self.username.encode())

        if self.access_token:
            header.append(f'Token="{self.access_token}",')

        header.append(f'Client="{self.CLIENT_NAME}",')
        header.append('Device="Desktop",')
        header.append(f'DeviceId="MMP-{str(h.hexdigest())[:16]}",')
        header.append(f'Version="{self.CLIENT_VERSION}"')

        return ' '.join(header)

    def api_url(self):
        protocol = 'https' if self.ssl or self.port == 443 else 'http'
        return f"{protocol}://{self.url}:{self.port}"

    def request(self, endpoint: str, method: str = 'GET', data=None) -> requests.Response:
        """Generic request method, prefixes all endpoints with the proper server url, and appends the proper auth header."""
        print("Calling ", f"{self.api_url()}/{endpoint}", " with ", data)
        print("Headers: ", self._auth_headers())

        params = None
        json = None
        if method == 'GET':
            params = data
        else:
            json = data

        return requests.request(method, f"{self.api_url()}/{endpoint}", json=json, params=params, headers={
            'Authorization': self._auth_headers()
        })

    def is_auth(self):
        return bool(self.access_token)

    def auth(self):
        """Initiates an authentication request via QuickConnect."""
        response = self.request('QuickConnect/Initiate', method='GET')
        response.raise_for_status()
        return response.json()

    def auth_confirm(self, secret_code):
        """Confirms the request was authenticated properly, and retrieves user and access token details from the server."""
        response = self.request('QuickConnect/Connect', method='GET', data={
            'secret': secret_code
        })

        response.raise_for_status()

        data = response.json()
        print("auth confirm", data)
        auth = data.get('Authenticated')

        if not auth or not data.get('Secret'):
            print("Not authenticated!")
            return False

        response = self.request('Users/AuthenticateWithQuickConnect', method='POST', data={
            'Secret': data.get('Secret')
        })

        response.raise_for_status()

        data = response.json()

        print("Success->", data)

        self.access_token = data.get('AccessToken')

        # Grab the user id!
        self.get_me()

        return True


    def reauth(self):
        """Hack until I re-organize this file"""
        self.get_me()
        return True

    """
    User
    """

    def get_me(self):
        response = self.request('Users/Me')
        response.raise_for_status()
        data = response.json()

        self.user_id = data.get('Id')

        return data

    def get_views(self):
        response = self.request(f'Users/{self.user_id}/Views')
        response.raise_for_status()
        return response.json()

    """
    Artists
    """

    def get_artists(self):
        response = self.request("Artists")
        response.raise_for_status()
        return response.json()


    """
    Albums
    """

    def get_albums(self, collection_id = None):
        # TODO: Add ParentID with music collection
        response = self.request(f'Users/{self.user_id}/Items', method='GET', data={
            'includeItemTypes': 'MusicAlbum',
            'enableTotalRecordCount': True,
            'recursive': True,
        })
        response.raise_for_status()
        return response.json()

    """
    Images
    """

    def get_image_by_item_id(self, item_id):
        response = self.request(f'Items/{item_id}/Images')
        response.raise_for_status()
        return response.json()


# Temp export :^)
jellyfin_api = JellyfinAPI()