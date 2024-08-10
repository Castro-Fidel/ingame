import QtQuick
import "../constants/scene.js" as SceneConstants
//import "../components/" as C
import QtQuick.Controls as C
// Подключить для работы с типом объекта LinearGradient
import Qt5Compat.GraphicalEffects

// TODO: set Game to be child (dependent element) of Entry

Game {
    id: entry
    function press(){
        switch(entry.gameExec){
        case 'exit':
            window.close();
            break;
        }
    }
}
