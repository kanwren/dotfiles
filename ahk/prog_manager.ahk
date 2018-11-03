#/::
Input key, I L1
IfEqual key, c
    Run, C:\Program Files\cmder\Cmder.exe
IfEqual key, v
    Run, C:\Program FIles\cmder\vendor\conemu-maximus5\conemu.exe /cmd vim
IfEqual key, q
    Run, C:\Program Files\qutebrowser\qutebrowser.exe
IfEqual key, e
    Run, C:\Program Files\Everything\Everything.exe
Return

#Esc::ExitApp
