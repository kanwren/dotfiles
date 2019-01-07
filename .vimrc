set nocompatible

" Functions {{{
function! ClearRegisters()
    let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-*+"'
    let i = 0
    while (i < strlen(regs))
        execute 'let @' . regs[i] . '=""'
        let i += 1
    endwhile
endfunction

function! EraseMarks()
    delmarks!
    delmarks A-Z0-9
endfunction

function! SetIndents()
    let i = input('ts=sts=sw=', '')
    if i
        execute 'setlocal tabstop=' . i . ' softtabstop=' . i . ' shiftwidth=' . i
    endif
    echo 'ts=' . &tabstop . ', sts=' . &softtabstop . ', sw=' . &shiftwidth . ', et=' . &expandtab
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
" }}}

" Autocommands {{{
if has('autocmd')
    autocmd FileType help wincmd L
    augroup plugin_group
        autocmd!
        if exists(':RainbowParenthesesToggle')
            autocmd VimEnter * RainbowParenthesesToggle
            autocmd Syntax * RainbowParenthesesLoadRound
        endif
        autocmd StdinReadPre * let s:std_in=1
    augroup END
    augroup haskell_group
        autocmd!
        autocmd FileType haskell setlocal shiftwidth=2 tabstop=2 softtabstop=2
    augroup END
    augroup java_group
        autocmd!
        autocmd FileType java setlocal foldmethod=syntax
        autocmd FileType java set makeprg=javac\ %
        autocmd FileType java set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
        autocmd FileType java nmap <F9> :make \| copen<CR><C-w>w
        autocmd FileType java nmap <F10> :execute '!java <C-r>=expand('%:r')<CR>'<CR>
    augroup END
    augroup python_group
        autocmd!
        autocmd FileType python setlocal nosmartindent
        autocmd FileType python setlocal foldmethod=indent
    augroup END
    augroup javascript_group
        autocmd!
        autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
    augroup END
    augroup wiki_group
        autocmd!
        autocmd FileType vimwiki setlocal formatoptions+=t
    augroup END
    augroup pug_group
        autocmd!
        autocmd FileType pug setlocal shiftwidth=2 tabstop=2 softtabstop=2
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
set clipboard=unnamed                " copy unnamed register to clipboard

set shortmess=I                      " Disable Vim intro screen

set autoread
set noconfirm                        " fail, don't ask to save
set hidden                           " allow working with buffers

set history=1000
set undolevels=1000

set tags=tags;/

set lazyredraw

set noerrorbells
set visualbell t_vb=

set mouse-=a

set number relativenumber
set nocursorline
set laststatus=2                     " for when Airline isn't available
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
set noignorecase
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
set tabstop=4                        " treat tabs as 4 spaces wide
set cinoptions+=:0L0g0               " indent distance for case, jumps, scope declarations
set expandtab softtabstop=4          " expand tabs to 4 spaces
set shiftwidth=4                     " use 4 spaces when using > or <
set smarttab
set noshiftround

set ttyfast
set timeout timeoutlen=500

set nojoinspaces                     " never two spaces after sentence
set virtualedit=all                  " TODO: block,insert?
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

" Bugfix mappings {{{
" Prevent screen drawing errors when navigating
nmap <C-f> <C-f><C-l>
nmap <C-b> <C-b><C-l>
nmap <C-d> <C-d><C-l>
nmap <C-u> <C-u><C-l>
nmap zz zz<C-l>
nmap zt zt<C-l>
nmap zb zb<C-l>
nmap gg gg<C-l>
nmap G  G<C-l>
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
" Exchange operation-delete, highlight target, exchange (made obsolete by exchange.vim)
vnoremap gx <Esc>`.``gvP``P
" Highlight text that was just inserted
nnoremap gV `[v`]
" Display registers
noremap <silent> "" :registers<CR>
" }}}

" Leader mappings {{{
map <Space> <nop>
map <S-Space> <Space>
let mapleader=" "

" Run selection in Python and output result back into buffer for automatic text generation
" TODO: fix Perl errors
nnoremap <Leader><Leader>p :.!python<CR>
vnoremap <Leader><Leader>p :!python<CR>
" Run selection in vimscript
nnoremap <Leader><Leader>v 0"xy$:@x<CR>
vnoremap <Leader><Leader>v "xy:@x<CR>
" Global scratch buffer
noremap <Leader><Leader>es :edit ~/scratch<CR>
" .vimrc editing/sourcing
noremap <Leader><Leader>ev :edit ~/dotfiles/.vimrc<CR>
noremap <Leader><Leader>sv :source $MYVIMRC<CR>
" Change working directory to directory of current file
noremap <expr> <Leader><Leader>cd ':cd ' . expand('%:p:h:r') . '<CR>'
" Modify indent level on the fly
noremap <expr> <Leader><Leader>i SetIndents()
" Search word underneath cursor but don't jump
noremap <Leader>* mx*`x
" Split current line by provided regex
nnoremap <silent> <expr> <Leader>sp ':s/' . input('sp/') . '/\r/g<CR>'
" Copy contents from one register to another
noremap <silent> <Leader>r :call CopyRegister()<CR>
" Expand line by padding visual block selection with spaces
vnoremap <Leader>e <Esc>:call ExpandSpaces()<CR>
" Add newline above or below without moving cursor, unlike uninpaired's [/]<Space>
" TODO: Add commands to pad selection with newlines, just like ExpandSpaces()
nnoremap <silent> <Leader>o :<C-u>call append(line("."), repeat([''], v:count1))<CR>
nnoremap <silent> <Leader>O :<C-u>call append(line(".") - 1, repeat([''], v:count1))<CR>
" Add newlines around current line or selection
nnoremap <silent> <Leader>n :<C-u>call append(line('.'), repeat([''], v:count1)) \| call append(line('.') - 1, repeat([''], v:count1))<CR>
vnoremap <silent> <Leader>n <Esc>:call append(line("'>"), '') \| call append(line("'<") - 1, '')<CR>
" Add semicolon at end of line(s) without moving cursor
nnoremap <Leader>; mxA;<Esc>`x
vnoremap <Leader>; :s/$/;/g<CR>
" Retab and delete trailing whitespace
noremap <Leader><Tab> mx:%s/\s\+$//ge \| retab<CR>`x
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
" Prompt for regular expression on which to tabularize
noremap <silent> <expr> <Leader>a ':Tabularize /' . input('tab/') . '<CR>'
" Vimwiki
nmap glo :VimwikiChangeSymbolTo *<CR>
nmap gLo :VimwikiChangeSymbolInListTo *<CR>
map <Leader>wa :VimwikiAll2HTML<CR>
" Add header row to tables
nnoremap <Leader>ewh yyp:s/[^\|]/-/g \| nohlsearch<CR>
"}}}
"}}}

" Abbreviations {{{
" Abbreviations for inserting common sequences
iabbrev xalpha <C-r>='abcdefghijklmnopqrstuvwxyz'<CR>
iabbrev xAlpha <C-r>='ABCDEFGHIJKLMNOPQRSTUVWXYZ'<CR>
iabbrev xdigits <C-r>='0123456789'<CR>

" Abbreviations for getting the path and filepath
abbreviate <expr> xpath expand('%:p:h')
abbreviate <expr> xfpath expand('%:p')

iabbrev <expr> xdmy strftime("%d/%m/%y")
iabbrev <expr> xmdy strftime("%m/%d/%y")
iabbrev <expr> xymd strftime("%Y-%m-%d")

" 15 Sep 2018
iabbrev <expr> xdate strftime("%d %b %Y")
" September 15, 2018
iabbrev <expr> xldate strftime("%B %d, %Y")
" Sat 15 Sep 2018
iabbrev <expr> xwdate strftime("%a %d %b %Y")
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
iabbrev xlecture %date <C-r>=strftime("%Y-%m-%d")<CR><CR>_<C-r>=strftime("%a %d %b %Y")<CR>_<CR><CR><C-r>=expand('%:t:r')<CR><Esc><C-x>V<CR>0f]i\|< prev<Esc>oindex<Esc>V<CR>o<C-r>=expand('%:t:r')<CR><Esc><C-a>V<CR>0f]i\|next ><Esc>o<CR>
" }}}

" Vundle plugins {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle/')

" Plugins to try out:
" itchyny/lightline
" romainl/vim-cool
" svermeulen/vim-subversive
" inkarkat/vim-UnconditionalPaste
" inkarkat/vim-LineJuggler
" airblade/vim-gitgutter
" majutsushi/tagbar
" kana/vim-niceblock

Plugin 'gmarik/Vundle.vim'                 " Plugin installer

Plugin 'vimwiki/vimwiki'                   " Personal wiki for Vim

" Interface
Plugin 'vim-airline/vim-airline'           " Better status bar and tabline for Vim
Plugin 'vim-airline/vim-airline-themes'    " Supports airline
Plugin 'powerline/fonts'                   " Supports airline

" Fuzzy Finder
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Functionality
Plugin 'w0rp/ale'                          " Async linting tool
Plugin 'sheerun/vim-polyglot'              " Collection of language packs to rule them all (testing)
Plugin 'scrooloose/nerdtree'               " File explorer/interface
Plugin 'tpope/vim-eunuch'                  " File operations
Plugin 'tpope/vim-fugitive'                " Git integration
Plugin 'kien/rainbow_parentheses.vim'      " Highlight matching punctuation pairs in color

" Utility plugins
Plugin 'tpope/vim-surround'                " Mappings for inserting/changing/deleting surrounding characters/elements
Plugin 'tpope/vim-repeat'                  " Repeating more actions with .
Plugin 'tpope/vim-unimpaired'              " Quickfix/location list/buffer navigation, paired editor commands, etc.
Plugin 'tpope/vim-abolish'                 " Subvert and coercion
Plugin 'tpope/vim-speeddating'             " Fix negative problem when incrementing dates
Plugin 'tommcdo/vim-exchange'              " Text exchanging operators (testing)
Plugin 'godlygeek/tabular'                 " Tabularize
Plugin 'vim-scripts/tComment'              " Easy commenting
Plugin 'jiangmiao/auto-pairs'              " Automatically insert matching punctuation pair, etc.
Plugin 'shinokada/dragvisuals.vim'         " Add ability to drag visual blocks
Plugin 'vim-scripts/matchit.zip'

" Run the following command in the installed directory of vimproc.vim (Windows):
" mingw32-make -f make_mingw64.mak
Plugin 'Shougo/vimproc.vim'

" Text objects
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-function'

" Snippets
Plugin 'tomtom/tlib_vim'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" Language-specific
"Plugin 'eagletmt/ghcmod-vim'              " Waiting on newer base support
Plugin 'bps/vim-textobj-python'
call vundle#end()
" }}}

" Plugin settings {{{

" Vimwiki
if exists('g:vimwiki_list')
    highlight VimwikiLink ctermbg=black ctermfg=2
    highlight VimwikiBold ctermfg=cyan
    highlight VimwikiItalic ctermfg=yellow
    highlight VimwikiBoldItalic ctermfg=darkyellow
    highlight VimwikiHeader1 ctermfg=magenta
    highlight VimwikiHeader2 ctermfg=blue
    highlight VimwikiHeader3 ctermfg=green
    let wiki = {}
    let wiki.path = '~/Dropbox/wiki'
    let wiki.path_html = '~/wiki_html'
    let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'java': 'java', 'haskell': 'haskell', 'js': 'javascript'}
    let g:vimwiki_list = [wiki]
    let g:vimwiki_listsyms = ' .○●✓'
    let g:vimwiki_listsym_rejected = '✗'
    let g:vimwiki_dir_link = 'index'
endif

" ALE
if exists(':ALELint')
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
endif

" DragVisuals
if exists('g:DVB_TrimWS')
    let g:DVB_TrimWS = 1
endif

" Airline
" TODO: exists condition
if 1
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
    let g:airline#extensions#tabline#enabled = 1
endif

" RainbowParentheses
if exists(':RainbowParenthesesToggle')
    let g:rbpt_max = 15
    let g:rbpt_loadcmd_toggle = 0
    let g:rbpt_colorpairs = [
                \ ['blue',      'RoyalBlue3'],
                \ ['green',     'SeaGreen3'],
                \ ['red',       'firebrick3'],
                \ ]
endif
" }}}

" Old Settings {{{
" Old EasyMotion settings
"map <Leader><Leader> <Plug>(easymotion-prefix)
"nmap <Leader>s <Plug>(easymotion-s2)
"map <Leader>l <Plug>(easymotion-bd-jk)
"nmap <Leader>l <Plug>(easymotion-overwin-line)
"let g:EasyMotion_use_upper = 0
"let g:EasyMotion_smartcase = 1


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
