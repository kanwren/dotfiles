" Settings {{{
" Basic
    set nocompatible
    set encoding=utf-8
    scriptencoding utf-8
    set ffs=unix,dos,mac
    " Prevent highlighting from changing when resourcing vimrc
    if !syntax_on
        syntax on
    end
    " enable filetype detection
    filetype on
    filetype indent on
    filetype plugin on

" Spelling
    let $LANG='en'
    set nospell spelllang=en_us

" Backups
    set swapfile
    set backup
    set writebackup
    set backupdir=~/.vim/backup
    set directory^=~/.vim/tmp

" Colors and terminal settings
    if &term ==? "xterm-256color"
        set t_Co=256
        let &t_ti.="\e[1 q"
        let &t_SI.="\e[5 q"
        let &t_EI.="\e[1 q"
        let &t_te.="\e[0 q"
    endif
    set background=dark
    colorscheme elflord

" Buffers
    set hidden                           " allow working with buffers
    set autoread
    set noconfirm                        " fail, don't ask to save
    set modelines=1                      " use one line to tell vim how to read the buffer

" History
    set history=1000
    set undolevels=1000

" Disable annoying flashing/beeping
    set noerrorbells
    set visualbell t_vb=

" Navigation
    set mouse=
    set scrolloff=0
    set tags=tags;/

" Display
    set lazyredraw                       " don't redraw until after command/macro
    set shortmess+=I                     " disable Vim intro screen
    set number relativenumber            " use Vim properly
    set list listchars=tab:>-,eol:¬,extends:>,precedes:<
    set nocursorline nocursorcolumn
    " status line (when lightline isn't available)
    set laststatus=2
    "set statusline=[%n]\ %F%<\ \ \ %m%y%h%w%r\ \ %(0x%B\ %b%)%=%(col\ %c%)\ \ \ \ %(%l\ /\ %L%)\ \ \ \ %p%%%(\ %)
    set showmode
    " command bar
    set cmdheight=1
    set showcmd
    " completion menu
    set wildmenu
    set wildmode=longest:list,full

" Editing
    set clipboard=unnamedplus
    set virtualedit=all                  " allow editing past the ends of lines
    set splitbelow splitright            " sensible split defaults
    set nojoinspaces                     " never two spaces after sentence
    set backspace=indent,eol,start       " let backspace delete linebreak
    set whichwrap+=<,>,h,l,[,]           " direction key wrapping
    set nrformats=bin,hex                " don't increment octal numbers

" Indentation
    set autoindent smartindent
    set tabstop=4                        " treat tabs as 4 spaces wide
    set expandtab softtabstop=4          " expand tabs to 4 spaces
    set shiftwidth=4                     " use 4 spaces when using > or <
    set smarttab
    set noshiftround
    set cinoptions+=:0L0g0j1J1           " indent distance for case, jumps, scope declarations

" Searching
    set magic
    set noignorecase smartcase
    set showmatch
    set incsearch hlsearch

" Wrapping
    set nowrap
    set textwidth=120
    set formatoptions=croqjln

" Folds
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

" Autocommands {{{
    if has('autocmd')
        augroup general_group
            autocmd!
            " Open help window on right by default
            autocmd FileType help wincmd L
            " Return to last edit position when opening files
            autocmd BufReadPost *
                        \   if line("'\"") > 1 && line("'\"") <= line("$")
                        \ |     exe "normal! g'\""
                        \ | endif
            " Highlight trailing whitespace (except when typing at end of line)
            autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
            autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
            autocmd InsertLeave * match ExtraWhitespace /\s\+$/
            " Define new filetypes for ftplugin
            autocmd BufNewFile,BufRead *.nix setf nix
            autocmd BufNewFile,BufRead *.sc setf scala
        augroup END
    endif
" }}}

" Highlighting {{{
    " Highlight trailing whitespace
    highlight ExtraWhitespace ctermbg=12

    " Left column
    highlight FoldColumn ctermbg=NONE
    highlight Folded ctermbg=NONE
    highlight CursorLineNr ctermbg=4 ctermfg=15

    " Highlight text width boundary boundary
    set colorcolumn=+1
    highlight ColorColumn ctermbg=8

    " Highlight TODO in intentionally annoying colors
    highlight Todo ctermbg=1 ctermfg=15
"}}}

" Functions/commands {{{
" Force write trick
    command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Utility
    function! ClearRegisters()
        let regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-*+"'
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

    function! SetIndents()
        let i = input('ts=sts=sw=')
        if i
            execute 'setlocal tabstop=' . i . ' softtabstop=' . i . ' shiftwidth=' . i
        endif
        echo 'ts=' . &tabstop . ', sts=' . &softtabstop . ', sw='  . &shiftwidth . ', et='  . &expandtab
    endfunction

    " Copy one register to another
    function! CopyRegister()
        " Provide ' as an easier-to-type alias for "
        let r1 = substitute(nr2char(getchar()), "'", "\"", "")
        let r2 = substitute(nr2char(getchar()), "'", "\"", "")
        execute 'let @' . r2 . '=@' . r1
        echo "Copied @" . r1 . " to @" . r2
    endfunction

    " Use the regexes in g:change_case to substitute text. Not strictly limited
    " to case. Used with operatorfunc in mappings.
    function! ChangeCase(vt)
        if a:vt =~ 'v\|line\|V\|block\|\<C-v>'
            silent exec 'normal! gvy'
            let @" = substitute(@", g:change_case[0], g:change_case[1], 'ge')
            silent exec 'normal! gv"0P'
        else
            silent exec 'normal! mx`[v`]y'
            let @" = substitute(@", g:change_case[0], g:change_case[1], 'ge')
            silent exec 'normal! gv"0P`x'
        endif
        nohlsearch
    endfunction

    " Use a visual block selection to pad with spaces
    function! ExpandSpaces()
        " Index 3 includes overflow information for virtualedit
        let [start, startv] = getpos("'<")[2:3]
        let [end, endv]     = getpos("'>")[2:3]
        let cols = abs(end + endv - start - startv) + 1
        let com  = 'normal ' . cols . 'I '
        normal gv
        execute com
    endfunction

    " nix-prefetch-git shortcut
    command! -bar -nargs=+ NPG call Nix_Prefetch_Git(<f-args>)
    function! Nix_Prefetch_Git(owner, repo, ...)
        " Other fields: url, date, fetchSubmodules
        let fields = ['rev', 'sha256']
        let command = 'nix-prefetch-git git@github.com:' . a:owner . '/' . a:repo
        if a:0 > 0
            let command .= ' --rev ' . a:1
        end
        let command .= ' --quiet 2>/dev/null | grep -E "' . join(fields, '|') . '" | sed -E "s/\s*\"(.+)\": \"(.+)\",/\1 = \"\2\";/g"'
        if $USER ==# 'root'
            " If root, try to run command as login user instead
            let logname = substitute(system('logname'), '\n', '', 'ge')
            execute('read! ' . 'runuser -l ' . logname . " -c '" . command . "'")
        else
            execute('read! ' . command)
        endif
    endfunction

    " Query the user to read in a template located in ~/.vim/template
    function! ReadTemplate()
        let category = input('category: ', '')
        if empty(category)
            return
        endif
        let template = input('template: ', '')
        " Default to tpl.txt
        if empty(template)
            let template = 'tpl'
        endif
        let path = '~/.vim/template/' . category . '/' . template . '.txt'
        if empty(glob(path))
            redraw
            echo "template '" . template . "'does not exist"
            return
        end
        let contents = readfile(glob(path))
        let filtered = []
        for line in contents
            let vars = []
            call substitute(line, '%\(.\{-}\)%', '\=add(vars, submatch(1))', 'g')
            for var in vars
                let val = input(var . ': ')
                if empty(val)
                    let val = '<' . var . '>'
                endif
                let line = substitute(line, '%' . var . '%', val, 'e')
            endfor
            call add(filtered, line)
        endfor
        call append(line('.'), filtered)
    endfunction

" Hex editing
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

" Testing
    function! ColorList()
        let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
        return map(paths, 'fnamemodify(v:val, ":t:r")')
    endfunction

    function! NextColor()
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
    vnoremap Q :norm @q<CR>
    vnoremap . :norm .<CR>
    " Make Y behave like C and D
    noremap Y y$
    " Swap ` and '
    noremap ' `
    noremap ` '
    " Make & keep flags
    nnoremap & :&&<CR>
    " Make temporary unlisted scratch buffer
    noremap <Leader>t :new<CR>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile<CR>
    " Faster visual substitute
    vnoremap gs :s/\%V
    " Redraw page and clear highlights
    noremap <C-l> :nohlsearch<CR><C-l>

" Editing
    " Convenient semicolon insertion
    nnoremap <Leader>; mx:s/[^;]*\zs\ze\s*$/;/e \| nohlsearch<CR>`x
    vnoremap <Leader>; :s/\v(\s*$)(;)@<!/;/g<CR>
    " Exchange operation-delete, highlight target, exchange (made obsolete by exchange.vim)
    "vnoremap gx <Esc>`.``gvP``P
    " Split current line by provided regex (\zs or \ze to preserve separators)
    nnoremap <silent> <expr> <Leader>s ':s/' . input('split/') . '/\r/g \| nohlsearch<CR>'
    " Align; prompt for regular expression on which to tabularize
    nnoremap <silent> <expr> <Leader>a ":let p = input('tab/') \| execute ':Tabularize' . (empty(p) ? '' : ' /' . p)<CR>"
    vnoremap <silent> <Leader>a <Esc>:let p = input('tab/') \| execute ":'<,'>Tabularize" . (empty(p) ? '' : ' /' . p)<CR>
    " Sort visual selection
    vnoremap <silent> <Leader>vs :sort /\ze\%V/<CR>gvyugvpgv:s/\s\+$//e \| nohlsearch<CR>``
    " Read in a template
    nnoremap <Leader><Leader>t :call ReadTemplate()<CR>

" Whitespace
    " Add blank line below/above current line, cursor in same column
    nnoremap <silent> <Leader>o :<C-u>call append(line("."), repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>j<CR>
    nnoremap <silent> <Leader>O :<C-u>call append(line(".") - 1, repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>k<CR>
    " Add newlines around current line/selection
    nnoremap <silent> <Leader>n :<C-u>call append(line('.'), repeat([''], v:count1)) \| call append(line('.') - 1, repeat([''], v:count1))<CR>
    vnoremap <silent> <Leader>n <Esc>:call append(line("'>"), '') \| call append(line("'<") - 1, '')<CR>
    " Expand line by padding visual block selection with spaces
    vnoremap <Leader>e <Esc>:call ExpandSpaces()<CR>
    " Delete trailing whitespace and retab
    noremap <Leader><Tab> mx:%s/\s\+$//e \| nohlsearch \| retab<CR>`x

" Convenience
    noremap <Leader>d "_d
    noremap <Leader>D "_D
    noremap <Leader>p "0p
    noremap <Leader>P "0P

" Registers
    " Display registers
    noremap <silent> "" :registers<CR>
    " Copy contents from one register to another (like MOV, but with arguments reversed)
    noremap <silent> <Leader>r :call CopyRegister()<CR>

" Navigation
    " Fast buffer navigation/editing
    noremap <Leader>b :ls<CR>:b
    " Search word underneath cursor/selection but don't jump
    nnoremap <Leader>* mx*`x
    vnoremap <Leader>* mxy/<C-r>"<CR>`x
    " Matching navigation commands, like in unimpaired
    noremap ]b :bnext<CR>
    noremap [b :bprevious<CR>
    noremap ]B :blast<CR>
    noremap [B :bfirst<CR>

    noremap ]t :tnext<CR>
    noremap [t :tprevious<CR>
    noremap ]T :tlast<CR>
    noremap [T :tfirst<CR>

    noremap ]q :cnext<CR>
    noremap [q :cprevious<CR>
    noremap ]Q :clast<CR>
    noremap [Q :cfirst<CR>

    noremap ]l :lnext<CR>
    noremap [l :lprevious<CR>
    noremap ]L :llast<CR>
    noremap [L :lfirst<CR>

" fzf mappings
    " All files
    nnoremap <Leader>ff :Files<CR>
    " All git ls-files files
    nnoremap <Leader>fg :GFiles<CR>
    " All lines in loaded buffers
    nnoremap <Leader>fl :Lines<CR>
    " All lines in current buffer
    nnoremap <Leader>fb :BLines<CR>
    " Results of an ag search
    nnoremap <Leader>fa :Ag<Space>
    " Tags in project (doesn't quite jump right currently)
    nnoremap <Leader>ft :Tags<CR>

" Fugitive mappings
    nnoremap <Leader>gs :Gstatus<CR>
    nnoremap <Leader>gpl :Gpull<CR>
    nnoremap <Leader>gps :Gpush<CR>
    nnoremap <Leader>gw :Gwrite<CR>
    nnoremap <Leader>gc :Gcommit<CR>
    nnoremap <Leader>gd :Gvdiff<CR>

" Quick settings changes
    " .vimrc editing/sourcing
    noremap <Leader><Leader>ev :edit $MYVIMRC<CR>
    noremap <Leader><Leader>sv :source $MYVIMRC<CR>
    " Filetype ftplugin editing
    noremap <Leader><Leader>ef :edit ~/.vim/ftplugin/<C-r>=&filetype<CR>.vim<CR>
    " Change indent level on the fly
    noremap <expr> <Leader><Leader>i SetIndents()
    " Binary switches
    noremap ]oc :set colorcolumn=+1<CR>
    noremap [oc :set colorcolumn=<CR>
    noremap ]ot :set textwidth=120<CR>
    noremap [ot :set textwidth=80<CR>

" Changing case
    " Title Case
    let g:change_case_title=['\v\w+', '\u\L&']
    nnoremap <silent> cut  :let g:change_case=g:change_case_title<CR>:set operatorfunc=ChangeCase<CR>g@
    nnoremap <silent> cutc :let g:change_case=g:change_case_title<CR>V:call ChangeCase(visualmode())<CR>
    vnoremap <silent> cut <Esc>:let g:change_case=g:change_case_title<CR>:call ChangeCase(visualmode())<CR>
    " Alternating caps (lowercase first)
    let g:change_case_alt_low = ['\v(\w)(.{-})(\w)', '\L\1\2\U\3']
    nnoremap <silent> cua :let g:change_case=g:change_case_alt_low<CR>:set operatorfunc=ChangeCase<CR>g@
    nnoremap <silent> cuac :let g:change_case=g:change_case_alt_low<CR>V:call ChangeCase(visualmode())<CR>
    vnoremap <silent> cua <Esc>:let g:change_case=g:change_case_alt_low<CR>:call ChangeCase(visualmode())<CR>
    " Alternating caps (uppercase first)
    let g:change_case_alt_up = ['\v(\w)(.{-})(\w)', '\U\1\2\L\3']
    nnoremap <silent> cuA :let g:change_case=g:change_case_alt_up<CR>:set operatorfunc=ChangeCase<CR>g@
    nnoremap <silent> cuAc :let g:change_case=g:change_case_alt_up<CR>V:call ChangeCase(visualmode())<CR>
    vnoremap <silent> cuA <Esc>:let g:change_case=g:change_case_alt_up<CR>:call ChangeCase(visualmode())<CR>

" Conversion
    " Format selection using python's JSON tool
    nnoremap <Leader><Leader>jt :.!python3 -mjson.tool<CR>
    vnoremap <Leader><Leader>jt :!python3 -mjson.tool<CR>
    " JSON to YAML
    vnoremap <silent> <Leader><Leader>cjy :!python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'<CR>
    " YAML to JSON
    vnoremap <silent> <Leader><Leader>cyj :!python3 -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout)'<CR>

" Inline execution
    " Replace selection with output when run in python for programmatic text generation
    nnoremap <Leader><Leader>p :.!python3<CR>
    vnoremap <Leader><Leader>p :!python3<CR>
    " Run selection in vimscript
    nnoremap <Leader><Leader>v 0"xy$:@x<CR>
    vnoremap <Leader><Leader>v "xy:@x<CR>

" Hex utilities
    nnoremap <Leader>hx :Hexmode<CR>
    vnoremap <Leader>he :call StrToHexCodes()<CR>
    vnoremap <Leader>hd :call HexCodesToStr()<CR>
    nnoremap <Leader>hs :echo 0x<C-r><C-w><CR>
    vnoremap <Leader>hs "xy:echo 0x<C-r>"<CR>
    nnoremap <Leader>ht :echo printf('%x', <C-r><C-w>)<CR>
    vnoremap <Leader>ht "xy:echo printf('%x', <C-r>")<CR>

" Quick notes
    " Global scratch buffer
    noremap <Leader><Leader>es :edit ~/scratch<CR>
    " Vimwiki notes file
    noremap <Leader>wq :e ~/wiki/quick/index.wiki<CR>

" Misc
    " Change working directory to directory of current file
    noremap <Leader><Leader>cd :cd %:h<CR>
    " Execute cal
    nnoremap <Leader><Leader>ec :!clear && cal -y<CR>

" Enable easy mode (for teaching recitation with a non-Vim user)
    nnoremap <Leader><Leader>em :set insertmode \| source $VIMRUNTIME/evim.vim<CR>
"}}}

" Abbreviations {{{
" Abbreviations for inserting common sequences
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
    command! PlugSetup call PlugSetup()
    function! PlugSetup()
        let plug_loc = '~/.vim/autoload/plug.vim'
        let plug_source = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        if empty(glob(plug_loc))
            echom 'vim-plug not found. Installing...'
            if executable('curl')
                silent exec '!curl -fLo curl -fLo ' . expand(plug_loc) . ' --create-dirs ' . plug_source
            elseif executable('wget')
                call mkdir(fnamemodify(s:plugin_loc, ':h'), 'p')
                silent exec '!wget --force-directories --no-check-certificate -O ' . expand(plug_loc) . ' ' . plug_source
            else
                echom 'Error: could not download vim-plug'
            endif
        else
            execute('PlugUpgrade')
        endif
    endfunction

    call plug#begin('~/.vim/bundle')
        Plug 'vimwiki/vimwiki'                   " Personal wiki for Vim

        " Interface
        Plug 'itchyny/lightline.vim'

        " Functionality
        Plug 'w0rp/ale'                          " Async linting tool
        Plug 'sheerun/vim-polyglot'              " Collection of language packs to rule them all (testing)
        "Plug 'scrooloose/nerdtree'               " File explorer/interface
        Plug 'tpope/vim-eunuch'                  " File operations
        Plug 'tpope/vim-fugitive'                " Git integration

        " Fuzzy finding
        Plug 'junegunn/fzf'
        Plug 'junegunn/fzf.vim'

        " Utility
        Plug 'tpope/vim-surround'                " Mappings for inserting/changing/deleting surrounding characters/elements
        Plug 'tpope/vim-repeat'                  " Repeating more actions with .
        Plug 'tpope/vim-speeddating'             " Fix negative problem when incrementing dates
        Plug 'godlygeek/tabular'                 " Tabularize
        Plug 'jiangmiao/auto-pairs'              " Automatically insert matching punctuation pair, etc.
        Plug 'tommcdo/vim-exchange'              " Text exchanging operators
        Plug 'vim-scripts/tComment'              " Easy commenting
        Plug 'vim-scripts/matchit.zip'

        " Text objects
        Plug 'kana/vim-textobj-user'
        Plug 'kana/vim-textobj-function'

        " Language-specific
        Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
    call plug#end()
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
                \ 'c':           'c',
                \ 'c++':         'cpp',
                \ 'cpp':         'cpp',
                \ 'java':        'java',
                \ 'javascript':  'javascript',
                \ 'python':      'python',
                \ 'scala':       'scala',
                \ }
    let g:vimwiki_list = [wiki]
    let g:vimwiki_listsyms = ' .○●✓'
    let g:vimwiki_listsym_rejected = '✗'
    let g:vimwiki_dir_link = 'index'

" Lightline
    function! LightlineKeymapName()
        return &keymap
    endfunction

    function! LightlineBufferline()
        call bufferline#refresh_status()
        return [g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after]
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

" haskell-vim
    let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
    let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
    let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
    let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
    let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
    let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
    let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
" }}}

" Local vimrc {{{
    if !empty(glob('~/local.vimrc'))
        source ~/local.vimrc
    end
" }}}

" vim:foldmethod=marker
