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
let $LANG='en'

set lazyredraw

set noswapfile
set nobackup

set autoread
set noconfirm
set hidden

set history=100
set undolevels=100

set laststatus=2
set statusline=buf\ %n:\ \"%F\"%<\ \ \ %m%y%h%w%r%=%(col\ %c%)\ \ \ \ \ \ %(%l\ /\ %L%)\ \ \ \ \ \ %p%%

set wildmenu
set wildmode=longest:list,full

set cmdheight=1
set showcmd
set showmode

set noerrorbells novisualbell

set mouse-=a

set number relativenumber

set showmatch
set incsearch hlsearch
set ignorecase
set smartcase

set nojoinspaces
set ve=block
set nospell spelllang=en_us
set splitbelow splitright
set nowrap
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]

set timeout timeoutlen=500

set ttyfast
set scrolloff=0

set list listchars=tab:>-,eol:~,extends:>,precedes:<
set modelines=0
set textwidth=80
set nrformats=bin,hex
set formatoptions=croqln1

set autoindent smartindent
set tabstop=4
set cinoptions+=:0L0g0
set expandtab softtabstop=4
set shiftwidth=4
set smarttab
set noshiftround

highlight ColorColumn ctermbg=1
set colorcolumn=81
highlight ExtraWhitespace ctermbg=3
match ExtraWhitespace /\s\+$/

inoremap jk <ESC>
inoremap kj <ESC>
nnoremap Q @q
vnoremap Q :norm @q<CR>
vnoremap . :norm .<CR>
nnoremap Y y$
vnoremap gx <Esc>`.``gvP``P
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
iabbrev xalpha abcdefghijklmnopqrstuvwxyz
iabbrev xAlpha ABCDEFGHIJKLMNOPQRSTUVWXYZ
iabbrev xdigits 0123456789

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
