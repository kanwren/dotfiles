set nocompatible

" Functions And Commands {{{
" Force write trick
command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Utility {{{
function! ClearRegisters()
    let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-*+"'
    let i = 0
    while i < strlen(regs)
        execute 'let @' . regs[i] . '=""'
        let i += 1
    endwhile
endfunction

function! EraseMarks()
    delmarks!
    delmarks A-Z0-9
endfunction

function! SetIndents(...)
    if a:0 > 0
        execute 'setlocal tabstop=' . a:1
                    \ . ' softtabstop=' . a:1
                    \ . ' shiftwidth=' . a:1
    else
        let i = input('ts=sts=sw=')
        if i
            call SetIndents(i)
        endif
        echo 'ts=' . &tabstop
                    \ . ', sts=' . &softtabstop
                    \ . ', sw='  . &shiftwidth
                    \ . ', et='  . &expandtab
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

" nix-prefetch-git shortcut
command! -nargs=+ NPG call Nix_Prefetch_Git(<f-args>)
function! Nix_Prefetch_Git(owner, repo, ...)
    " Other fields: url, date, fetchSubmodules
    let fields=['rev', 'sha256']
    let command='nix-prefetch-git git@github.com:' . a:owner . '/' . a:repo
    if a:0 > 0
        let command.=' --rev ' . a:1
    end
    let command.=' --quiet | grep -E "' . join(fields, '|') . '" | sed -E "s/\s*\"(.+)\": \"(.+)\",/\1 = \"\2\";/g"'
    execute('read! ' . command)
endfunction
" }}}

" Hex editing {{{
command! -bar Hexmode call ToggleHex()
function! ToggleHex()
    " hex mode should be considered a read-only operation
    " save values for modified and read-only for restoration later,
    " and clear the read-only flag for now
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    let l:oldmodifiable=&modifiable
    let &modifiable=1
    if !exists("b:editHex") || !b:editHex
        " save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " set new options
        setlocal binary " make sure it overrides any textwidth, etc.
        silent :e " this will reload the file without trickeries
        "(DOS line endings will be shown entirely )
        let &ft="xxd"
        " set status
        let b:editHex=1
        " switch to hex editor
        %!xxd
    else
        " restore old options
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        " set status
        let b:editHex=0
        " return to normal editing
        %!xxd -r
    endif
    " restore values for modified and read only state
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
" }}}

" Testing {{{
function! ColorList()
    let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
    return map(paths, 'fnamemodify(v:val, ":t:r")')
endfunction

let g:colors = ColorList()
let g:cur_color = -1
function! NextColor()
    let g:cur_color += 1
    let g:cur_color = g:cur_color % len(g:colors)
    execute ':colorscheme ' . g:colors[g:cur_color]
    set background=dark
    redraw
    echo 'Switched to: ' . g:colors[g:cur_color] . ' (' . (g:cur_color + 1) . ')'
endfunction
" }}}
" }}}

" Autocommands {{{
if has('autocmd')
    " autocmd FileType help wincmd L
    augroup plugin_group
        autocmd!
        autocmd StdinReadPre * let s:std_in=1
    augroup END
    augroup general_group
        " Return to last edit position when opening files
        autocmd BufReadPost *
                    \   if line("'\"") > 1 && line("'\"") <= line("$")
                    \ |     exe "normal! g'\""
                    \ | endif
    augroup END
    au BufNewFile,BufRead *.nix setf nix
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

if !has('gui_running')
    set term=xterm-256color
    set t_Co=256
    let &t_ti.="\e[1 q"
    let &t_SI.="\e[5 q"
    let &t_EI.="\e[1 q"
    let &t_te.="\e[0 q"
    set background=dark
    colorscheme elflord
else
    set background=dark
    colorscheme elflord
endif

set encoding=utf-8
scriptencoding utf-8
set ffs=unix,dos,mac
let $LANG='en'
set nospell spelllang=en_us
"set clipboard=unnamed
"set clipboard=unnamedplus            " + register point to system clipboard

set shortmess+=I                     " Disable Vim intro screen

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
set statusline=buf\ %n:\ \"%F\"%<\ \ \ %m%y%h%w%r\ \ %(%b\ 0x%B%)%=%(col\ %c%)\ \ \ \ %(%l\ /\ %L%)\ \ \ \ %p%%%(\ %)
set showtabline=2
set wildmenu                         " better command-line completion
set wildmode=longest:list,full       " TODO: decide between this and longest:full,full
set cmdheight=1
set showcmd                          " show partial commands on bottom
set showmode
set nowrap

set magic
set showmatch                        " matching brace/parens/etc.
set incsearch hlsearch
set ignorecase smartcase

set scrolloff=0

set list listchars=tab:>-,eol:¬,extends:>,precedes:<
set modelines=1
set textwidth=80
set nrformats=bin,hex                " Don't increment octal numbers
set formatoptions=croqjln
" c=wrap comments
" r=insert comment on enter
" o=insert comment on o/O
" q=allow formatting of comments with gq
" j=remove comment marker when joining lines
" l=don't break lines longer than textwidth before insert started
" n=recognize numbered lists

set autoindent smartindent
set tabstop=4                        " treat tabs as 4 spaces wide
set expandtab softtabstop=4          " expand tabs to 4 spaces
set shiftwidth=4                     " use 4 spaces when using > or <
set smarttab
set noshiftround
set cinoptions+=:0L0g0j1J1           " indent distance for case, jumps, scope declarations

set ttyfast
set timeout timeoutlen=500
set ttimeoutlen=0

set nojoinspaces                     " never two spaces after sentence
set virtualedit=all                  " Allow editing past the ends of lines
set splitbelow splitright            " directions for vs/sp
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]           " direction key wrapping

set foldmethod=manual
set foldcolumn=1
set foldlevelstart=99
" }}}

" Highlighting {{{
" Highlight column for folding
highlight FoldColumn ctermbg=0
highlight Folded ctermbg=0

highlight ColorColumn ctermbg=8
set colorcolumn=81
"call matchadd('ColorColumn', '\%81v\S', 100)

highlight ExtraWhitespace ctermbg=12
match ExtraWhitespace /\s\+$/

highlight CursorLineNr ctermbg=4 ctermfg=15
highlight Todo ctermbg=1 ctermfg=15
"}}}

" Mappings {{{
noremap <C-l> :nohlsearch<CR><C-l>

" Convenience mappings {{{
" Work by visual line without a count, but normal when used with one
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
" Provide easier alternative to escape-hit them at the same time
"inoremap jk <Esc>
" Makes temporary macros faster
nnoremap Q @q
" Repeat macros/commands across visual selections
vnoremap Q :norm @q<CR>
vnoremap . :norm .<CR>
" Make Y more analogous with C and D
noremap Y y$
" Exchange operation-delete, highlight target, exchange (made obsolete by exchange.vim)
"vnoremap gx <Esc>`.``gvP``P
" Display registers
noremap <silent> "" :registers<CR>

nnoremap <Right> :bnext<CR>
nnoremap <Left> :bprev<CR>
" }}}

" Leader mappings {{{
map <Space> <nop>
map <S-Space> <Space>
let mapleader=" "

" More convenient delete/put
noremap <Leader>d "_d
noremap <Leader>D "_D
noremap <Leader>p "0p
noremap <Leader>P "0P

" Fast buffer navigation/editing
noremap <Leader>b :ls<CR>:b
" Search word underneath cursor/selection but don't jump
noremap <Leader>* mx*`x
" Retab and delete trailing whitespace
noremap <Leader><Tab> mx:%s/\s\+$//ge \| retab<CR>`x
" Split current line by provided regex (\zs or \ze to preserve separators)
nnoremap <silent> <expr> <Leader>s ':s/' . input('split/') . '/\r/g<CR>'
" Toggle keyboard mappings
nnoremap <expr> <Leader><Leader>k ':set keymap=' . (&keymap ==? 'dvorak' ? '' : 'dvorak') . '<CR>'
" Copy contents from one register to another (like MOV, but with arguments reversed)
noremap <silent> <Leader>r :call CopyRegister()<CR>
" Expand line by padding visual block selection with spaces
vnoremap <Leader>e <Esc>:call ExpandSpaces()<CR>

" Global scratch buffer
noremap <Leader><Leader>es :edit ~/scratch<CR>
" .vimrc editing/sourcing
noremap <Leader><Leader>ev :edit ~/dotfiles/.vimrc<CR>
noremap <Leader><Leader>sv :source $MYVIMRC<CR>
" Change working directory to directory of current file
noremap <expr> <Leader><Leader>cd ':cd ' . expand('%:p:h:r') . '<CR>'
" Change indent level on the fly
noremap <expr> <Leader><Leader>i SetIndents()

" Add newline above or below without moving cursor, unlike uninpaired's [/]<Space>
" TODO: Add commands to pad selection with newlines, just like ExpandSpaces()
nnoremap <silent> <Leader>o :<C-u>call append(line("."), repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>j<CR>
nnoremap <silent> <Leader>O :<C-u>call append(line(".") - 1, repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>k<CR>
" Add newlines around current line or selection
nnoremap <silent> <Leader>n :<C-u>call append(line('.'), repeat([''], v:count1)) \| call append(line('.') - 1, repeat([''], v:count1))<CR>
vnoremap <silent> <Leader>n <Esc>:call append(line("'>"), '') \| call append(line("'<") - 1, '')<CR>
" Add semicolon at end of line(s) without moving cursor
nnoremap <Leader>; mxg_a;<Esc>`x
vnoremap <Leader>; :s/\v(\s*$)(;)@<!/;/g<CR>

" Run selection in Python and output result back into buffer for automatic text generation
nnoremap <Leader><Leader>p :.!python<CR>
vnoremap <Leader><Leader>p :!python<CR>
" Run selection in vimscript
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
"vnoremap <Leader>be :call StrToBinCodes()<CR>
"vnoremap <Leader>bd :call BincodesToStr()<CR>
"nnoremap <Leader>bs "xyiw:echo 0b<C-r>"<CR>
"vnoremap <Leader>bs "xy:echo 0b<C-r>"<CR>
"nnoremap <Leader>bt "xyiw:echo printf('%b', <C-r>")<CR>
"vnoremap <Leader>bt "xy:echo printf('%b', <C-r>")<CR>
" }}}

" Plugin mappings {{{
" NERDTree
map <F2> :NERDTreeToggle<CR>
" Tabular
" Prompt for regular expression on which to tabularize
nnoremap <silent> <expr> <Leader>a ":let p = input('tab/') \| execute ':Tabularize' . (empty(p) ? '' : ' /' . p)<CR>"
vnoremap <silent> <Leader>a <Esc>:let p = input('tab/') \| execute ":'<,'>Tabularize" . (empty(p) ? '' : ' /' . p)<CR>
" Vimwiki
" Quick notes
noremap <Leader>wq :e ~/wiki/quick/index.wiki<CR>
"}}}
"}}}

" Abbreviations {{{
" Abbreviations for inserting common sequences
abbreviate xaz <C-r>='abcdefghijklmnopqrstuvwxyz'<CR>
abbreviate xAZ <C-r>='ABCDEFGHIJKLMNOPQRSTUVWXYZ'<CR>
abbreviate x09 <C-r>='0123456789'<CR>

iabbrev xcode {{{<CR>}}}<Esc>O
iabbrev xmath {{$%align%<CR>}}$<Esc>O

iabbrev <expr> xymd strftime("%Y-%m-%d")

" Sat 15 Sep 2018
iabbrev <expr> xdate strftime("%a %d %b %Y")
" 11:31 PM
iabbrev <expr> xtime strftime("%I:%M %p")
" 23:31
iabbrev <expr> xmtime strftime("%H:%M")
" 2018-09-15T23:31:54
iabbrev <expr> xiso strftime("%Y-%m-%dT%H:%M:%S")

" This is so sad, Vim play Despacito
iabbrev Despacito <Esc>:!xdg-open https://youtu.be/kJQP7kiw5Fk?t=83<CR>
" }}}

" Vundle plugins {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle/')

" Plugins to try out:
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
Plugin 'itchyny/lightline.vim'

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
Plugin 'tpope/vim-speeddating'             " Fix negative problem when incrementing dates
Plugin 'tommcdo/vim-exchange'              " Text exchanging operators
Plugin 'godlygeek/tabular'                 " Tabularize
Plugin 'vim-scripts/tComment'              " Easy commenting
Plugin 'jiangmiao/auto-pairs'              " Automatically insert matching punctuation pair, etc.
Plugin 'vim-scripts/matchit.zip'

" Text objects
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-function'

" Language-specific
Plugin 'neovimhaskell/haskell-vim'

call vundle#end()
" }}}

" Plugin settings {{{
" Vimwiki
highlight VimwikiLink ctermbg=black ctermfg=2
highlight VimwikiHeader1 ctermfg=magenta
highlight VimwikiHeader2 ctermfg=blue
highlight VimwikiHeader3 ctermfg=green
let wiki = {}
let wiki.path = '~/wiki/'
let wiki.path_html = '~/wiki-gl/'
let wiki.template_path = wiki.path . 'templates/'
let wiki.template_ext = '.tpl'
let wiki.nested_syntaxes = {
            \ 'haskell':     'haskell',
            \ 'hs':          'haskell',
            \ 'c':           'c',
            \ 'c++':         'cpp',
            \ 'cpp':         'cpp',
            \ 'java':        'java',
            \ 'javascript':  'javascript',
            \ 'js':          'javascript',
            \ 'python':      'python',
            \ 'py':          'python',
            \ 'scala':       'scala',
            \ }
let g:vimwiki_list = [wiki]
let g:vimwiki_listsyms = ' .○●✓'
let g:vimwiki_listsym_rejected = '✗'
let g:vimwiki_dir_link = 'index'

function! LightlineKeymapName()
    return &keymap
endfunction

function! LightlineBufferline()
  call bufferline#refresh_status()
  return [ g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after]
endfunction

let g:lightline = {
            \ 'colorscheme': 'powerline',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'readonly', 'buffilename', 'modified', 'keymapname', 'charvalue' ] ]
            \ },
            \ 'enable': {
            \   'statusline': 1,
            \ },
            \ 'component': {
            \   'buffilename': '[%n] %f',
            \   'charvalue': '0x%B %b',
            \   'lineinfo': "%l/%L | %c%V",
            \ },
            \ 'component_function': {
            \   'keymapname': 'LightlineKeymapName',
            \ },
            \ }

" ALE
let g:ale_enabled = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1
let g:ale_set_signs = 1
let g:ale_linters = {
            \ 'python': ['pylint'],
            \ 'java': ['javac', 'checkstyle']
            \ }
let g:ale_java_checkstyle_options = '-c /c/tools/checkstyle/cs1331-checkstyle.xml'
"let g:ale_java_javac_classpath = '.;~/bin/jh61b.jar;~/cs1331/assignments/autograder_components/lib/*;~/bin/javafx-sdk-11.0.2/lib/*'
let g:ale_python_pylint_options = '--disable=C0103,C0111,C0301,C0305,W0621,R0902,R0903'

" Haskell-vim
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

" vim:foldmethod=marker:foldlevel=0
