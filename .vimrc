" Settings {{{
" Basic
    set encoding=utf-8
    scriptencoding utf-8
    set ffs=unix
    " Enable filetype detection
    filetype plugin indent on
    " Prevent highlighting from changing when resourcing vimrc
    if !syntax_on
        syntax on
    end

" Backups
    set swapfile directory^=~/.vim/tmp//
    set backup writebackup backupcopy=auto
    " This patch fixes a bug to make Vim respect // for backupdir
    if has("patch-8.1.0251")
        set backupdir^=~/.vim/backup//
    else
        set backupdir^=~/.vim/backup
    endif
    if has('persistent_undo')
        set undofile undodir^=~/.vim/undo//
    endif

" Diff algorithm
    if has("patch-8.1.0360")
        set diffopt+=internal,algorithm:patience
    endif

" Spelling and thesaurus
    let $LANG='en'
    set nospell spelllang=en_us
    set thesaurus=~/.vim/thesaurus/mthesaur.txt

" Colors and terminal settings
    if &term =~ ".*-256color"
        let &t_ti.="\e[1 q"
        let &t_SI.="\e[5 q"
        let &t_EI.="\e[1 q"
        let &t_te.="\e[0 q"
    endif
    set background=dark

" Buffers
    set hidden                           " allow working with buffers
    set autoread
    set noconfirm                        " fail, don't ask to save
    set modeline modelines=1             " use one line to tell vim how to read the buffer

" History
    set history=1000
    set undolevels=1000

" Disable annoying flashing/beeping
    set noerrorbells
    set visualbell t_vb=

" Navigation
    set mouse=a
    set scrolloff=0
    set tags=tags;/

" Display
    set lazyredraw                       " don't redraw until after command/macro
    set shortmess+=I                     " disable Vim intro screen
    set splitbelow splitright            " sensible split defaults
    set number relativenumber            " use Vim properly
    set list listchars=tab:>-,eol:¬,extends:>,precedes:<
    set nocursorline nocursorcolumn
    " statusline
    set laststatus=2
    set statusline=[%n]\ %f%<\ %m%y%h%w%r\ \ %(0x%B\ %b%)%=%p%%\ \ %(%l/%L%)%(\ \|\ %c%V%)%(\ %)
    set showmode
    " command bar
    set cmdheight=1
    set showcmd
    " completion menu
    set wildmenu
    set wildmode=longest:list,full

" Editing
    set noinsertmode                     " just in case
    set clipboard=unnamedplus
    set virtualedit=all                  " allow editing past the ends of lines
    set nojoinspaces                     " never two spaces after sentence
    set backspace=indent,eol,start       " let backspace delete linebreak
    set whichwrap+=<,>,h,l,[,]           " direction key wrapping
    set nrformats=bin,hex                " don't increment octal numbers
    set cpoptions+=y                     " let yank be repeated with . (primarily for repeating appending)

" Indentation
    set autoindent
    set tabstop=4                        " treat tabs as 4 spaces wide
    set expandtab softtabstop=4          " expand tabs to 4 spaces
    set shiftwidth=4                     " use 4 spaces when using > or <
    set smarttab
    set noshiftround
    set cinoptions+=:0L0g0j1J1           " indent distance for case, jumps, scope declarations

" Formatting
    set nowrap
    set textwidth=80
    set colorcolumn=+1
    set formatoptions=croqjln

" Searching
    set magic
    set noignorecase smartcase
    set showmatch
    set incsearch
    if &t_Co > 2 || has("gui_running")
        set hlsearch
    endif

" Folds
    set foldenable
    set foldmethod=manual
    set foldcolumn=1
    set foldlevelstart=99

" Timeouts
    "set ttyfast
    " Time out on mappings after 3 seconds
    set timeout timeoutlen=3000
    " Time out immediately on key codes
    set ttimeout ttimeoutlen=0
" }}}

" Autocommands/highlighting {{{
    if has('autocmd')
        augroup general_group
            autocmd!
            " Open help window on right by default
            autocmd FileType help wincmd L
            " Return to last edit position when opening files
            autocmd BufReadPost *
                        \   if line("'\"") > 1 && line("'\"") <= line("$")
                        \ |     execute "normal! g`\""
                        \ | endif
            " Highlight trailing whitespace (except when typing at end of line)
            autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
            autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
            autocmd InsertLeave * match ExtraWhitespace /\s\+$/
        augroup END
        augroup detect_group
            " Define new filetypes for ftplugin
            autocmd BufNewFile,BufRead *.cls setf tex
        augroup END
        " Highlighting
        augroup highlight_group
            autocmd!
            " Highlight trailing whitespace
            autocmd ColorScheme * highlight ExtraWhitespace ctermbg=12
            " Left column
            autocmd ColorScheme *
                        \   highlight FoldColumn ctermbg=NONE
                        \ | highlight Folded ctermbg=NONE
                        \ | highlight LineNr ctermbg=NONE ctermfg=4
                        \ | highlight CursorLineNr ctermbg=0 ctermfg=7
            " Highlight text width boundary boundary
            autocmd ColorScheme * highlight ColorColumn ctermbg=8
            " Highlight TODO in intentionally annoying colors
            autocmd ColorScheme * highlight Todo ctermbg=1 ctermfg=15
        augroup END
    endif
" }}}

" Functions/commands {{{
" Basic commands
    " Force sudo write trick
    command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!
    " cd to directory of current file
    command! CD :cd %:h
    " Reverse lines
    command! -bar -range=% Reverse <line1>,<line2>g/^/m<line1>-1 | nohlsearch
    " Show calendar and date/time
    command! Cal :!clear && cal -y; date -R
    " Fetch mthesaurus.txt from gutenberg with curl
    command! GetThesaurus :!curl --create-dirs http://www.gutenberg.org/files/3202/files/mthesaur.txt -o ~/.vim/thesaurus/mthesaur.txt

" JSON utilities (format, convert to and from YAML)
    if executable('python3')
        command! -range JT <line1>,<line2>!python3 -m json.tool
        command! -range J2Y <line1>,<line2>!python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'
        command! -range Y2J <line1>,<line2>!python3 -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout)'
    elseif executable('python')
        command! -range JT <line1>,<line2>!python -m json.tool
        command! -range J2Y <line1>,<line2>!python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'
        command! -range Y2J <line1>,<line2>!python -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout)'
    endif

" Session management
    function! GetSessions(arglead, cmdline, cursorpos) abort
        let paths = split(globpath('~/.vim', 'sessions/*.vim'), "\n")
        let names = map(paths, 'fnamemodify(v:val, ":t:r")')
        if empty(a:arglead)
            return names
        else
            return filter(names, {idx, val -> len(val) >= len(a:arglead) && val[:len(a:arglead) - 1] ==# a:arglead})
        endif
    endfunction
    " Save session
    command! -bang -nargs=? -complete=customlist,GetSessions Save :call MkSession("<bang>", <f-args>)
    function! MkSession(bang, ...) abort
        if a:0 > 0
            execute "mksession" . a:bang . " ~/.vim/sessions/" . a:1 . ".vim"
            echo "Saved session to ~/.vim/sessions/" . a:1 . ".vim"
        else
            execute "mksession! ~/.vim/sessions/temp.vim"
            echo "Saved session to ~/.vim/sessions/temp.vim"
        endif
    endfunction
    " Restore session
    command! -nargs=? -complete=customlist,GetSessions Restore :call SourceSession(<f-args>)
    function! SourceSession(...) abort
        execute "source ~/.vim/sessions/" . (a:0 > 0 ? a:1 : 'temp') . ".vim"
    endfunction

" Utility
    function! ClearRegisters() abort
        let regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-*+"'
        let i = 0
        while i < strlen(regs)
            execute 'let @' . regs[i] . '=""'
            let i += 1
        endwhile
    endfunction

    command! -range Rule call MakeRules(<line1>, <line2>)
    function! MakeRules(start, end) abort
        let n = a:start
        while n <= a:end
            let l = getline(n)
            let pad = (&tw - strlen(l)) / 2.0
            call setline(n, repeat('-', float2nr(floor(pad))) . l . repeat('-', float2nr(ceil(pad))))
            let n += 1
        endwhile
    endfunction

    " nix-prefetch-git shortcut
    command! -bar -nargs=+ NPG call Nix_Prefetch_Git(<f-args>)
    function! Nix_Prefetch_Git(owner, repo, ...) abort
        " Other fields: url, date, fetchSubmodules
        let fields = ['rev', 'sha256']
        let command = 'nix-prefetch-git git@github.com:' . a:owner . '/' . a:repo
        if a:0 > 0
            let command .= ' --rev ' . a:1
        end
        let command .= ' --quiet 2>/dev/null | grep -E "' . join(fields, '|')
        let command .= '" | sed -E "s/\s*\"(.+)\": \"(.+)\",/\1 = \"\2\";/g"'
        if $USER ==# 'root'
            " If root, try to run command as login user instead
            let logname = substitute(system('logname'), '\n', '', 'ge')
            execute('read! ' . 'runuser -l ' . logname . " -c '" . command . "'")
        else
            execute('read! ' . command)
        endif
    endfunction

    command! -bar Hexmode call ToggleHex()
    function! ToggleHex() abort
        " save values for modified and read-only, clear read-only flag for now
        let l:modified = &mod
        let l:oldreadonly = &readonly
        let &readonly = 0
        let l:oldmodifiable = &modifiable
        let &modifiable = 1
        if !exists("b:editHex") || !b:editHex
            " save old options
            let b:old_ft = &ft
            let b:old_bin = &bin
            " set new options
            setlocal binary " make sure it overrides any textwidth, etc.
            silent :edit " this will reload the file without trickeries
            " (DOS line endings will be shown entirely)
            let &ft = "xxd"
            let b:edit_hex = 1
            %!xxd
        else
            " restore old options
            let &ft = b:old_ft
            if !b:old_bin
                setlocal nobinary
            endif
            let b:edit_hex = 0
            %!xxd -r
        endif
        " restore old values for modified and read only state
        let &mod = l:modified
        let &readonly = l:oldreadonly
        let &modifiable = l:oldmodifiable
    endfunction

    function! StrToHexCodes() abort
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

    function! HexCodesToStr() abort
        normal gvy
        let codes = split(@", '\x\{2}\zs *')
        let str = ''
        for code in codes
            let str .= nr2char('0x' . code)
        endfor
        let @" = str
        normal gv"0P
    endfunction

" Testing
    function! ColorList() abort
        let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
        return map(paths, 'fnamemodify(v:val, ":t:r")')
    endfunction

    function! NextColor() abort
        if !exists('g:colors') || !exists('g:cur_color')
            let g:colors = ColorList()
            let g:cur_color = -1
        endif
        let g:cur_color += 1
        let g:cur_color = g:cur_color % len(g:colors)
        execute ':colorscheme ' . g:colors[g:cur_color]
        set background=dark
        redraw
        echo 'Switched to: ' . g:colors[g:cur_color] . ' (' . (g:cur_color + 1) . ')'
    endfunction
" }}}

" Mappings {{{

" Notes:
" * Space is the default leader, and Shift-Space has the same function to make
"   it easier to hit things like <Space>P
" * Single leader is for abbreviating common operations and important plugin
"   commands
" * Double leader is for execution of meta-editing operations, like inline execution
" * \ is for special operations, like invoking external programs or managing
"   sessions

" Leader configuration
    map <Space> <nop>
    map <S-Space> <Space>
    let mapleader=" "

" Essential
    " Work by visual line without a count, but normal when used with one
    noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
    noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
    " Makes temporary macros faster
    nnoremap Q @q
    " Repeat macros/commands across visual selections
    xnoremap <silent> Q :normal @q<CR>
    xnoremap <silent> . :normal .<CR>
    " Make Y behave like C and D
    noremap Y y$
    " Make & keep the last flags used
    nnoremap & :&&<CR>
    " Make temporary unlisted scratch buffer
    nnoremap <Leader>t :new<CR>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile<CR>
    " Search word underneath cursor/selection but don't jump
    nnoremap <silent> * :let wv=winsaveview()<CR>*:call winrestview(wv)<CR>
    " Redraw page and clear highlights
    noremap <silent> <C-l> :nohlsearch<CR><C-l>

" Editing
    " Split current line by provided regex (\zs or \ze to preserve separators)
    nnoremap gs :s//\r/g<Left><Left><Left><Left><Left>
    " Start a visual substitute
    vnoremap gs :s/\%V
    " Sort visual selection
    vnoremap <silent> <Leader>vs :sort /\ze\%V/<CR>gvyugvpgv:s/\s\+$//e \| nohlsearch<CR>``
    " Convenient semicolon insertion
    nnoremap <silent> <Leader>; :let wv=winsaveview()<CR>:s/[^;]*\zs\ze\s*$/;/e \| nohlsearch<CR>:call winrestview(wv)<CR>
    vnoremap <silent> <Leader>; :let wv=winsaveview()<CR>:s/\v(\s*$)(;)@<!/;/g \| nohlsearch<CR>:call winrestview(wv)<CR>
    " Interactive alignment
    vnoremap gz :LiveEasyAlign<CR>
    " Prompt for regex to align on
    vnoremap <Leader>a :EasyAlign //<Left>
    " Insert blank lines
    nnoremap <silent> <C-j> :<C-u>call append(line("."), repeat([''], v:count1))<CR>
    nnoremap <silent> <C-k> :<C-u>call append(line(".") - 1, repeat([''], v:count1))<CR>

" Sessions
    " Providing a count uses temp-<count>.vim, otherwise it just uses temp.vim
    nnoremap <expr> \s ':<C-u>Save! ' . (v:count > 0 ? 'temp-' . v:count : 'temp') . '<CR>'
    nnoremap <expr> \r ':<C-u>Restore ' . (v:count > 0 ? 'temp-' . v:count : 'temp') . '<CR>'

" Managing Whitespace
    " Delete trailing whitespace and retab
    nnoremap <silent> <Leader><Tab> :let wv=winsaveview()<CR>:%s/\s\+$//e \| call histdel("/", -1) \| nohlsearch \| retab<CR>:call winrestview(wv)<CR>
    " Add blank line below/above line/selection, keep cursor in same position (can take count)
    nnoremap <silent> <Leader>n :<C-u>call append(line("."), repeat([''], v:count1)) \| call append(line(".") - 1, repeat([''], v:count1))<CR>
    vnoremap <silent> <Leader>n :<C-u>call append(line("'<") - 1, repeat([''], v:count1)) \| call append(line("'>"), repeat([''], v:count1))<CR>
    " Expand line by padding visual block selection with spaces
    vnoremap <Leader>e <Esc>:execute 'normal gv' . (abs(getpos("'>")[2] + getpos("'>")[3] - getpos("'<")[2] - getpos("'<")[3]) + 1) . 'I '<CR>

" Registers
    " Display registers
    nnoremap <silent> "" :registers<CR>
    " Copy contents of register to another (provides ' as an alias for ")
    nnoremap <silent> <Leader>r :let r1 = substitute(nr2char(getchar()), "'", "\"", "") \| let r2 = substitute(nr2char(getchar()), "'", "\"", "")
                \ \| execute 'let @' . r2 . '=@' . r1 \| echo "Copied @" . r1 . " to @" . r2<CR>

" Matching navigation commands, like in unimpaired
    for [l, c] in [["b", "b"], ["t", "t"], ["q", "c"], ["l", "l"]]
        let u = toupper(l)
        execute "nnoremap ]" . l . " :" . c . "next<CR>"
        execute "nnoremap [" . l . " :" . c . "previous<CR>"
        execute "nnoremap ]" . u . " :" . c . "last<CR>"
        execute "nnoremap [" . u . " :" . c . "first<CR>"
    endfor

" Quick settings changes
    " .vimrc editing/sourcing
    nnoremap <Leader><Leader>ev :edit $MYVIMRC<CR>
    nnoremap <Leader><Leader>sv :source $MYVIMRC<CR>
    " Filetype ftplugin editing
    nnoremap <Leader><Leader>ef :edit ~/.vim/ftplugin/<C-r>=&filetype<CR>.vim<CR>
    " Change indent level on the fly
    function s:ChangeIndent() abort
        let i=input('ts=sts=sw=')
        if i
            execute 'setlocal tabstop=' . i . ' softtabstop=' . i . ' shiftwidth=' . i
        endif
        redraw
        echo 'ts=' . &tabstop . ', sts=' . &softtabstop . ', sw='  . &shiftwidth . ', et='  . &expandtab
    endfunction
    nnoremap <Leader>i :call <SID>ChangeIndent()<CR>

" Base conversion utilities (gb)
    vnoremap <Leader>he :call StrToHexCodes()<CR>
    vnoremap <Leader>hd :call HexCodesToStr()<CR>
    nnoremap <Plug>(DecToBin) ciw<C-r>=printf('%b', <C-r>")<CR><Esc>:silent! call repeat#set("\<Plug>(DecToBin)", v:count)<CR>
    nnoremap <Plug>(BinToDec) ciw<C-r>=0b<C-r>"<CR><Esc>:silent! call repeat#set("\<Plug>(BinToDec)", v:count)<CR>
    vnoremap <Plug>(DecToBin) c<C-r>=printf('%b', <C-r>")<CR><Esc>:silent! call repeat#set("\<Plug>(DecToBin)", v:count)<CR>
    vnoremap <Plug>(BinToDec) c<C-r>=0b<C-r>"<CR><Esc>:silent! call repeat#set("\<Plug>(BinToDec)", v:count)<CR>
    nnoremap <Plug>(DecToHex) ciw<C-r>=printf('%x', <C-r>")<CR><Esc>:silent! call repeat#set("\<Plug>(DecToHex)", v:count)<CR>
    nnoremap <Plug>(HexToDec) ciw<C-r>=0x<C-r>"<CR><Esc>:silent! call repeat#set("\<Plug>(HexToDec)", v:count)<CR>
    vnoremap <Plug>(DecToHex) c<C-r>=printf('%x', <C-r>")<CR><Esc>:silent! call repeat#set("\<Plug>(DecToHex)", v:count)<CR>
    vnoremap <Plug>(HexToDec) c<C-r>=0x<C-r>"<CR><Esc>:silent! call repeat#set("\<Plug>(HexToDec)", v:count)<CR>
    nmap <silent> gbdb <Plug>(DecToBin)
    nmap <silent> gbbd <Plug>(BinToDec)
    vmap <silent> gbdb <Plug>(DecToBin)
    vmap <silent> gbbd <Plug>(BinToDec)
    nmap <silent> gbdh <Plug>(DecToHex)
    nmap <silent> gbhd <Plug>(HexToDec)
    vmap <silent> gbdh <Plug>(DecToHex)
    vmap <silent> gbhd <Plug>(HexToDec)

" Inline execution
    " Run selection in python and replace with output for programmatic text generation
    nnoremap <Leader><Leader>p :.!python3<CR>
    vnoremap <Leader><Leader>p :!python3<CR>

" Netrw mappings (<Leader>l)
    " Open directory of current buffer in vertical split
    nnoremap <Leader>lv :Vex<CR>
    " Open directory of current working directory in vertical split
    nnoremap <Leader>ll :Lex<CR>
    nnoremap <Leader>le :Ex<CR>

" fzf mappings (<Leader>f)
    " All files
    nnoremap <Leader>ff :Files<CR>
    " All git ls-files files
    nnoremap <Leader>fg :GFiles<CR>
    " All lines in loaded buffers
    nnoremap <Leader>fl :Lines<CR>
    " All lines in current buffer
    nnoremap <Leader>fb :BLines<CR>
    " Results of a ripgrep search
    nnoremap <Leader>fr :Rg<Space>
    " Results of an ag search
    nnoremap <Leader>fa :Ag<Space>
    " Tags in project
    nnoremap <Leader>ft :Tags<CR>

" Fugitive mappings (<Leader>g)
    nnoremap <Leader>gs  :Gstatus<CR>
    nnoremap <Leader>gpl :Gpull<CR>
    nnoremap <Leader>gps :Gpush<CR>
    nnoremap <Leader>gw  :Gwrite<CR>
    nnoremap <Leader>gc  :Gcommit<CR>
    nnoremap <Leader>gd  :Gvdiff<CR>

" Quick notes
    " Global scratch buffer
    nnoremap <Leader><Leader>es :edit ~/scratch<CR>
"}}}

" Abbreviations {{{
" Common sequences
    iabbrev xaz <C-r>='abcdefghijklmnopqrstuvwxyz'<CR>
    iabbrev xAZ <C-r>='ABCDEFGHIJKLMNOPQRSTUVWXYZ'<CR>
    iabbrev x09 <C-r>='0123456789'<CR>

" Date/time abbreviations
    " 2018-09-15
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

" Plugins {{{
    " It's in the runtime *shrug*
    runtime macros/matchit.vim

    function! InstallVimPlug() abort
        if empty(glob('~/.vim/autoload/plug.vim'))
            let url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
            if executable('curl')
                call system('curl -fLo ~/.vim/autoload/plug.vim --create-dirs ' . url)
            elseif executable('wget')
                call system('mkdir -p ~/.vim/autoload && wget -O ~/.vim/autoload/plug.vim ' . url)
            else
                echoerr 'curl or wget are required to install vim-plug'
            endif
        else
            echo 'vim-plug is already installed'
        endif
    endfunction

    silent! if !empty(glob('~/.vim/autoload/plug.vim'))
                \ && !empty(glob('~/.vim/bundle'))
                \ && plug#begin(glob('~/.vim/bundle'))
        " Functionality
        Plug 'vimwiki/vimwiki'                   " Personal wiki for Vim
        Plug 'sheerun/vim-polyglot'              " Collection of language packs to rule them all
        Plug 'tpope/vim-eunuch'                  " File operations
        Plug 'tpope/vim-fugitive'                " Git integration
        Plug 'junegunn/goyo.vim'                 " Distraction-free writing in Vim
        Plug 'airblade/vim-rooter'               " Automatically cd to project root

        " Utility
        Plug 'tpope/vim-surround'                " Mappings for inserting/changing/deleting surrounding characters/elements
        Plug 'tpope/vim-repeat'                  " Repeating more actions with .
        Plug 'tpope/vim-commentary'              " Easy commenting
        Plug 'tpope/vim-speeddating'             " Fix negative problem when incrementing dates
        Plug 'junegunn/vim-easy-align'           " Interactive alignment rules
        Plug 'tommcdo/vim-exchange'              " Operators for exchanging text
        Plug 'jiangmiao/auto-pairs', { 'for': [ 'rust', 'java', 'c', 'cpp', 'javascript', 'typescript' ] }

        " Fuzzy finding
        Plug 'junegunn/fzf'
        Plug 'junegunn/fzf.vim'

        " Interface/colorschemes
        Plug 'arcticicestudio/nord-vim'

        " Text objects
        Plug 'kana/vim-textobj-user'
        Plug 'kana/vim-textobj-function'         " Java/python/vim functions

        " Language-specific plugins
        Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
        Plug 'rust-lang/rust.vim', { 'for': 'rust' }
        Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
        Plug 'nprindle/lc3.vim', { 'for': 'lc3' }
        " Plug 'lervag/vimtex', { 'for': 'tex' }
        Plug 'JamshedVesuna/vim-markdown-preview', { 'for': 'markdown' }

        call plug#end()
    endif
" }}}

" Plugin settings {{{
" Netrw
    let g:netrw_banner=0
    " Default to thin view
    let g:netrw_liststyle=1
    " Open previews to the bottom-right
    "let g:netrw_preview=0
    "let g:netrw_alto=0
    " Default to right splitting
    "let g:netrw_altv=1

" Rooter
    let g:rooter_silent_chdir = 1

" Vimwiki
    highlight VimwikiLink ctermbg=black ctermfg=2
    highlight VimwikiHeader1 ctermfg=magenta
    highlight VimwikiHeader2 ctermfg=blue
    highlight VimwikiHeader3 ctermfg=green
    let wiki = {}
    let wiki.path = '~/wiki/'
    let wiki.path_html = '~/wiki/html/'
    let wiki.template_path = wiki.path . 'templates/'
    let wiki.css_name = '../style.css'
    let wiki.template_ext = '.tpl'
    let wiki.nested_syntaxes = {
                \ 'haskell':     'haskell',
                \ 'c':           'c',
                \ 'c++':         'cpp',
                \ 'cpp':         'cpp',
                \ 'java':        'java',
                \ 'javascript':  'javascript',
                \ 'python':      'python',
                \ 'scala':       'scala',
                \ 'lc3':         'lc3',
                \ }
    let g:vimwiki_list = [wiki]
    let g:vimwiki_listsyms = ' .○●✓'
    let g:vimwiki_listsym_rejected = '✗'
    let g:vimwiki_dir_link = 'index'
    "let g:vimwiki_table_auto_fmt = 0

" Goyo
    function! s:goyo_enter() abort
        set nolist
        set foldcolumn=0
        set wrap
        set scrolloff=999
    endfunction
    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested source $MYVIMRC

" haskell-vim
    let g:haskell_enable_quantification = 1   " `forall`
    let g:haskell_enable_recursivedo = 1      " `mdo` and `rec`
    let g:haskell_enable_arrowsyntax = 1      " `proc`
    let g:haskell_enable_pattern_synonyms = 1 " `pattern`
    let g:haskell_enable_typeroles = 1        " type roles
    let g:haskell_enable_static_pointers = 1  " `static`
    let g:haskell_backpack = 1                " backpack keywords

    let g:haskell_indent_if = 2
    let g:haskell_indent_in = 0

" markdown-preview
    let vim_markdown_preview_pandoc = 1
    let vim_markdown_preview_use_xdg_open = 1

" lc3.vim
    let g:lc3_detect_asm = 1
" }}}

" Colorscheme can come anywhere after highlighting autocommands
    if &term =~ ".*-256color" && !empty(globpath(&runtimepath, 'colors/nord.vim'))
        silent! colorscheme nord
    else
        silent! colorscheme elflord
    endif

" Local vimrc
    if !empty(glob('~/local.vimrc'))
        execute 'source ' . glob('~/local.vimrc')
    end

" vim:foldmethod=marker
