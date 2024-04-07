import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from src.models.App import App
from src.models.GamesModel import GamesModel

# TODO: add VirtualKeyboard

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    qml_file = Path(__file__).resolve().parent / "../qml/qml.qml"
    engine = QQmlApplicationEngine()

    app_model = App()
    context = engine.rootContext()
    context.setContextProperty("core_app", app_model)

    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())
