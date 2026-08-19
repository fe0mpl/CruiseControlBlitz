#Persistent
#SingleInstance, Force
SetKeyDelay, 50, 50
SendMode Input

settingsDir := A_MyDocuments . "\CruiseControl"
if !FileExist(settingsDir)
    FileCreateDir, %settingsDir%
settingsFile := settingsDir . "\cruise_settings.ini"

IniRead, keyForward, %settingsFile%, Keys, Forward, R
IniRead, keyBackward, %settingsFile%, Keys, Backward, F
IniRead, keyStop, %settingsFile%, Keys, Stop, Space

forward_on := false
backward_on := false
cruiseActive := false

Gui, New, +Border +Resize -MaximizeBox, Cruise Control
Gui, Color, E0E0E0
Gui, Font, s10 c000000, Segoe UI

Gui, Add, Text, x20 y15 w60 h25 , Вперёд:
Gui, Add, Button, x85 y10 w80 h30 vBtnFwd gBindButton, %keyForward%

Gui, Add, Text, x180 y15 w60 h25 , Назад:
Gui, Add, Button, x245 y10 w80 h30 vBtnBwd gBindButton, %keyBackward%

Gui, Add, Text, x20 y55 w60 h25 , Стоп:
Gui, Add, Button, x85 y50 w80 h30 vBtnStop gBindButton, %keyStop%

Gui, Add, Button, x200 y50 w120 h35 hwndhToggle gToggle, Включить
SendMessage, 0x0155, 0, 0x00FF00, , ahk_id %hToggle%
SendMessage, 0x0155, 1, 0x000000, , ahk_id %hToggle%

Gui, Add, Text, x10 y100 w310 h20 center vHint, Нажмите на кнопку, затем нажмите клавишу (Esc – отмена)

GuiControl, Focus, %hToggle%
Gui, Show, w330 h135, Cruise Control

binding := false
bindTarget := ""
oldKey := ""

BindButton:
    if (cruiseActive) {
        ToolTip, Сначала выключите круиз!
        SetTimer, RemoveToolTip, -2000
        return
    }
    bindTarget := A_GuiControl
    if (bindTarget = "BtnFwd")
        oldKey := keyForward
    else if (bindTarget = "BtnBwd")
        oldKey := keyBackward
    else if (bindTarget = "BtnStop")
        oldKey := keyStop
    binding := true
    GuiControl, , %bindTarget%, ...
    GuiControl, , Hint, Нажмите клавишу (Esc – отмена)
    OnMessage(0x0100, "KeyDown")
    OnMessage(0x0101, "KeyDown")
return

KeyDown(wParam, lParam, msg, hwnd) {
    global binding, bindTarget, oldKey, keyForward, keyBackward, keyStop, cruiseActive
    if (!binding)
        return
    vk := (wParam & 0xFF)
    if (vk = 0x10 || vk = 0x11 || vk = 0x12 || vk = 0x5B || vk = 0x5C)
        return
    keyName := GetKeyName(Format("VK{:02X}", vk))
    if (keyName = "Escape") {
        GuiControl, , %bindTarget%, %oldKey%
        GuiControl, , Hint, Нажмите на кнопку, затем нажмите клавишу (Esc – отмена)
        binding := false
        OnMessage(0x0100, "")
        OnMessage(0x0101, "")
        return
    }
    mods := ""
    if GetKeyState("Ctrl", "P")
        mods .= "^"
    if GetKeyState("Alt", "P")
        mods .= "!"
    if GetKeyState("Shift", "P")
        mods .= "+"
    if GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
        mods .= "#"
    fullKey := mods . keyName
    try {
        Hotkey, %fullKey%, DummyLabel, On
        Hotkey, %fullKey%, DummyLabel, Off
    } catch {
        GuiControl, +cFF0000, %bindTarget%
        GuiControl, , Hint, Ошибка: неверная комбинация
        Sleep 1000
        GuiControl, +c000000, %bindTarget%
        GuiControl, , %bindTarget%, %oldKey%
        GuiControl, , Hint, Нажмите на кнопку, затем нажмите клавишу (Esc – отмена)
        binding := false
        OnMessage(0x0100, "")
        OnMessage(0x0101, "")
        return
    }
    GuiControl, , %bindTarget%, %fullKey%
    if (bindTarget = "BtnFwd")
        keyForward := fullKey
    else if (bindTarget = "BtnBwd")
        keyBackward := fullKey
    else if (bindTarget = "BtnStop")
        keyStop := fullKey
    Gosub, SaveSettings
    GuiControl, +c000000, %bindTarget%
    GuiControl, , Hint, Готово: %fullKey%
    binding := false
    OnMessage(0x0100, "")
    OnMessage(0x0101, "")
    if (cruiseActive) {
        Gosub, ReloadHotkeys
    }
    SetTimer, RemoveHint, -1500
}

RemoveHint:
    GuiControl, , Hint, Нажмите на кнопку, затем нажмите клавишу (Esc – отмена)
return

DummyLabel:
return

SaveSettings:
    IniWrite, %keyForward%, %settingsFile%, Keys, Forward
    IniWrite, %keyBackward%, %settingsFile%, Keys, Backward
    IniWrite, %keyStop%, %settingsFile%, Keys, Stop
return

RemoveToolTip:
    ToolTip
return

SendKeys(keys) {
    SendInput %keys%
}

StopCruise:
    if (forward_on or backward_on) {
        ToolTip, СТОП
        SetTimer, RemoveToolTip, -1000
    }
    SendKeys("{w up}{s up}")
    forward_on := false
    backward_on := false
return

UpdateKeys:
    if (cruiseActive) {
        Gosub, ReloadHotkeys
    }
return

ReloadHotkeys:
    Hotkey, %keyForward%, CruiseForward, Off UseErrorLevel
    Hotkey, %keyBackward%, CruiseBackward, Off UseErrorLevel
    Hotkey, ~%keyStop%, StopCruise, Off UseErrorLevel
    if (cruiseActive) {
        Hotkey, %keyForward%, CruiseForward, On UseErrorLevel
        Hotkey, %keyBackward%, CruiseBackward, On UseErrorLevel
        Hotkey, ~%keyStop%, StopCruise, On UseErrorLevel
    }
return

CruiseForward:
    if (forward_on) {
        Gosub, StopCruise
    } else {
        Gosub, StopCruise
        SendKeys("{w down}")
        forward_on := true
        backward_on := false
        ToolTip, КРУИЗ ВПЕРЁД
        SetTimer, RemoveToolTip, -1000
    }
return

CruiseBackward:
    if (backward_on) {
        Gosub, StopCruise
    } else {
        Gosub, StopCruise
        SendKeys("{s down}")
        backward_on := true
        forward_on := false
        ToolTip, КРУИЗ НАЗАД
        SetTimer, RemoveToolTip, -1000
    }
return

Toggle:
    if (cruiseActive) {
        cruiseActive := false
        Hotkey, %keyForward%, CruiseForward, Off
        Hotkey, %keyBackward%, CruiseBackward, Off
        Hotkey, ~%keyStop%, StopCruise, Off
        Gosub, StopCruise
        GuiControl, Enable, BtnFwd
        GuiControl, Enable, BtnBwd
        GuiControl, Enable, BtnStop
        GuiControl, , %hToggle%, Включить
        SendMessage, 0x0155, 0, 0x00FF00, , ahk_id %hToggle%
        SendMessage, 0x0155, 1, 0x000000, , ahk_id %hToggle%
    } else {
        cruiseActive := true
        Gosub, UpdateKeys
        Hotkey, %keyForward%, CruiseForward, On
        Hotkey, %keyBackward%, CruiseBackward, On
        Hotkey, ~%keyStop%, StopCruise, On
        GuiControl, Disable, BtnFwd
        GuiControl, Disable, BtnBwd
        GuiControl, Disable, BtnStop
        GuiControl, , %hToggle%, Выключить
        SendMessage, 0x0155, 0, 0x0000FF, , ahk_id %hToggle%
        SendMessage, 0x0155, 1, 0xFFFFFF, , ahk_id %hToggle%
    }
return

GuiClose:
    if (cruiseActive) {
        Hotkey, %keyForward%, CruiseForward, Off
        Hotkey, %keyBackward%, CruiseBackward, Off
        Hotkey, ~%keyStop%, StopCruise, Off
        Gosub, StopCruise
    }
    ExitApp