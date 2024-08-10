import typing
from dataclasses import fields
from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, QByteArray

from ingame.models.Entry import Entry
from ingame.models.GameEntry import GameEntry


# TODO: set to be parent of GamesModel

class EntriesModel(QAbstractListModel):

    def __init__(self):
        super().__init__()
        self.entries_list = []

    def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> typing.Any:
        if 0 <= index.row() < self.rowCount():
            student = self.entries_list[index.row()]
            name = self.roleNames().get(role)
            if name:
                return getattr(student, name.decode())

    def roleNames(self) -> dict[int, QByteArray]:
        d = {}
        for i, field in enumerate(fields(Entry)):
            d[Qt.DisplayRole + i] = field.name.encode()
        return d

    def rowCount(self, index: QModelIndex = QModelIndex()) -> int:
        return len(self.entries_list)

    def add_entry(self, entry: Entry) -> None:
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self.entries_list.append(entry)
        self.endInsertRows()

    def clear(self) -> None:
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self.entries_list = []
        self.endInsertRows()

    pass
