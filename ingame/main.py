import argparse
import sys
from pathlib import Path
from typing import cast

from PySide6.QtGui import QGuiApplication, QWindow
from PySide6.QtQml import QQmlApplicationEngine

from ingame.models.App import App


# TODO: add VirtualKeyboard

def main(fullscreen: bool = False):
    app = QGuiApplication(sys.argv)
    app_model = App()
    app.aboutToQuit.connect(app_model.close_event)
    qml_file = Path(__file__).resolve().parent / "../qml/qml.qml"
    engine = QQmlApplicationEngine()

    context = engine.rootContext()
    context.setContextProperty("core_app", app_model)

    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)

    window: QWindow = cast(QWindow, engine.rootObjects()[0])
    window.setVisibility(fullscreen and window.Visibility.FullScreen or window.Visibility.Windowed)

    sys.exit(app.exec())


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Game listing and launcher application")
    parser.add_argument(
        "--fullscreen",
        type=bool,
        help="whether to force use fullscreen mode for application or not",
        required=False,
        action=argparse.BooleanOptionalAction
    )

    args = parser.parse_args()
    main(fullscreen=args.fullscreen or False)
