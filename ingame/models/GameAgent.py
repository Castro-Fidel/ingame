import os
import pickle
from steam_web_api import Steam


# TODO:
#  -Определиться, используется ли люстресс. Если да, вместо этого будет обращение к нему. Если нет,
#       продумать "рыбу" более логично.
#  -Починить отображение системных требований (точнее, разобраться, что именно возвращает API
#  -Додумать форматированные данные, что именно мы видим на странице игры?



class GameAgent:
    tempgame = "Risk of rain 2"
    datapath = "./ingame/agentdata"
    all_data = dict()
    scenario = 0

    def __init__(self):
        super().__init__()
        agent_key = "SOME_KEY_HERE_I_GUESS"
        self.steam_process = Steam(agent_key)
        self.get_all_data()

    def add_game_info(self, data, name):
        if not data['apps']:
            self.all_data[name] = 0
        else:
            gameid = data['apps'][0]['id']
            data = self.steam_process.apps.get_app_details(gameid)
            self.all_data[name] = data[str(gameid[0])]['data']
        with open(self.datapath, "wb+") as datafile:
            pickle.dump(self.all_data, datafile)
        self.get_all_data()

    def search_game(self, Gamename):
        self.get_all_data()
        if Gamename in self.all_data:
            print("ITS HERE!")
        else:
            search_results = self.steam_process.apps.search_games(Gamename)
            self.add_game_info(search_results, Gamename)
        self.format_game_data(self.all_data[Gamename])

    def get_all_data(self):
        try:
            with open(self.datapath, "rb") as datafile:
                self.all_data = pickle.load(datafile)
        except FileNotFoundError:
            self.all_data = dict()

    def format_game_data(self, gamedata):
        if gamedata != 0:
            formated_data = dict()
            formated_data['title'] = gamedata['name']
            formated_data['desc'] = gamedata['short_description']
            formated_data['languages'] = gamedata['supported_languages']
            formated_data['reqs'] = gamedata['linux_requirements']
            for key, value in formated_data.items():
                print("{0}: {1}".format(key, value))
        else:
            print("Игра не распозана!")

    def clean_data(self):
        self.all_data = dict()
        with open(self.datapath, "wb") as datafile:
            pickle.dump(self.all_data, datafile)
            print("data cleaned")