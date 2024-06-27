import typing
from dataclasses import fields
from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, QByteArray

from ingame.models.GameEntry import GameEntry


class GamesModel(QAbstractListModel):

    def __init__(self):
        super().__init__()
        self.games_list = []

    def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> typing.Any:
        if 0 <= index.row() < self.rowCount():
            student = self.games_list[index.row()]
            name = self.roleNames().get(role)
            if name:
                return getattr(student, name.decode())

    def roleNames(self) -> dict[int, QByteArray]:
        d = {}
        for i, field in enumerate(fields(GameEntry)):
            d[Qt.DisplayRole + i] = field.name.encode()
        return d

    def rowCount(self, index: QModelIndex = QModelIndex()) -> int:
        return len(self.games_list)

    def add_game(self, game: GameEntry) -> None:
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self.games_list.append(game)
        self.endInsertRows()

    def clear(self) -> None:
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self.games_list = []
        self.endInsertRows()

    pass
