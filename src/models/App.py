from PySide6 import QtCore
from os.path import expanduser
import glob
from desktop_parser import DesktopFile
import os.path
from pathlib import Path
from PySide6.QtCore import Property, Signal, Slot, QObject
from src.models.GamesModel import Game, GamesModel


class GameShortcut:
    def __init__(self, filename, product_name, icon):
        self.filename = filename
        self.product_name = product_name
        self.icon = icon


class App(QtCore.QObject):
    def __init__(self):
        super().__init__()
        self.games_model = GamesModel()
        self.home = expanduser('~')
        self.config_location = '/.config/PortProton.conf'
        self.portproton_location = ''
        self.setup()

    def setup(self):
        try:
            with open(self.home + self.config_location, 'r') as file:
                self.portproton_location = file.read().strip()
                print(f'Current PortProton location: {self.portproton_location}')
            self.games_model.clear()
            files = glob.glob(f"{self.portproton_location}/*.desktop")
            for val in files:
                desktop_file = DesktopFile.from_file(val)
                data = desktop_file.data
                entry = data['Desktop Entry']

                name = entry['Name'] or 'generic'
                exec = 'Exec' in entry and entry['Exec'] or ''
                icon = entry['Icon']

                assert (isinstance(name, str)
                        and isinstance(exec, str)
                        and isinstance(icon, str))

                exec_split = exec.split(' ')

                # Ignore extra non-related desktop entries
                if (len(exec_split) <= 1 or
                        ('data/scripts/start.sh' not in exec_split[1] or '%F' in exec_split[-1])):
                    continue

                # TODO parse product name

                icon = (os.path.isfile(icon) and icon
                        or os.path.realpath(f"{Path(__file__).resolve().parent}../../../qml/images/game_icon.png"))

                self.games_model.add_game(Game(name=name, icon=icon, exec=exec))

        except FileNotFoundError:
            print('File not found')
        except Exception as e:
            print('An error occurred', e)
        pass

    ### SLOTS ###

    @Property(QObject, constant=True)
    def games(self):
        return self.games_model
