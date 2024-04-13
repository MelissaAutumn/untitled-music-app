from PySide6.QtCore import QObject, Signal, Property, Slot
from markdown import markdown


class MdConverter(QObject):
    """A simple markdown converter"""

    def __init__(self, _source_text = ''):
        QObject.__init__(self)

        self._source_text = ''

    def readSourceText(self):
        return self._source_text

    def setSourceText(self, val):
        self._source_text = val
        self.sourceTextChanged.emit()

    sourceTextChanged = Signal()

    @Slot(result=str)
    def mdFormat(self):
        return markdown(self._source_text)

    sourceText = Property(str, readSourceText, setSourceText, notify=sourceTextChanged)
