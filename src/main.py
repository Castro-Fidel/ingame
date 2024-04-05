# This Python file uses the following encoding: utf-8
import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from src.models.App import App

# TODO: add VirtualKeyboard

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    qml_file = Path(__file__).resolve().parent / "../qml/qml.qml"
    engine = QQmlApplicationEngine()
    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)
    appModel = App()
    context = engine.rootContext()
    context.setContextProperty("app", appModel)
    sys.exit(app.exec())
