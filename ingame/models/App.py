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
from platformdirs import user_cache_dir, user_config_dir

from ingame.models.EntriesModel import EntriesModel
from ingame.models.Entry import Entry
from ingame.models.Gamepad import Gamepad
from ingame.models.GamesModel import GamesModel
from ingame.models.GameEntry import GameEntry
from ingame.models.GameAgent import GameAgent
from PySide6.QtCore import Property, Signal, Slot, QObject, Qt


class App(QtCore.QObject):
    app_name = "ingame"
    app_author = "foss"

    game_list_details_retrieving_progress = Signal(float, name="gameListDetailsRetrievingProgress")

    game_started = Signal(bool, name="gameStarted")
    game_ended = Signal(bool, name="gameEnded")
    data_found = Signal(dict, name="gotGameData")
    gamepad_clicked_LB = Signal(bool, name="gamepadClickedLB")
    gamepad_clicked_RB = Signal(bool, name="gamepadClickedRB")
    gamepad_clicked_apply = Signal(bool, name="gamepadClickedApply")
    gamepad_clicked_back = Signal(bool, name="gamepadClickedBack")
    gamepad_axis_up = Signal(bool, name="gamepadAxisUp")
    gamepad_axis_down = Signal(bool, name="gamepadAxisDown")
    gamepad_axis_left = Signal(bool, name="gamepadAxisLeft")
    gamepad_axis_right = Signal(bool, name="gamepadAxisRight")

    def __init__(self):
        super().__init__()
        self.home: AnyStr = expanduser('~')
        self.config_path = user_config_dir(App.app_name, App.app_author)
        self.cache_path = user_cache_dir(App.app_name, App.app_author)

        self.portproton_games_model: GamesModel = GamesModel()
        self.native_games_model: GamesModel = GamesModel()
        self.system_entries_model: EntriesModel = EntriesModel()
        self.portproton_config_location: str = '/.config/PortProton.conf'
        self.portproton_location: str = ''
        self.running_game_process: Union[subprocess.Popen, None] = None

        self.gamepad: Gamepad = Gamepad()
        self.gamepad.lb_clicked = lambda: self.gamepad_clicked_LB.emit(True)
        self.gamepad.rb_clicked = lambda: self.gamepad_clicked_RB.emit(True)
        self.gamepad.apply_clicked = lambda: self.gamepad_clicked_apply.emit(True)
        self.gamepad.l_clicked = lambda: self.gamepad_axis_left.emit(True)
        self.gamepad.r_clicked = lambda: self.gamepad_axis_right.emit(True)
        self.gamepad.u_clicked = lambda: self.gamepad_axis_up.emit(True)
        self.gamepad.d_clicked = lambda: self.gamepad_axis_down.emit(True)
        self.gamepad.back_clicked = lambda: self.gamepad_clicked_back.emit(True)

        self.agent = GameAgent(self.config_path, self.cache_path)

        self.setup()

    def setup(self):
        try:
            with open(self.home + self.portproton_config_location, 'r') as file:
                self.portproton_location = file.read().strip()
                print(f'Current PortProton location: {self.portproton_location}')
                self.__portproton_games_setup(glob.glob(f"{self.portproton_location}/*.desktop"))
        except FileNotFoundError:
            print('File not found')
        except Exception as e:
            print('An error occurred', e)

        self.__native_games_setup()
        self.__system_entries_setup()
        self.gamepad.run()
        self.retrieve_games_details()

    def __native_games_setup(self):
        # Reference: https://askubuntu.com/a/490398
        # TODO: replace with DesktopFile instance
        self.native_games_model.clear()

        for val in glob.glob("/usr/share/applications/*.desktop"):
            try:
                desktop_file = DesktopFile.from_file(val)
                desktop_file_data = desktop_file.data
                desktop_entry = desktop_file_data['Desktop Entry']

                if 'Categories' not in desktop_entry:
                    continue

                # Game;ArcadeGame;
                entry_categories = desktop_entry['Categories'] or ''
                if "Game" not in entry_categories:
                    continue

                entry_name = desktop_entry['Name'] or 'generic'
                entry_exec = 'Exec' in desktop_entry and desktop_entry['Exec'] or ''
                entry_icon = '' # desktop_entry['Icon']

                assert (isinstance(entry_name, str)
                        and isinstance(entry_exec, str)
                        and isinstance(entry_icon, str))

                self.native_games_model.add_game(GameEntry(name=entry_name, icon=entry_icon, exec=entry_exec))
            except:
                continue

    def __portproton_games_setup(self, files):
        self.portproton_games_model.clear()
        for val in files:
            try:
                desktop_file = DesktopFile.from_file(val)
                desktop_file_data = desktop_file.data
                desktop_entry = desktop_file_data['Desktop Entry']

                entry_name = desktop_entry['Name'] or 'generic'
                entry_exec = 'Exec' in desktop_entry and desktop_entry['Exec'] or ''
                entry_icon = desktop_entry['Icon']

                assert (isinstance(entry_name, str)
                        and isinstance(entry_exec, str)
                        and isinstance(entry_icon, str))

                entry_exec_split = entry_exec.split(' ')

                # Ignore extra non-related desktop entries
                if (len(entry_exec_split) <= 1 or
                        ('data/scripts/start.sh' not in entry_exec_split[1] or '%F' in entry_exec_split[-1])):
                    continue

                # TODO parse product name

                entry_icon = (os.path.isfile(entry_icon) and entry_icon) or ''

                # Remove extra env in the beginning
                entry_exec = f"env START_FROM_STEAM=1 {entry_exec[4:len(entry_exec)]}"

                self.portproton_games_model.add_game(GameEntry(name=entry_name, icon=entry_icon, exec=entry_exec))
            except:
                continue

    def __system_entries_setup(self):
        self.system_entries_model.add_entry(Entry(name="Exit launcher", icon="../images/exit.svg", exec="exit"))
        pass

    # TODO: fix: progress=1.0 not emitted if details already cached/downloaded
    def retrieve_games_details(self):
        def retrieve_games_details_thread(t, model):
            t.game_list_details_retrieving_progress.emit(0.0)
            all_count: int = len(model.games_list)
            game_entry: GameEntry
            i: int = 0
            for game_entry in model.games_list:
                game_description = t.agent.retrieve_game_description(game_entry.name)
                game_entry.icon = game_description['image_location_path'] or game_entry.icon
                t.game_list_details_retrieving_progress.emit(float(i) / all_count)
                i += 1
            t.game_list_details_retrieving_progress.emit(1.0)

        thread = threading.Thread(target=retrieve_games_details_thread, args=(self, self.portproton_games_model))
        thread.start()

        thread = threading.Thread(target=retrieve_games_details_thread, args=(self, self.native_games_model))
        thread.start()

    ''' CALLBACKS '''

    def close_event(self):
        self.gamepad.terminate()
        self.agent.clean_data()
        # self.agent.save_db()

    ''' SLOTS '''

    @Slot(str, result=dict)
    def get_game_data(self, game_name):
        def get_game_data_thread(t, name):
            search_result = t.agent.retrieve_game_description(name)
            t.data_found.emit(search_result)
            return

        thread = threading.Thread(target=get_game_data_thread, args=(self, game_name))
        thread.start()

    @Slot(str)
    def start_game(self, _exec):
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
            return

        thread = threading.Thread(target=run_in_thread, args=(self, _exec))
        thread.start()

    ''' PROPERTIES '''

    @Property(QObject, constant=True)
    def games(self):
        return self.portproton_games_model

    @Property(QObject, constant=True)
    def native_games(self):
        return self.native_games_model

    @Property(QObject, constant=True)
    def system_entries(self):
        return self.system_entries_model
