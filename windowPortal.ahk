; === [Multi-monitor Switching & Management Script] ===
; This script is written in AutoHotkey v1 syntax.

; === [Adjust monitor indexes as needed] ===
A_monitor := 3  ; Monitor A
B_monitor := 2  ; Monitor B
C_monitor := 1  ; Monitor C

SysGet, AMon, Monitor, %A_monitor%
SysGet, BMon, Monitor, %B_monitor%
SysGet, CMon, Monitor, %C_monitor%

; Default mode is AB (A+B active, C ignored)
currentMode := "AB"
ignoredMon := C_monitor
TrayTip, Monitor Mode, Now in AB mode (A+B ignoring C), 2

SetTimer, MonitorMouse, 30
return

; === [Mode Switch Hotkeys] ===
^+#b::  ; Ctrl + Win + Shift + B → Switch to AB mode
{
    ; Temporarily disable the MonitorMouse timer
    SetTimer, MonitorMouse, Off

    currentMode := "AB"
    ignoredMon := C_monitor
    TrayTip, Monitor Mode, Switched to AB mode (A+B ignoring C), 2

    CoordMode, Mouse, Screen
    MouseGetPos, curX, curY
    if (curX >= CMonLeft && curX < CMonRight && curY >= CMonTop && curY < CMonBottom)
    {
        relX := curX - CMonLeft
        relY := curY - CMonTop
        newX := BMonLeft + relX
        newY := BMonTop + relY
        if (newX < BMonLeft)
            newX := BMonLeft
        if (newX > BMonRight - 1)
            newX := BMonRight - 1
        if (newY < BMonTop)
            newY := BMonTop
        if (newY > BMonBottom - 1)
            newY := BMonBottom - 1
        DllCall("SetCursorPos", "Int", newX, "Int", newY)
    }

    Gosub, MoveOffScreenWindows

    ; Wait 300ms for positioning to stabilize
    Sleep, 300
    ; Reactivate the MonitorMouse timer
    SetTimer, MonitorMouse, 30
}
return

^+#c::  ; Ctrl + Win + Shift + C → Switch to AC mode
{
    SetTimer, MonitorMouse, Off

    currentMode := "AC"
    ignoredMon := B_monitor
    TrayTip, Monitor Mode, Switched to AC mode (A+C ignoring B), 2

    CoordMode, Mouse, Screen
    MouseGetPos, curX, curY
    if (curX >= BMonLeft && curX < BMonRight && curY >= BMonTop && curY < BMonBottom)
    {
        relX := curX - BMonLeft
        relY := curY - BMonTop
        newX := CMonLeft + relX
        newY := CMonTop + relY
        if (newX < CMonLeft)
            newX := CMonLeft
        if (newX > CMonRight - 1)
            newX := CMonRight - 1
        if (newY < CMonTop)
            newY := CMonTop
        if (newY > CMonBottom - 1)
            newY := CMonBottom - 1
        DllCall("SetCursorPos", "Int", newX, "Int", newY)
    }

    Gosub, MoveOffScreenWindows

    Sleep, 300
    SetTimer, MonitorMouse, 30
}
return

; === [Cursor Monitoring] ===
MonitorMouse:
{
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY

    if (ignoredMon = C_monitor) {
        ; In AB mode: if the cursor enters monitor C, move it back to monitor B
        if (mouseX >= CMonLeft && mouseX < CMonRight && mouseY >= CMonTop && mouseY < CMonBottom) {
            newMouseX := BMonRight - 1
            newMouseY := mouseY
            if (newMouseY < BMonTop)
                newMouseY := BMonTop
            if (newMouseY >= BMonBottom)
                newMouseY := BMonBottom - 1
            DllCall("SetCursorPos", "Int", newMouseX, "Int", newMouseY)
        }
    }
    else if (ignoredMon = B_monitor) {
        ; In AC mode:
        if (mouseX >= BMonLeft + 1000 && mouseX < BMonRight && mouseY >= BMonTop && mouseY < BMonBottom){
            newMouseX := AMonRight - 1
            newMouseY := mouseY
            if (newMouseY < AMonTop)
                newMouseY := AMonTop
            if (newMouseY >= AMonBottom)
                newMouseY := AMonBottom - 1
            DllCall("SetCursorPos", "Int", newMouseX, "Int", newMouseY)
        }
        if (mouseX >= BMonLeft && mouseX < BMonRight - 1000 && mouseY >= BMonTop && mouseY < BMonBottom){
            newMouseX := CMonLeft + 1
            newMouseY := mouseY
            if (newMouseY < CMonTop)
                newMouseY := CMonTop
            if (newMouseY >= CMonBottom)
                newMouseY := CMonBottom - 1
            DllCall("SetCursorPos", "Int", newMouseX, "Int", newMouseY)
        }
    }
}
return

; === [Subroutine: Move windows from the ignored monitor to the active monitor] ===
MoveOffScreenWindows:
{
    if (ignoredMon = C_monitor) {
        ; AB mode → ignoring C, move windows to monitor B
        offLeft := CMonLeft, offTop := CMonTop, offRight := CMonRight, offBottom := CMonBottom
        targetLeft := BMonLeft, targetTop := BMonTop, targetRight := BMonRight, targetBottom := BMonBottom
    } else if (ignoredMon = B_monitor) {
        ; AC mode → ignoring B, move windows to monitor C
        offLeft := BMonLeft, offTop := BMonTop, offRight := BMonRight, offBottom := BMonBottom
        targetLeft := CMonLeft, targetTop := CMonTop, targetRight := CMonRight, targetBottom := CMonBottom
    } else {
        return
    }

    WinGet, winList, List
    Loop, % winList {
        winID := winList%A_Index%
        ; Exclude system windows like desktop, taskbar, etc.
        WinGetClass, winClass, ahk_id %winID%
        if (winClass = "Progman" or winClass = "WorkerW" or winClass = "Shell_TrayWnd" or winClass = "Shell_SecondaryTrayWnd" or winClass = "NotifyIconOverflowWindow")
            continue

        WinGet, style, Style, ahk_id %winID%
        if !(style & 0x10000000)  ; Skip invisible windows
            continue

        WinGetPos, wx, wy, ww, wh, ahk_id %winID%
        ; Use the window's center point to determine if it's on the ignored monitor
        centerX := wx + ww/2
        centerY := wy + wh/2

        if (centerX < offLeft or centerX >= offRight or centerY < offTop or centerY >= offBottom) {
            continue
        }

        ; Calculate the new position on the target monitor
        newX := targetLeft + (centerX - offLeft) - (ww / 2)
        newY := targetTop  + (centerY - offTop)  - (wh / 2)

        if (newX < targetLeft) {
            newX := targetLeft
        }
        if (newY < targetTop) {
            newY := targetTop
        }
        if (newX + ww > targetRight) {
            newX := targetRight - ww
        }
        if (newY + wh > targetBottom) {
            newY := targetBottom - wh
        }

        WinGet, winState, MinMax, ahk_id %winID%
        ; If window is minimized (-1), just move
        ; If window is maximized (1), restore → move → maximize
        if (winState = -1) {
            WinMove, ahk_id %winID%, , %newX%, %newY%
        } else if (winState = 1) {
            WinRestore, ahk_id %winID%
            WinMove, ahk_id %winID%, , %newX%, %newY%
            WinMaximize, ahk_id %winID%
        } else {
            WinMove, ahk_id %winID%, , %newX%, %newY%
        }
    }
}
return
