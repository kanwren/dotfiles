set nocompatible

" Functions {{{
function! ClearRegisters()
    let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-*+"'
    let i = 0
    while (i < strlen(regs))
        exec 'let @' . regs[i] . '=""'
        let i += 1
    endwhile
    unlet regs
endfunction

function! DelAllMarks()
    delmarks!
    delmarks A-Z0-9
endfunction

function! SetIndents()
    let i = input("ts=sts=sw=", "")
    if !i
        let i = &softtabstop
    endif
    exec "setlocal tabstop=" . i
    exec "setlocal softtabstop=" . i
    exec "setlocal shiftwidth=" . i
endfunction
" }}}

" Autocommands {{{
if has('autocmd')
    autocmd FileType help wincmd L
    augroup plugin_group
        autocmd!
        autocmd VimEnter * RainbowParenthesesToggle
        autocmd Syntax * RainbowParenthesesLoadRound
        autocmd StdinReadPre * let s:std_in=1
    augroup END
    augroup java_group
        autocmd!
        autocmd FileType java setlocal foldmethod=syntax
    augroup END
    augroup python_group
        autocmd!
        autocmd FileType python setlocal nosmartindent
    augroup END
    augroup javascript_group
        autocmd!
        autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
    augroup END
    augroup pug_group
        autocmd!
        autocmd FileType pug setlocal shiftwidth=2 tabstop=2 softtabstop=2
    augroup END
    augroup wiki_group
        autocmd!
        autocmd FileType vimwiki map <F10> :VimwikiAll2HTML<CR>
        autocmd FileType vimwiki setlocal formatoptions+=t
    augroup END
    augroup general_group
        " Return to last edit position when opening files
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    augroup END
endif
" }}}

" Settings {{{
syntax on
filetype on
filetype indent on
filetype plugin on

" Backups {{{
set swapfile
set backup
set writebackup
set backupdir=~/.vim/backup
set directory^=~/.vim/tmp
" }}}

color default

set encoding=utf-8
scriptencoding utf-8
set ffs=dos,unix,mac
let $LANG='en'
set nospell spelllang=en_us

set autoread
set noconfirm                        " fail, don't ask to save
set hidden                           " allow working with buffers

set history=1000
set undolevels=1000

set tags=tags;/

set lazyredraw

set noerrorbells novisualbell
set t_vb=

set mouse-=a

set number relativenumber
set nocursorline
set laststatus=2                     " For when Airline isn't available
set statusline=buf\ %n:\ \"%F\"%<\ \ \ %m%y%h%w%r%=%(col\ %c%)\ \ \ \ \ \ %(%l\ /\ %L%)\ \ \ \ \ \ %p%%
set wildmenu                         " better command-line completion
set wildmode=longest:list,full       " TODO: decide between this and longest:full,full
set cmdheight=1
set showcmd                          " show partial commands on bottom
set showmode
set nowrap

set magic
set showmatch                        " matching brace/parens/etc.
set incsearch hlsearch
set ignorecase
set smartcase

set scrolloff=0                      " TODO: 5? 7?

set list listchars=tab:>-,eol:¬,extends:>,precedes:<
set modelines=1
set textwidth=80
set nrformats=bin,hex                " Don't increment octal numbers
set formatoptions=croqln
" c=wrap comments
" r=insert comment on enter
" o=insert comment on o/O
" q=allow formatting of comments with gq
" l=don't break lines longer than textwidth before insert started
" n=recognize numbered lists

set autoindent smartindent
set tabstop=4               " treat tabs as 4 spaces wide
set cinoptions+=:0L0g0      " indent distance for case, jumps, scope declarations
set expandtab softtabstop=4 " expand tabs to 4 spaces
set shiftwidth=4            " use 4 spaces when using > or <
set smarttab
set noshiftround

set ttyfast
set timeout timeoutlen=500

set nojoinspaces                     " never two spaces after sentence
set virtualedit=block
set splitbelow splitright            " directions for vs/sp
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]           " direction key wrapping

set foldmethod=manual
set foldcolumn=1
set foldlevelstart=99
" }}}

" Highlighting {{{
" Highlight column for folding
highlight FoldColumn ctermbg=black
highlight Folded ctermbg=darkblue

highlight ColorColumn ctermbg=darkgray
set colorcolumn=81
"call matchadd('ColorColumn', '\%81v\S', 100)

highlight ExtraWhitespace ctermbg=darkcyan
match ExtraWhitespace /\s\+$/

highlight CursorLineNr ctermbg=darkblue ctermfg=white
highlight Todo ctermbg=red ctermfg=gray
"}}}

" Mappings {{{
" Display mappings {{{
noremap <C-l> :nohlsearch<CR><C-l>
" }}}

" Fixing mappings {{{
" Fix screen errors when using Ctrl+FBDU
map <C-f> <C-f><C-l>
map <C-b> <C-b><C-l>
map <C-d> <C-d><C-l>
map <C-u> <C-u><C-l>
" }}}

" Convenience mappings {{{
" Work by visual line without a count, but normal when used with one
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
" Provide easier alternative to escape-hit them at the same time
inoremap jk <Esc>
inoremap kj <Esc>
" Makes temporary macros more tolerable
nnoremap Q @q
" Repeat macros/commands across visual selections
vnoremap Q :norm @q<CR>
vnoremap . :norm .<CR>
" Makes Y consistent with C and D, because I always use yy for Y anyway
nnoremap Y y$
" Highlight last inserted text
nnoremap gV `[v`]
" Exchange operation-delete, target highlight, exchange
vnoremap gx <Esc>`.``gvP``P
" Display registers
noremap <silent> "" :registers<CR>
" }}}

" Leader mappings {{{
map <Space> <nop>
map <S-Space> <Space>
let mapleader=" "

" Abbreviated commands (prefixed with second <Leader>)
noremap <Leader><Leader>es :e ~/scratch<CR>
noremap <Leader><Leader>ev :e ~/dotfiles/.vimrc<CR>
noremap <Leader><Leader>sv :sou $MYVIMRC<CR>
" Change working directory to directory of current file
noremap <Leader><Leader>cd :cd <C-r>=expand('%:p:h:r')<CR><CR>
" Modify indent level on the fly
noremap <Leader><Leader>ic :call SetIndents()<CR>

" Saved macros for editing (prefixed with 'e')
" Add newlines around current line or selection
nnoremap <Leader>en m`O<Esc>jo<Esc>``
vnoremap <Leader>en <Esc>`<O<Esc>`>o<Esc>'>
" Add header row to tables in Vimwiki
nnoremap <Leader>ewh yyp:s/[^\|]/-/g<CR>:nohlsearch<CR>

" Copy unnamed register to clipboard
noremap <Leader>cb :let @*=@"<CR>
" Add semicolon at end of line without moving cursor
nnoremap <Leader>; m`A;<Esc>``
" Retab and delete whitespace
noremap <Leader><Tab> m`:%s/\s\+$//ge<CR>``:retab<CR>
" }}}

" Plugin mappings {{{
" NERDTree
map <F2> :NERDTreeToggle<CR>
" DragVisuals
vmap <expr> <Left> DVB_Drag('left')
vmap <expr> <Right> DVB_Drag('right')
vmap <expr> <Down> DVB_Drag('down')
vmap <expr> <Up> DVB_Drag('up')
vmap <expr> D DVB_Duplicate()
" Tabular
" Prompt for regular expression to tabularize on
noremap <expr> <Leader>a ":Tab /" . input("/") . "<CR>"
" Vimwiki
nmap glo :VimwikiChangeSymbolTo *<CR>
nmap gLo :VimwikiChangeSymbolInListTo *<CR>
"}}}
"}}}

" Abbreviations {{{
iabbrev <expr> xdmy strftime("%d/%m/%y")
iabbrev <expr> xmdy strftime("%m/%d/%y")
iabbrev <expr> xymd strftime("%Y-%m-%d")

" 15 Sep 2018
iabbrev <expr> xsdate strftime("%d %b %Y")
" September 15, 2018
iabbrev <expr> xldate strftime("%B %d, %Y")
" Sat 15 Sep 2018
iabbrev <expr> xswdate strftime("%a %d %b %Y")
" Saturday, September 15, 2018
iabbrev <expr> xlwdate strftime("%A, %B %d, %Y")

" 11:31 PM
iabbrev <expr> xtime strftime("%I:%M %p")
" 23:31
iabbrev <expr> xmtime strftime("%H:%M")

" Sat 15 Sep 2018 11:31 PM
iabbrev <expr> xdatetime strftime("%a %d %b %Y %I:%M %p")
" 2018-09-15 23:31
iabbrev <expr> xdt strftime("%Y-%m-%d %H:%M")
" 2018-09-15T23:31:54
iabbrev <expr> xiso strftime("%Y-%m-%dT%H:%M:%S")

" Wiki date header with YMD date annotation and presentable date in italics
iabbrev xheader %date <C-r>=strftime("%Y-%m-%d")<CR><CR>_<C-r>=strftime("%a %d %b %Y")<CR>_

" Diary header with navigation and date header
iabbrev xdiary <C-r>=expand('%:t:r')<CR><Esc><C-x>+f]i\|< prev<Esc>odiary<Esc>+f]i\|index<Esc>o<C-r>=expand('%:t:r')<CR><Esc><C-a>+f]i\|next ><Esc>o<CR>%date <C-r>=strftime("%Y-%m-%d")<CR><CR><C-r>=strftime("%a %d %b %Y")<CR><Esc>yss_o<CR>

" Lecture header with navigation and date header
iabbrev xlecture %date <C-r>=strftime("%Y-%m-%d")<CR><CR>_<C-r>=strftime("%a %d %b %Y")<CR>_<CR><CR><C-r>=expand('%:t:r')<CR><Esc><C-x>V<CR>0f]i\|< prev<Esc>oindex<Esc>V<CR>o<C-r>=expand('%:t:r')<CR><Esc><C-a>V<CR>0f]i\|next ><Esc>o

" Abbreviations for inserting common sequences
iabbrev <expr> xalpha "abcdefghijklmnopqrstuvwxyz"
iabbrev <expr> xAlpha "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
iabbrev <expr> xdigits "0123456789"

" Abbreviations for getting the path and filepath
abbreviate <expr> xpath expand('%:p:h')
abbreviate <expr> xfpath expand('%:p')
" }}}

" Vundle plugins {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle/')

" TODO: try these out:
" itchyny/lightline
" michaeljsmith/vim-indent-object
" terryma/vim-expand-region
" terryma/vim-multiple-cursors
" maxbrunsfeld/vim-yankstack
" amix/vim-zenroom2

Bundle 'gmarik/Vundle.vim'

Bundle 'vimwiki/vimwiki'

" Interface
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'powerline/fonts'

" Functionality
" TODO: Replace CtrlP with fzf
"Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-eunuch'
Bundle 'scrooloose/nerdtree'
Bundle 'w0rp/ale'
Bundle 'tpope/vim-fugitive'
Bundle 'kien/rainbow_parentheses.vim'

" Utility plugins
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-speeddating'

Bundle 'godlygeek/tabular'
Bundle 'vim-scripts/tComment'
Bundle 'jiangmiao/auto-pairs'
"Bundle 'easymotion/vim-easymotion'
Bundle 'shinokada/dragvisuals.vim'
Bundle 'vim-scripts/matchit.zip'

" Text objects
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
highlight VimwikiLink ctermbg=black ctermfg=2
highlight VimwikiBold ctermfg=magenta
highlight VimwikiItalic ctermfg=yellow
highlight VimwikiBoldItalic ctermfg=darkyellow
highlight VimwikiHeader1 ctermfg=magenta
highlight VimwikiHeader2 ctermfg=blue
highlight VimwikiHeader3 ctermfg=green
let wiki = {}
let wiki.path = '~/wiki'
let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'java': 'java', 'haskell': 'haskell', 'js': 'javascript'}
let g:vimwiki_list = [wiki]
let g:vimwiki_listsyms = ' .○●✓'
let g:vimwiki_listsym_rejected = '✗'
let g:vimwiki_dir_link = 'index'

let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1
let g:ale_set_signs = 1
let g:ale_linters = {
            \ 'python': ['pylint', 'flake8'],
            \ 'java': ['javac', 'checkstyle']
            \ }
let g:ale_java_checkstyle_options = '-c C:/tools/checkstyle/cs1331-checkstyle.xml'
let g:ale_python_pylint_options = '--disable=C0103,C0111,W0621,R0902'

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

" Old Settings {{{
" Old EasyMotion settings
"map <Leader><Leader> <Plug>(easymotion-prefix)
"nmap <Leader>s <Plug>(easymotion-s2)
"map <Leader>l <Plug>(easymotion-bd-jk)
"nmap <Leader>l <Plug>(easymotion-overwin-line)
"let g:EasyMotion_use_upper = 0
"let g:EasyMotion_smartcase = 1


" Old Syntastic settings
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_python_checkers = ['pylint', 'pyflakes', 'flake8']
"let g:syntastic_java_checkers = ['checkstyle']
"let g:syntastic_java_checkstyle_classpath = 'C:/tools/checkstyle/checkstyle-8.12-all.jar'
"let g:syntastic_java_checkstyle_conf_file = 'C:/tools/checkstyle/cs1331-checkstyle.xml'


" Old CtrlP settings
"let g:ctrlp_show_hidden = 1
"let g:ctrlp_open_multiple_files = 't'


" Old cool mappings
" - Swap word with the next full word, even across punctuation or newlines.
"nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>
" - Push words 'right' or 'left', keeping cursor position constant
"nnoremap <silent> <C-Right> "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>/\w\+\_W\+<CR><C-l>:nohlsearch<CR>
"nnoremap <silent> <C-Left> "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o><C-l>:nohlsearch<CR>
" - Insertion of single characters before or after cursor
"nnoremap <silent> <Space> :exec "normal i".nr2char(getchar())."\e"<CR>
"nnoremap <silent> <S-Space> :exec "normal a".nr2char(getchar())."\e"<CR>


"set diffexpr=MyDiff()
"function! MyDiff()
"    let opt = '-a --binary '
"    if &diffopt =~ 'icase'  | let opt = opt . '-i ' | endif
"    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
"    let arg1 = v:fname_in
"    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
"    let arg2 = v:fname_new
"    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
"    let arg3 = v:fname_out
"    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
"    if $VIMRUNTIME =~ ' '
"        if &sh =~ '\<cmd'
"            if empty(&shellxquote)
"                let l:shxq_sav = ''
"                set shellxquote&
"            endif
"            let cmd = '"' . $VIMRUNTIME . '\diff"'
"        else
"            let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
"        endif
"    else
"        let cmd = $VIMRUNTIME . '\diff'
"    endif
"    silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
"    if exists('l:shxq_sav')
"        let &shellxquote=l:shxq_sav
"    endif
"endfunction

" }}}

" vim:foldmethod=marker:foldlevel=0
