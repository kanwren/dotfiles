office_path := "C:\Program Files (x86)\Microsoft Office\root\Office16\"
chrome_path := "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

; Program manager
#/::
input key, I L1
; Command line
if key = c
    run, C:\Program Files\cmder\Cmder.exe
; Vim
else if key = v
    run, C:\Program Files\cmder\vendor\conemu-maximus5\conemu.exe /cmd vim
; Qutebrowser
else if key = q
    run, C:\Program Files\qutebrowser\qutebrowser.exe
; Search Everything
else if key = e
    run, C:\Program Files\Everything\Everything.exe
; Microsoft
else if key = m
{
    input key2, I L1
    if key2 = o
        run, %office_path%OUTLOOK.EXE
    else if key2 = w
        run, %office_path%WINWORD.EXE
    else if key2 = e
        run, %office_path%EXCEL.EXE
    else if key2 = n
        run, %office_path%ONENOTE.EXE
    else if key2 = e
        run, %office_path%EXCEL.EXE
    else if key2 = p
        run, %office_path%POWERPNT.EXE
}
; Google
else if key = g
{
    input key2, I L2
    ; Google Drive
    if key2 = dr
        run, %chrome_path% "https://www.drive.google.com/"
    ; Google Docs
    else if key2 = do
        run, %chrome_path% "https://www.docs.google.com/"
    ; Google Sheets
    else if key2 = sh
        run, %chrome_path% "https://www.sheets.google.com/"
    ; Google Slides
    else if key2 = sl
        run, %chrome_path% "https://www.slides.google.com/"
}
Return

; Keys
Capslock::Esc

#Del::Suspend
Return

#Esc::ExitApp
