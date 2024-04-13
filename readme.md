# Untitled Music App

...working title

Just playing around with Pyside6, nothing to see here!

## Installation

Create a virtual env that allows access to system packages, run `pip install -e .`, and ensure you have kirigami and Pyside6 installed from your system package manager. (Yeah that's annoying I know.)

## Building

Install any build deps by running `pip install -e .[install]` and then run `pyinstaller --add-data ./src/untitledmusicplayer/qml:qml ./src/untitledmusicplayer/app.py` to build the app.

It will then appear in `dist/app/app` (or `dist/app/app.exe` on windows.)