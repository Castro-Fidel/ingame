var typeController = "Xbox";

//icons
var XboxIconPath = "./icons/XboxController/"
var PlayStationIconPath = "./icons/PlaystationController/"

// Цветные Xbox кнопки управления
var A_Color_Button = XboxIconPath + "a-filled-green.svg"
var X_Color_Button = XboxIconPath + "x-filled-blue.svg"
var Y_Color_Button = XboxIconPath + "y-filled-yellow.svg"
var B_Color_Button = XboxIconPath + "b-filled-red.svg"

// Однотонные Xbox кнопки управления
var A_Button = XboxIconPath + "a-filled.svg"
var X_Button = XboxIconPath + "x-filled.svg"
var Y_Button = XboxIconPath + "y-filled.svg"
var B_Button = XboxIconPath + "b-filled.svg"



function setCntroller(typeController)
{
    if(typeController === "Xbox")
    {
        // Цветные Xbox кнопки управления
        A_Color_Button = XboxIconPath + "a-filled-green.svg"
        X_Color_Button = XboxIconPath + "x-filled-blue.svg"
        Y_Color_Button = XboxIconPath + "y-filled-yellow.svg"
        B_Color_Button = XboxIconPath + "b-filled-red.svg"

        // Однотонные Xbox кнопки управления
        A_Button = XboxIconPath + "a-filled.svg"
        X_Button = XboxIconPath + "x-filled.svg"
        Y_Button = XboxIconPath + "y-filled.svg"
        B_Button = XboxIconPath + "b-filled.svg"
    }
    else if(typeController === "PlayStation")
    {
        // Цветные Xbox кнопки управления
        A_Color_Button = PlayStationIconPath + "outline-blue-cross.svg"
        X_Color_Button = PlayStationIconPath + "outline-purple-square.svg"
        Y_Color_Button = PlayStationIconPath + "outline-green-triangle.svg"
        B_Color_Button = PlayStationIconPath + "outline-red-circle.svg"

        // Однотонные Xbox кнопки управления
        A_Button = PlayStationIconPath + "plain-cross.svg"
        X_Button = PlayStationIconPath + "plain-square.svg"
        Y_Button = PlayStationIconPath + "plain-triangle.svg"
        B_Button = PlayStationIconPath + "plain-circle.svg"
    }
}
