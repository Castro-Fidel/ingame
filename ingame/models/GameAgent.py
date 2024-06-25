import os
import pickle
from steam_web_api import Steam

# TODO:
#  [?] Определиться, используется ли Lutris. Если да, вместо этого будет обращение к нему. Если нет,
#    продумать "рыбу" более логично.
#  [?] Починить отображение системных требований (точнее, разобраться, что именно возвращает API.
#  [done 1/2] Додумать форматированные данные, что именно мы видим на странице игры?


class GameAgent:
    generic_name = "Risk of rain 2"
    datapath = ".agent-data"
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
            game_id = data['apps'][0]['id']
            data = self.steam_process.apps.get_app_details(game_id)
            self.all_data[name] = data[str(game_id[0])]['data']
        with open(self.datapath, "wb+") as datafile:
            pickle.dump(self.all_data, datafile)
        self.get_all_data()

    def search_game(self, game_name):

        self.get_all_data()

        if game_name in self.all_data:
            print("ITS HERE!")
        else:
            search_results = self.steam_process.apps.search_games(game_name)
            self.add_game_info(search_results, game_name)
        return self.format_game_data(self.all_data[game_name])

    def get_all_data(self):
        try:
            with open(self.datapath, "rb") as datafile:
                self.all_data = pickle.load(datafile)
        except FileNotFoundError:
            self.all_data = dict()

    def format_game_data(self, game_data):
        formatted_data = dict()
        if game_data != 0:
            formatted_data['title'] = game_data['name']
            formatted_data['desc'] = game_data['short_description']
            formatted_data['languages'] = game_data['supported_languages']
            formatted_data['reqs'] = game_data['linux_requirements']
            # for key, value in formatted_data.items():
            #     print("{0}: {1}".format(key, value))
        else:
            #TODO исправить это недоразумение, временная затычка
            formatted_data['title'] = "Информация не найдена!"
            formatted_data['desc'] = "Информация не найдена!"
            formatted_data['languages'] = "Информация не найдена!"
            formatted_data['reqs'] = "Информация не найдена!"

        # print(formatted_data)
        return formatted_data

    def clean_data(self):
        self.all_data = dict()
        with open(self.datapath, "wb") as datafile:
            pickle.dump(self.all_data, datafile)
            print("data cleaned")
