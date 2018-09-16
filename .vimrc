set nocompatible

set diffexpr=MyDiff()
function! MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase'  | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
            if empty(&shellxquote)
                let l:shxq_sav = ''
                set shellxquote&
            endif
            let cmd = '"' . $VIMRUNTIME . '\diff"'
        else
            let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
    else
        let cmd = $VIMRUNTIME . '\diff'
    endif
    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
    if exists('l:shxq_sav')
        let &shellxquote=l:shxq_sav
    endif
endfunction

" Autocommands {{{
autocmd FileType help wincmd L
augroup plugin_group
    autocmd!
    autocmd VimEnter * RainbowParenthesesToggle
    autocmd Syntax * RainbowParenthesesLoadRound
    autocmd VimEnter * SyntasticToggleMode
augroup END
augroup vimscript_options
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
augroup java_options
    autocmd!
    autocmd FileType *.java setlocal foldmethod=syntax
    autocmd BufWritePre *.java :normal mzgg=G`z
augroup END
autocmd VimEnter * :normal zR
" }}}

" Settings Configuration {{{
syntax on
filetype on
filetype indent on
filetype plugin on

color default

set encoding=utf-8
scriptencoding utf-8
let $LANG='en'

set noswapfile nobackup autoread
set noconfirm                        " fail, don't ask to save
set hidden                           " allow working with buffers
set history=50

set laststatus=2               " For when Airline isn't available
"set ruler
set statusline=%n:\ %F\ \ \ %m%y%=%(%l,%cc\ /\ %LL%)\ \ \ \ \ %p%%

set wildmenu                         " better command-line completion
set wildmode=longest:list,full       " TODO: decide between this and longest:full,full

set cmdheight=1
set showcmd                          " show partial commands on bottom
set showmode

set noerrorbells novisualbell

set number relativenumber
set lines=51

set lazyredraw

set showmatch                        " matching brace/parens/etc.
set incsearch hlsearch
set smartcase

set nojoinspaces                     " never two spaces after sentence
set ve=block
set nospell spelllang=en_us
set splitbelow splitright            " directions for vs/sp

set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]           " direction key wrapping

set timeout timeoutlen=500

set ttyfast
set scrolloff=0                      " TODO: 5? 7?

set list listchars=tab:>-,eol:¬,extends:>,precedes:<
set modelines=0
set foldmethod=manual
set foldcolumn=1
set textwidth=80
set formatoptions=croql
"set formatoptions+=n1

set autoindent smartindent
set tabstop=4                            " treat tabs as 4 spaces wide
set cinoptions+=:0                       " Makes 'case's align with 'switch's
set expandtab softtabstop=4 shiftwidth=4 " expand tabs to 4 spaces
set smarttab
set noshiftround
" }}}

" Highlighting {{{
" Highlight column for folding
highlight FoldColumn ctermbg=1
highlight Folded ctermbg=1

highlight ColorColumn ctermbg=1
set colorcolumn=81
call matchadd('ColorColumn', '\%81v\S', 100)

highlight ExtraWhitespace ctermbg=3
match ExtraWhitespace /\s\+$/

"highlight LineNr ctermbg=0
highlight CursorLineNr ctermbg=1 ctermfg=7
" Try out :hi CursorLineNr ctermbg=12 ctermfg=7
highlight Todo ctermbg=12 ctermfg=7
"highlight MatchParen ctermbg=3
"highlight Search ctermbg=14
"}}}

" Mappings {{{
" Display mappings {{{
noremap <C-l> :noh<CR><C-l>
" Retab and delete whitespace
nnoremap <Tab> :retab<CR>mz:%s/\s\+$//ge<CR>`z
" Clear search register to prevent highlighting
noremap <C-n> :let @/=""<CR>
" }}}

" Fixing mappings {{{
" Fix screen errors when using Ctrl+FBDU
nmap <C-f> <C-f><C-l>
nmap <C-b> <C-b><C-l>
nmap <C-d> <C-d><C-l>
nmap <C-u> <C-u><C-l>
" Fix auto unindent of lines starting with # in Python, etc.
inoremap # X#
" }}}

" Convenience mappings {{{
" Familiar saving
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>gi
vnoremap <C-s> <Esc>:w<CR>gv
" Work by visual line without a count, but normal when used with one
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
" Makes temporary macros more tolerable
nnoremap Q @q
" Makes Y consistent with C and D, because I always use yy for Y anyway
nnoremap Y y$
" Display registers
nnoremap <silent> "" :registers<CR>
" Provide easier alternative to escape-hit them at the same time
inoremap jk <ESC>
inoremap kj <ESC>
" }}}

" Editing mappings {{{
nnoremap g; A;<Esc>
" Exchange operation-delete, target highlight, exchange
vnoremap gx <Esc>`.``gvP``P
" Swap word with the next full word, even across punctuation or newlines.
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:noh<CR>
" Push words 'right' or 'left', keeping cursor position constant
nnoremap <silent> <C-Right> "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>/\w\+\_W\+<CR><C-l>:noh<CR>
nnoremap <silent> <C-Left> "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o><C-l>:noh<CR>
" Insertion of single characters before or after cursor
"nnoremap <silent> <Space> :exec "normal i".nr2char(getchar())."\e"<CR>
"nnoremap <silent> <S-Space> :exec "normal a".nr2char(getchar())."\e"<CR>
" }}}

" Leader mappings {{{
map <Space> \
nmap <S-Space> <Space>
"nnoremap <Space> <nop>
"let mapleader=" "
nmap <Leader>v :e ~/dotfiles/.vimrc<CR>
nmap <Leader>sv :sou $MYVIMRC<CR>
map <Leader>tn :tabnew<CR>
map <Leader>tc :tabclose<CR>
" }}}

" Plugin mappings {{{
" NERDTree
map <F2> :NERDTreeToggle<CR>
" Syntastic
noremap <F9> :SyntasticCheck<CR>
" EasyMotion
map <Leader> <Plug>(easymotion-prefix)
nmap <Leader>f <Plug>(easymotion-s)
nmap <Leader>s <Plug>(easymotion-s2)
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)
" DragVisuals
vmap <expr> <Left> DVB_Drag('left')
vmap <expr> <Right> DVB_Drag('right')
vmap <expr> <Down> DVB_Drag('down')
vmap <expr> <Up> DVB_Drag('up')
vmap <expr> D DVB_Duplicate()
" Tabular
" Prompt for regular expression to tabularize on
noremap <expr> <Leader>a ":Tab /" . input("/") . "<CR>"
"}}}
"}}}

" Abbreviations {{{
iab xdmy <C-r>=strftime("%d/%m/%y")<CR>
iab xmdy <C-r>=strftime("%m/%d/%y")<CR>
iab xymd <C-r>=strftime("%Y-%m-%d")<CR>

" 15 Sep 2018
iab xsdate <C-r>=strftime("%d %b %Y")<CR>
" September 15, 2018
iab xldate <C-r>=strftime("%B %d, %Y")<CR>
" Sat 15 Sep 2018
iab xswdate <C-r>=strftime("%a %d %b %Y")<CR>
" Saturday, September 15, 2018
iab xlwdate <C-r>=strftime("%A, %B %d, %Y")<CR>

" 11:31 PM
iab xtime <C-r>=strftime("%I:%M %p")<CR>
" 23:31
iab xmtime <C-r>=strftime("%H:%M")<CR>

" Sat 15 Sep 2018 11:31 PM
iab xdatetime <C-r>=strftime("%a %d %b %Y %I:%M %p")<CR>
" 2018-09-15 23:31
iab xdt <C-r>=strftime("%Y-%m-%d %H:%M")<CR>
" 2018-09-15T23:31:54
iab xiso <C-r>=strftime("%Y-%m-%dT%H:%M:%S")<CR>
" }}}

" Vundle plugins {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle/')

" TODO: try these out:
" junegunn/fzf
" itchyny/lightline
" Async alternative to Syntastic like Ale
" terryma/vim-expand-region
" michaeljsmith/vim-indent-object
" terryma/vim-multiple-cursors
" maxbrunsfeld/vim-yankstack
" amix/vim-zenroom2

Bundle 'gmarik/Vundle.vim'

" Interface
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'powerline/fonts'

" Functionality
" TODO: Replace CtrlP. Like, seriously.
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-eunuch'
Bundle 'scrooloose/nerdtree'
Bundle 'vim-syntastic/syntastic'
Bundle 'tpope/vim-fugitive'
Bundle 'kien/rainbow_parentheses.vim'

" Utility plugins
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-sleuth'

Bundle 'godlygeek/tabular'
Bundle 'vim-scripts/tComment'
Bundle 'jiangmiao/auto-pairs'
Bundle 'easymotion/vim-easymotion'
Bundle 'shinokada/dragvisuals.vim'
Bundle 'vim-scripts/matchit.zip'

Bundle 'kana/vim-textobj-user'
Bundle 'kana/vim-textobj-function'

" Snippets
Bundle 'tomtom/tlib_vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'

" Language-specific
Bundle 'bps/vim-textobj-python'
Bundle 'vim-ruby/vim-ruby'
call vundle#end()
" }}}

" Plugin settings {{{
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pylint', 'pyflakes', 'flake8']
let g:syntastic_java_checkers = ['checkstyle']
let g:syntastic_java_checkstyle_classpath = 'C:/users/nprin/bin/checkstyle/checkstyle-8.12-all.jar'
let g:syntastic_java_checkstyle_conf_file = 'C:/Users/nprin/bin/checkstyle/cs1331-checkstyle.xml'

let g:ctrlp_show_hidden = 1
let g:ctrlp_open_multiple_files = 't'

let g:EasyMotion_use_upper = 0
let g:EasyMotion_smartcase = 1

let g:DVB_TrimWS = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_left_alt_sep = '»'
let g:airline_right_alt_sep = '«'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = 'ᚠ'
let g:airline_symbols.readonly = 'RO'
let g:airline_symbols.spell = 'S'

let g:rbpt_max = 15
let g:rbpt_loadcmd_toggle = 0
let g:rbpt_colorpairs = [
            \ ['blue',      'RoyalBlue3'],
            \ ['green',     'SeaGreen3'],
            \ ['red',       'firebrick3'],
            \ ]
" }}}
