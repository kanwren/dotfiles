setlocal formatoptions=croqjlnt

function! DrawImage()
    let name = input('Name of image: ', '')
    if name ==# ""
        echoerr "Image name cannot be empty"
        return
    endif
    if name =~ " "
        echoerr "Image name cannot contains spaces"
        return
    endif
    call setline('.', getline('.') . '[[local:' . name . '.png|Image|style="centerimg"]]')
    let path = expand('%:p:h') . '/' . name . '.png'
    " TODO: create and open image
endfunction

nmap <buffer> <F21> <Plug>VimwikiNextLink

nnoremap <buffer> <Leader>wa :VimwikiAll2HTML<CR>
nnoremap <buffer> <Leader>ewh yyp:s/[^\|]/-/g \| nohlsearch<CR>
map <buffer> <Leader>wp :call DrawImage()<CR>

" Wiki date header with YMD date annotation and presentable date in italics
iabbrev <buffer> xheader %date <C-r>=strftime("%Y-%m-%d")<CR><CR>_<C-r>=strftime("%a %d %b %Y")<CR>_
" Diary header with navigation and date header
iabbrev <buffer> xdiary <C-r>=expand('%:t:r')<CR><Esc><C-x>+f]i\|< prev<Esc>odiary<Esc>+f]i\|index<Esc>o<C-r>=expand('%:p:t:r')<CR><Esc><C-a>+f]i\|next ><Esc>o<CR>%date <C-r>=strftime("%Y-%m-%d")<CR><CR><C-r>=strftime("%a %d %b %Y")<CR><Esc>yss_o<CR>

" Lecture header with navigation and date header
iabbrev <buffer> xlecture %date <C-r>=strftime("%Y-%m-%d")<CR><CR>_<C-r>=strftime("%a %d %b %Y")<CR>_<CR><CR><C-r>=expand('%:p:t:r')<CR><Esc><C-x>V<CR>0f]i\|< prev<Esc>oindex<Esc>V<CR>o<C-r>=expand('%:p:t:r')<CR><Esc><C-a>V<CR>0f]i\|next ><Esc>o<CR><C-r>=expand('%:p:r')<CR><Esc>F/r F_r bgUiwd0I= <Esc>A =<CR>== - ==<CR>----<CR><CR>

let b:surround_indent = 0
let b:surround_109 = "{{$ \r }}$"
let b:surround_99 = "{{{ \r }}}"
iabbrev <buffer> xcode <Esc>:let i=b:autopairs_enabled<CR>:let b:autopairs_enabled=0<CR>i{{{<CR>}}}<Esc>:let b:autopairs_enabled=i<CR>O
iabbrev <buffer> xmj <Esc>:let i=b:autopairs_enabled<CR>:let b:autopairs_enabled=0<CR>i{{$%align%<CR>}}$<Esc>:let b:autopairs_enabled=i<CR>O

