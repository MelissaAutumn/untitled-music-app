from PySide6 import QtCore
from pydantic import BaseModel


class ItemRef(BaseModel):
    """Refs pointing to other items in the api"""
    id: str
    name: str


class Image(BaseModel):
    id: str
    type: str
    blur_hash: str
    path: str
    width: int
    height: int
    size: int


class Album(BaseModel):
    id: str
    name: str
    artists: list[ItemRef]
    album_artists: list[ItemRef]
    images: list[Image]
    production_year: int|None
