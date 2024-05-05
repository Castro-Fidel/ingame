import typing
from dataclasses import dataclass, fields
from PySide6.QtCore import QAbstractListModel, QModelIndex, Qt, QByteArray


@dataclass
class Game:
    name: str = ''
    exec: str = ''
    icon: str = ''


class GamesModel(QAbstractListModel):

    def __init__(self):
        super().__init__()
        self._list = []

    def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> typing.Any:
        if 0 <= index.row() < self.rowCount():
            student = self._list[index.row()]
            name = self.roleNames().get(role)
            if name:
                return getattr(student, name.decode())

    def roleNames(self) -> dict[int, QByteArray]:
        d = {}
        for i, field in enumerate(fields(Game)):
            d[Qt.DisplayRole + i] = field.name.encode()
        return d

    def rowCount(self, index: QModelIndex = QModelIndex()) -> int:
        return len(self._list)

    def add_game(self, game: Game) -> None:
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self._list.append(game)
        self.endInsertRows()

    def clear(self) -> None:
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self._list = []
        self.endInsertRows()

    pass
