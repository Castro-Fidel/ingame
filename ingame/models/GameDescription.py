from dataclasses import dataclass


@dataclass
class GameDescription:
    locked: bool = False
    title: str = 'Информация не найдена!'
    desc: str = 'Информация не найдена!'
    languages: str = 'Информация не найдена!'
    reqs: str = 'Информация не найдена!'
    image_location_path: str = ''

    def as_dict(self):
        formatted_data = dict()
        formatted_data['title'] = self.title
        formatted_data['desc'] = self.desc
        formatted_data['languages'] = self.languages
        formatted_data['reqs'] = self.reqs
        formatted_data['image_location_path'] = self.image_location_path
        return formatted_data
