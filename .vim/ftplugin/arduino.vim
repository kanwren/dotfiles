function! GetBoardType() abort
    let type = exists('g:arduino_board') && g:arduino_board ? g:arduino_board : 'none'
    return ' <' . type . '>'
endfunction

setlocal statusline=[%n]\ %f%<\ %m%y%h%w%r%{GetBoardType()}\ \|\ %(0x%B\ %b%)%=%p%%\ \ %(%l/%L%)%(\ \|\ %c%V%)%(\ %)

