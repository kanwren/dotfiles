chrome_path     := "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
cmder_path      := "C:\Program Files\cmder\Cmder.exe"
conemu_path     := "C:\Program Files\cmder\vendor\conemu-maximus5\conemu.exe"
everything_path := "C:\Program Files\Everything\Everything.exe"
office_path     := "C:\Program Files (x86)\Microsoft Office\root\Office16\"
qute_path       := "C:\Program Files\qutebrowser\qutebrowser.exe"
slack_path      := "C:\Users\nprin\AppData\Local\slack\slack.exe"
spotify_path    := "C:\Users\nprin\AppData\Roaming\Spotify\Spotify.exe"

; Program manager
#/::
input key, I L1
; Command line
if key = c
    run, %cmder_path%
; Search Everything
else if key = e
    run, %everything_path%
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
; Microsoft
else if key = m
{
    input key2, I L1
    ; Outlook
    if key2 = o
        run, %office_path%OUTLOOK.EXE
    ; Word
    else if key2 = w
        run, %office_path%WINWORD.EXE
    ; Excel
    else if key2 = e
        run, %office_path%EXCEL.EXE
    ; Onenote
    else if key2 = n
        run, %office_path%ONENOTE.EXE
    ; Excel
    else if key2 = e
        run, %office_path%EXCEL.EXE
    ; Powerpoint
    else if key2 = p
        run, %office_path%POWERPNT.EXE
}
; Qutebrowser
else if key = q
    run, %qute_path%
; Slack, Spotify
else if key = s
{
    input key2, I L1
    if key2 = sl
        run, %slack_path%
    else if key2 = sp
        run, %spotify_path%
}
; Vim
else if key = v
    run, %conemu_path% /cmd vim -c "cd ~"
Return

; Keys
Capslock::Esc
#F5::Reload
#Del::Suspend
#Esc::ExitApp
