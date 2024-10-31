#Requires AutoHotkey v2.0
#SingleInstance Force
#Include "./lib/LibIndex.ahk"
#Include "./src/App.ahk"

; configs
version := "0.0.1"
popupTitle := "TableReserve " . version
winGroup := ["ahk_class SunAwtFrame"]
db := useFileDB({
    main: A_ScriptDir . "\db",
    cleanPeriod: 30
})

; gui
TableReserve := Gui(, popupTitle)
TableReserve.SetFont(, "微软雅黑")
TableReserve.OnEvent("Close", (*) => utils.quitApp("TableReserve", popupTitle, winGroup))

App(TableReserve)

; TableReserve.Show()

; hotkey setup
Pause:: TableReserve.Show()
F11:: utils.cleanReload(winGroup)
#Hotif WinActive(popupTitle)
Esc:: TableReserve.Hide()