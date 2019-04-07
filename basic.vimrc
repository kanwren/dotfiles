set nocompatible

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

"autocmd FileType help wincmd L
syntax on
filetype on
filetype indent on
filetype plugin on

color default

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
set statusline=buf\ %n:\ \"%F\"%<\ \ \ %m%y%h%w%r%=%(col\ %c%)\ \ \ \ \ \ %(%l\ /\ %L%)\ \ \ \ \ \ %p%%
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

highlight FoldColumn ctermbg=black
highlight Folded ctermbg=darkblue
highlight ColorColumn ctermbg=darkgray
set colorcolumn=81
highlight ExtraWhitespace ctermbg=darkcyan
match ExtraWhitespace /\s\+$/
highlight CursorLineNr ctermbg=darkblue ctermfg=white
highlight Todo ctermbg=red ctermfg=gray

noremap <C-l> :nohlsearch<CR><C-l>
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap Q @q
vnoremap Q :norm @q<CR>
vnoremap . :norm .<CR>
vnoremap gx <Esc>`.``gvP``P
"nnoremap gV `[v`]
noremap <silent> "" :registers<CR>
cnoremap <M-s> \%V

map <Space> <nop>
map <S-Space> <Space>
let mapleader=" "
nnoremap <Leader>* mx*`x
nnoremap <Leader><Leader>p :.!python<CR>
vnoremap <Leader><Leader>p :!python<CR>
nnoremap <Leader><Leader>v 0"xy$:@x<CR>
vnoremap <Leader><Leader>v "xy:@x<CR>
noremap <Leader><Leader>es :e ~/scratch<CR>
noremap <expr> <Leader><Leader>cd ':cd ' . expand('%:p:h:r')
noremap <expr> <Leader><Leader>i SetIndents()
nnoremap <silent> <expr> <Leader>sp ':s/' . input('sp/') . '/\r/g<CR>'
noremap <silent> <Leader>r CopyRegister()
vnoremap <Leader>e <Esc>:call ExpandSpaces()<CR>
nnoremap <silent> <Leader>o :<C-u>call append(line("."), repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>j<CR>
nnoremap <silent> <Leader>O :<C-u>call append(line(".") - 1, repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>k<CR>
nnoremap <silent> <Leader>n :<C-u>call append(line('.'), repeat([''], v:count1)) \| call append(line('.') - 1, repeat([''], v:count1))<CR>
vnoremap <silent> <Leader>n <Esc>:call append(line("'>"), '') \| call append(line("'<") - 1, '')<CR>
nnoremap <Leader>; mxg_a;<Esc>`x
vnoremap <Leader>; :s/\v(\s*$)(;)@<!/;/g<CR>
noremap <Leader><Tab> mx:%s/\s\+$//ge \| retab<CR>`x

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
