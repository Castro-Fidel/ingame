import threading
import glob
import os.path
import subprocess
from time import sleep
from pathlib import Path
from typing import AnyStr, Union

from PySide6 import QtCore
from os.path import expanduser
from desktop_parser import DesktopFile

from ingame.models.Gamepad import Gamepad
from ingame.models.GamesModel import Game, GamesModel
from PySide6.QtCore import Property, Signal, Slot, QObject, Qt


class GameShortcut:
    def __init__(self, filename, product_name, icon):
        self.filename = filename
        self.product_name = product_name
        self.icon = icon


class App(QtCore.QObject):
    game_started = Signal(bool, name="gameStarted")
    game_ended = Signal(bool, name="gameEnded")

    gamepad_clicked_LB = Signal(bool, name="gamepadClickedLB")
    gamepad_clicked_RB = Signal(bool, name="gamepadClickedRB")
    gamepad_clicked_apply = Signal(bool, name="gamepadClickedApply")
    gamepad_clicked_back = Signal(bool, name="gamepadClickedBack")
    gamepad_axis_left = Signal(bool, name="gamepadAxisLeft")
    gamepad_axis_right = Signal(bool, name="gamepadAxisRight")

    def __init__(self):
        super().__init__()
        self.games_model: GamesModel = GamesModel()
        self.home: AnyStr = expanduser('~')
        self.config_location: str = '/.config/PortProton.conf'
        self.portproton_location: str = ''
        self.running_game_process: Union[subprocess.Popen, None] = None

        self.gamepad: Gamepad = Gamepad()
        self.gamepad.lb_clicked = lambda: self.gamepad_clicked_LB.emit(True)
        self.gamepad.rb_clicked = lambda: self.gamepad_clicked_RB.emit(True)
        self.gamepad.apply_clicked = lambda: self.gamepad_clicked_apply.emit(True)
        self.gamepad.l_clicked = lambda: self.gamepad_axis_left.emit(True)
        self.gamepad.r_clicked = lambda: self.gamepad_axis_right.emit(True)
        self.gamepad.back_clicked = lambda: self.gamepad_clicked_back.emit(True)

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

                _name = entry['Name'] or 'generic'
                _exec = 'Exec' in entry and entry['Exec'] or ''
                _icon = entry['Icon']

                assert (isinstance(_name, str)
                        and isinstance(_exec, str)
                        and isinstance(_icon, str))

                exec_split = _exec.split(' ')

                # Ignore extra non-related desktop entries
                if (len(exec_split) <= 1 or
                        ('data/scripts/start.sh' not in exec_split[1] or '%F' in exec_split[-1])):
                    continue

                # TODO parse product name

                _icon = (os.path.isfile(_icon) and _icon
                        or os.path.realpath(f"{Path(__file__).resolve().parent}../../../qml/images/PUBG.png"))

                # Автозапуск игры:
                # PW_GUI_DISABLED_CS=1
                # START_FROM_STEAM=1
                _exec = f"env START_FROM_STEAM=1 {_exec}"

                self.games_model.add_game(Game(name=_name, icon=_icon, exec=_exec))

            self.gamepad.run()

        except FileNotFoundError:
            print('File not found')
        except Exception as e:
            print('An error occurred', e)
        pass

    ### CALLBACKS ###

    def close_event(self):
        # do stuff
        # if can_exit:
        self.gamepad.terminate()
        # event.accept()  # let the window close
        # else:
        #    event.ignore()

    ### SLOTS ###

    @Slot(str)
    def start_game(self, exec):
        self.game_started.emit(True)

        def run_in_thread(t, _exec):
            t.running_game_process = subprocess.Popen(
                _exec,
                shell=True,
                bufsize=0,
                stdout=subprocess.PIPE,
                universal_newlines=True
            )
            t.running_game_process.wait()
            t.game_ended.emit(True)

            # output = self.running_game_process.stdout.read()
            # self.running_game_process.stdout.close()

            return

        thread = threading.Thread(target=run_in_thread, args=(self, exec))
        thread.start()

        pass

    ### PROPERTIES ###

    @Property(QObject, constant=True)
    def games(self):
        return self.games_model
