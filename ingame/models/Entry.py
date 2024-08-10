from dataclasses import dataclass


# TODO: merge with GameEntry (?), remove code duplication

@dataclass
class Entry:
    name: str = ''
    exec: str = ''
    icon: str = ''
