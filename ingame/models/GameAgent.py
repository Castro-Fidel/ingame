import os
import pickle
import requests
from steam_web_api import Steam
from steamgrid import SteamGridDB
from ingame.models.GameDescription import GameDescription
import time


class GameAgent:
    # generic_name = "Risk of rain 2"
    # scenario = 0
    # db_storage_path = ".agent-data"
    # data = dict()

    def __init__(self, config_path, cache_path):
        super().__init__()
        # TODO: move API tokens to GUI settings tab / environmental variables
        self.steam_grid_db_client = SteamGridDB("66827eabea66de47d036777ed2be87b2")
        self.steam_client = Steam("SOME_KEY_HERE_I_GUESS")

        self.config_path = config_path
        self.cache_path = cache_path
        self.db_storage_path = config_path + "/.agent-data"
        self.steam_grid_db_images_path = cache_path + "/steam_grid_db_images"
        self.data = dict()

        os.makedirs(self.config_path, exist_ok=True, mode=0o755)
        os.makedirs(self.steam_grid_db_images_path, exist_ok=True, mode=0o755)

        self.load_db()

    ''' USAGE '''

    def retrieve_game_description(self, game_name):

        if game_name not in self.data:
            # TODO: checkup for failed requests
            search_results = self.steam_client.apps.search_games(game_name)
            self.__add_game_description(search_results, game_name)

        game_description = self.data[game_name]

        return game_description.as_dict()

    ''' DATABASE '''

    def __steam_grid_db_retrieve_image(self, game_name):
        try:
            save_path = f"{self.steam_grid_db_images_path}/{game_name}.png"
            if os.path.exists(save_path):
                return save_path

            # TODO: checkup for failed requests
            result = self.steam_grid_db_client.search_game(game_name)
            grids = self.steam_grid_db_client.get_grids_by_gameid(list([result[0].id]))

            # TODO: too slow, replace loop o(n) with o(1) if possible
            for grid in grids:
                if grid.height == 900 and grid.width == 600:
                    url_img = grid.url
                    response = requests.get(url_img)
                    with open(save_path, 'wb') as file:
                        file.write(response.content)
                    # return url_img
                    return save_path
            return ''
        except:
            return ''

    def __add_game_description(self, search_results, game_name):
        game_description = GameDescription()
        game_description.locked = True
        self.data[game_name] = game_description

        # Steam game info
        if search_results['apps']:
            game_id = search_results['apps'][0]['id'][0]
            # TODO: checkup for failed requests
            app_details = self.steam_client.apps.get_app_details(game_id)
            app_data = app_details[str(game_id)]['data']

            game_description.title = app_data['name']
            game_description.desc = app_data['short_description']
            game_description.reqs = ((app_data['linux_requirements']
                                      and (
                                              app_data['linux_requirements']['minimum'] or
                                              app_data['linux_requirements']['recommended']
                                      ))
                                     or (app_data['pc_requirements']
                                         and (
                                                 app_data['pc_requirements']['minimum'] or
                                                 app_data['pc_requirements']['recommended']
                                         ))
                                     or '-')
            game_description.languages = app_data['supported_languages']

        # Steam Grid DB image retrieving
        game_description.image_location_path = self.__steam_grid_db_retrieve_image(game_name)
        game_description.locked = False
        self.save_db()

    def save_db(self):
        with open(self.db_storage_path, "wb+") as datafile:
            pickle.dump(self.data, datafile)

    def load_db(self):
        try:
            with open(self.db_storage_path, "rb") as datafile:
                self.data = pickle.load(datafile)
        except FileNotFoundError:
            self.data = dict()

    def clean_data(self):
        self.data = dict()
