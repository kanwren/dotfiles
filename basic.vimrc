set nocompatible

function! SetIndents()
    let i = input("ts=sts=sw=", "")
    if !i
        let i = &softtabstop
    endif
    exec "setlocal tabstop=" . i
    exec "setlocal softtabstop=" . i
    exec "setlocal shiftwidth=" . i
endfunction

autocmd FileType help wincmd L
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

set autoread
set noconfirm
set hidden

set history=1000
set undolevels=1000

set tags=tags;/

set lazyredraw

set noerrorbells novisualbell

set mouse-=a

set number relativenumber
set nocursorline
set laststatus=2
set statusline=buf\ %n:\ \
set wildmenu
set wildmode=longest:list,full
set cmdheight=1
set showcmd
set showmode
set nowrap

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
set cinoptions+=:0L0g0
set expandtab softtabstop=4
set shiftwidth=4
set smarttab
set noshiftround

set ttyfast
set timeout timeoutlen=500

set nojoinspaces
set virtualedit=block
set splitbelow splitright
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]

set foldmethod=manual
set foldcolumn=1
set foldlevelstart=99

highlight ColorColumn ctermbg=1
set colorcolumn=81
highlight ExtraWhitespace ctermbg=3
match ExtraWhitespace /\s\+$/

noremap <C-l> :nohlsearch<CR><C-l>
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
inoremap jk <ESC>
inoremap kj <ESC>
nnoremap Q @q
vnoremap Q :norm @q<CR>
vnoremap . :norm .<CR>
nnoremap Y y$
vnoremap gx <Esc>`.``gvP``P
nnoremap gV `[v`]

map <Space> <nop>
map <S-Space> <Space>
let mapleader=" "
noremap <Leader><Leader>es :e ~/scratch<CR>
noremap <Leader><Leader>ev :e ~/dotfiles/.vimrc<CR>
noremap <Leader><Leader>sv :sou $MYVIMRC<CR>
noremap <Leader><Leader>cd :cd <C-r>=expand('%:p:h:r')<CR><CR>
noremap <Leader><Leader>ic :call SetIndents()<CR>
nnoremap <Leader>en m`O<Esc>jo<Esc>``
vnoremap <Leader>en <Esc>`<O<Esc>`>o<Esc>'>
noremap <Leader><Tab> m`:%s/\s\+$//ge<CR>``:retab<CR>

iabbrev xymd <C-r>=strftime("%Y-%m-%d")<CR>
iabbrev xswdate <C-r>=strftime("%a %d %b %Y")<CR>
iabbrev xdatetime <C-r>=strftime("%a %d %b %Y %I:%M %p")<CR>
iabbrev xalpha <C-r>="abcdefghijklmnopqrstuvwxyz"<CR>
iabbrev xAlpha <C-r>="ABCDEFGHIJKLMNOPQRSTUVWXYZ"<CR>
iabbrev xdigits <C-r>="0123456789"<CR>

" Vundle quick installation:
" git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
" Uncomment the two calls and the set below to enable Vundle
" Uncomment the Bundle calls that you want to install
" Run PluginInstall

"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin('~/.vim/bundle/')
"
" - Automatically update Vundle
"Bundle 'gmarik/Vundle.vim'
"
" - Repeating more actions with .
"Bundle 'tpope/vim-repeat'
" - Mappings for inserting/changing/deleting surrounding characters/elements
"Bundle 'tpope/vim-surround'
" - File operations
"Bundle 'tpope/vim-eunuch'
" - Git integration
"Bundle 'tpope/vim-fugitive'
" - Quickfix/location list/buffer navigation, paired editor commands, etc.
"Bundle 'tpope/vim-unimpaired'
" - Subvert and coercion
"Bundle 'tpope/vim-abolish'
"
" - Easy commenting
"Bundle 'vim-scripts/tComment'
"
" - Automatic pair insertion/deletion
"Bundle 'jiangmiao/auto-pairs'
" Tabularize
"Bundle 'godlygeek/tabular'
"
" - High level plugins
"Bundle 'junegunn/fzf.vim'
"Bundle 'itchyny/lightline'
"Bundle 'scrooloose/nerdtree'
"Bundle 'w0rp/ale'
"
"call vundle#end()
