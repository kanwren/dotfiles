set nocompatible

command! -bar Hexmode call ToggleHex()
command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!

function! SetIndents(...)
    if a:0 > 0
        execute 'setlocal tabstop=' . a:1
                    \ . ' softtabstop=' . a:1
                    \ . ' shiftwidth=' . a:1
    else
        let i = input('ts=sts=sw=', '')
        if i
            call SetIndents(i)
        endif
        echo 'ts=' . &tabstop
                    \ . ', sts=' . &softtabstop
                    \ . ', sw=' . &shiftwidth
                    \ . ', et=' . &expandtab
    endif
endfunction

function! CopyRegister()
    " Provide ' as an easier-to-type alias for "
    let r1 = substitute(nr2char(getchar()), "'", "\"", "")
    let r2 = substitute(nr2char(getchar()), "'", "\"", "")
    execute 'let @' . r2 . '=@' . r1
    echo "Copied @" . r1 . " to @" . r2
endfunction

function! ExpandSpaces()
    let [start, startv] = getpos("'<")[2:3]
    let [end, endv]     = getpos("'>")[2:3]
    " Index 3 includes overflow information for virtualedit
    let cols = abs(end + endv - start - startv) + 1
    let com  = 'normal ' . cols . 'I '
    normal gv
    execute com
endfunction

function! ToggleHex()
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    if !exists("b:editHex") || !b:editHex
        let b:oldft=&ft
        let b:oldbin=&bin
        setlocal binary
        silent :e
        let &ft="xxd"
        let b:editHex=1
        %!xxd
    else
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        let b:editHex=0
        %!xxd -r
    endif
    let &mod=l:modified
    let &readonly=l:oldreadonly
    let &modifiable=l:oldmodifiable
endfunction

function! StrToHexCodes()
    normal gvy
    let str = @"
    let i = 0
    let codes = []
    while i < strchars(str)
        call add(codes, printf("%02x", strgetchar(str, i)))
        let i += 1
    endwhile
    let @" = join(codes, ' ')
    normal gv"0P
endfunction

function! HexCodesToStr()
    normal gvy
    let codes = split(@", '\x\{2}\zs *')
    let str = ''
    for code in codes
        let str .= nr2char('0x' . code)
    endfor
    let @" = str
    normal gv"0P
endfunction

"autocmd FileType help wincmd L
syntax on
filetype on
filetype indent on
filetype plugin on

if !has('gui_running')
    set term=xterm-256color
    set t_Co=256
    let &t_ti.="\e[1 q"
    let &t_SI.="\e[5 q"
    let &t_EI.="\e[1 q"
    let &t_te.="\e[0 q"
    colorscheme elflord
else
    colorscheme elflord
endif

set encoding=utf-8
scriptencoding utf-8
set ffs=dos,unix,mac
let $LANG='en'
set nospell spelllang=en_us
set clipboard=unnamed

set shortmess+=I

set autoread
set noconfirm
set hidden

set history=1000
set undolevels=1000

set tags=tags;/

set lazyredraw

set noerrorbells
set visualbell t_vb=

set mouse-=a

set number relativenumber
set nocursorline
set laststatus=2
set statusline=buf\ %n:\ \"%F\"%<\ \ \ %m%y%h%w%r\ \ %(%b\ 0x%B%)%=%(col\ %c%)\ \ \ \ %(%l\ /\ %L%)\ \ \ \ %p%%%(\ %)
set showtabline=2
set wildmenu
set wildmode=longest:list,full
set cmdheight=1
set showcmd
set showmode
set nowrap

set magic
set showmatch
set incsearch hlsearch
set ignorecase
set smartcase

set scrolloff=0

set list listchars=tab:>-,eol:¬,extends:>,precedes:<
set modelines=0
set textwidth=80
set nrformats=bin,hex
set formatoptions=croqln

set autoindent smartindent
set tabstop=4
set cinoptions+=:0L0g0j1J1
set expandtab softtabstop=4
set shiftwidth=4
set smarttab
set noshiftround

set ttyfast
set timeout timeoutlen=500

set nojoinspaces
set virtualedit=all
set splitbelow splitright
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]

set foldmethod=manual
set foldcolumn=1
set foldlevelstart=99

highlight FoldColumn ctermbg=0
highlight Folded ctermbg=0
highlight ColorColumn ctermbg=8
set colorcolumn=81
highlight ExtraWhitespace ctermbg=12
match ExtraWhitespace /\s\+$/
highlight CursorLineNr ctermbg=4 ctermfg=15
highlight Todo ctermbg=1 ctermfg=15

noremap <C-l> :nohlsearch<CR><C-l>
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap Q @q
vnoremap Q :norm @q<CR>
vnoremap . :norm .<CR>
vnoremap gx <Esc>`.``gvP``P
noremap <silent> "" :registers<CR>

map <Space> <nop>
map <S-Space> <Space>
let mapleader=" "
" Search for word under cursor without jumping
noremap <Leader>* mx*`x
" Retab and delete trailing whitespace
noremap <Leader><Tab> mx:%s/\s\+$//ge \| retab<CR>`x
" Split line on regex
nnoremap <silent> <expr> <Leader>s ':s/' . input('sp/') . '/\r/g<CR>'
" Toggle Dvorak keyboard
nnoremap <expr> <Leader><Leader>k ':set keymap=' . (&keymap ==? 'dvorak' ? '' : 'dvorak') . '<CR>'
" Quickly copy from first to second register
noremap <silent> <Leader>r :call CopyRegister()<CR>
" Pad visual block with spaces
vnoremap <Leader>e <Esc>:call ExpandSpaces()<CR>
" Global persistent scratch file
noremap <Leader><Leader>es :edit ~/scratch<CR>
" Change working directory to directory of current buffer
noremap <expr> <Leader><Leader>cd ':cd ' . expand('%:p:h:r') . '<CR>'
" Change indentation settings on the fly
noremap <expr> <Leader><Leader>i SetIndents()
" Manage empty line insertion
nnoremap <silent> <Leader>o :<C-u>call append(line("."), repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>j<CR>
nnoremap <silent> <Leader>O :<C-u>call append(line(".") - 1, repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>k<CR>
nnoremap <silent> <Leader>n :<C-u>call append(line('.'), repeat([''], v:count1)) \| call append(line('.') - 1, repeat([''], v:count1))<CR>
vnoremap <silent> <Leader>n <Esc>:call append(line("'>"), '') \| call append(line("'<") - 1, '')<CR>
nnoremap <Leader>; mxg_a;<Esc>`x
vnoremap <Leader>; :s/\v(\s*$)(;)@<!/;/g<CR>
" Run selection
nnoremap <Leader><Leader>p :.!python<CR>
vnoremap <Leader><Leader>p :!python<CR>
nnoremap <Leader><Leader>v 0"xy$:@x<CR>
vnoremap <Leader><Leader>v "xy:@x<CR>
" Hex utilities
nnoremap <Leader>hx :Hexmode<CR>
vnoremap <Leader>he :call StrToHexCodes()<CR>
vnoremap <Leader>hd :call HexCodesToStr()<CR>
nnoremap <Leader>hs "xyiw:echo 0x<C-r>"<CR>
vnoremap <Leader>hs "xy:echo 0x<C-r>"<CR>
nnoremap <Leader>ht "xyiw:echo printf('%x', <C-r>")<CR>
vnoremap <Leader>ht "xy:echo printf('%x', <C-r>")<CR>
" Binary utilities
nnoremap <Leader>bs "xyiw:echo 0b<C-r>"<CR>
vnoremap <Leader>bs "xy:echo 0b<C-r>"<CR>
nnoremap <Leader>bt "xyiw:echo printf('%b', <C-r>")<CR>
vnoremap <Leader>bt "xy:echo printf('%b', <C-r>")<CR>

iabbrev xaz <C-r>='abcdefghijklmnopqrstuvwxyz'<CR>
iabbrev xAZ <C-r>='ABCDEFGHIJKLMNOPQRSTUVWXYZ'<CR>
iabbrev x09 <C-r>='0123456789'<CR>
iabbrev <expr> xymd   strftime("%Y-%m-%d")
iabbrev <expr> xdate  strftime("%a %d %b %Y")
iabbrev <expr> xtime  strftime("%I:%M %p")
iabbrev <expr> xmtime strftime("%H:%M")
iabbrev <expr> xiso   strftime("%Y-%m-%dT%H:%M:%S")

"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin('~/.vim/bundle/')
"Plugin 'tpope/vim-surround'
"call vundle#end()
