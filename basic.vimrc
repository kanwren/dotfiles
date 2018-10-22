set nocompatible

function! SetIndents()
    let i=input("ts=sts=sw=", "")
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

set number relativenumber

set showmatch
set incsearch hlsearch
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
call matchadd('ColorColumn', '\%81v\S', 100)
highlight ExtraWhitespace ctermbg=3
match ExtraWhitespace /\s\+$/

nnoremap Y y$
inoremap jk <ESC>
inoremap kj <ESC>
nnoremap Q @q
vnoremap Q :norm @q<CR>
vnoremap . :norm .<CR>
vnoremap gx <Esc>`.``gvP``P
map <Space> <nop>
map <S-Space> <Space>
let mapleader=" "
noremap <Leader>rcd :cd <C-r>=expand('%:p:h:r')<CR><CR>
nnoremap <Leader>ric :call SetIndents()<CR>
noremap <Leader><Tab> m`:%s/\s\+$//ge<CR>``:retab<CR>

iabbrev xymd <C-r>=strftime("%Y-%m-%d")<CR>
iabbrev xswdate <C-r>=strftime("%a %d %b %Y")<CR>

" Vundle quick installation:
" git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
" Uncomment the two calls and the set below to enable Vundle
" Uncomment the Bundle calls that you want to install
" Run PluginInstall

"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin('~/.vim/bundle/')
"
" Automatically update Vundle
"Bundle 'gmarik/Vundle.vim'
"
" Mappings for inserting/changing/deleting surrounding characters/elements
"Bundle 'tpope/vim-surround'
" File operations
"Bundle 'tpope/vim-eunuch'
" Git integration
"Bundle 'tpope/vim-fugitive'
" Quickfix/location list/buffer navigation, paired editor commands, etc.
"Bundle 'tpope/vim-unimpaired'
" Subvert and coercion
"Bundle 'tpope/vim-abolish'
"
" Easy commenting
"Bundle 'vim-scripts/tComment'
"
" Automatic pair insertion/deletion
"Bundle 'jiangmiao/auto-pairs'
" Tabularize
"Bundle 'godlygeek/tabular'
"
"call vundle#end()
