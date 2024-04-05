from PySide6 import QtCore
from os.path import expanduser
import glob
from desktop_parser import DesktopFile


class GameShortcut:
    def __init__(self, filename, product_name, icon):
        self.filename = filename
        self.product_name = product_name
        self.icon = icon


class App(QtCore.QObject):
    def __init__(self):
        super().__init__()
        self.home = expanduser('~')
        self.config_location = '/.config/PortProton.conf'
        self.portproton_location = ''
        self.setup()

    def setup(self):
        try:
            with open(self.home + self.config_location, 'r') as file:
                self.portproton_location = file.read().strip()
            print(f'Current PortProton location: {self.portproton_location}')

            files = glob.glob(f"{self.portproton_location}/*.desktop")
            # for val in files:
            #    print(val)
            # desktop_file = DesktopFile.from_file("path/to/file.desktop")
        except FileNotFoundError:
            print('File not found')
        except Exception:
            print('An error occurred')
        pass

    ### SLOTS ###

    @QtCore.Slot()
    def get_games(self):
        pass
