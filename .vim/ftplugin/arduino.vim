function! GetBoardName() abort
    return exists('g:arduino_board') && g:arduino_board ? ' <' . g:arduino_board . '>' : ''
endfunction

setlocal statusline=[%n]\ %f%<\ %m%y%h%w%r%{GetBoardName()}\ \|\ %(0x%B\ %b%)%=%p%%\ \ %(%l/%L%)%(\ \|\ %c%V%)%(\ %)

