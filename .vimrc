" Settings {{{
" Basic
    set encoding=utf-8
    scriptencoding utf-8
    set ffs=unix,dos,mac
    " Prevent highlighting from changing when resourcing vimrc
    if !syntax_on
        syntax on
    end
    " Enable filetype detection
    filetype plugin indent on

" Backups
    set backup
    set writebackup
    set backupdir=~/.vim/backup
    set swapfile
    set directory^=~/.vim/tmp
    if has('persistent_undo')
        set undofile
        set undodir=~/.vim/undo
    endif

" Spelling and thesaurus
    let $LANG='en'
    set nospell spelllang=en_us
    set thesaurus=~/.vim/thesaurus/mthesaur.txt

" Colors and terminal settings
    if &term =~ ".*-256color"
        set t_Co=256
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
    set mouse=
    set scrolloff=0
    set tags=tags;/

" Display
    set lazyredraw                       " don't redraw until after command/macro
    set shortmess+=I                     " disable Vim intro screen
    set splitbelow splitright            " sensible split defaults
    set number relativenumber            " use Vim properly
    set list listchars=tab:>-,eol:¬,extends:>,precedes:<
    set nocursorline nocursorcolumn
    " status line (when lightline isn't available)
    set laststatus=2
    "set statusline=[%n]\ %F%<\ %m%y%h%w%r\ \ %(0x%B\ %b%)%=%p%%\ \ %(%l/%L%)%(\ \|\ %c%V%)%(\ %)
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
    " set tildeop                          " Make ~ behave like g~ does by default

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
        " Highlighting
        augroup highlight_group
            autocmd!
            " Highlight trailing whitespace
            autocmd ColorScheme * highlight ExtraWhitespace ctermbg=12
            " Left column
            autocmd ColorScheme * highlight FoldColumn ctermbg=NONE
                              \ | highlight Folded ctermbg=NONE
                              \ | highlight CursorLineNr ctermbg=4 ctermfg=15
            " Highlight text width boundary boundary
            autocmd ColorScheme * highlight ColorColumn ctermbg=8
            " Highlight TODO in intentionally annoying colors
            autocmd ColorScheme * highlight Todo ctermbg=1 ctermfg=15
        augroup END
    endif
" }}}

" Functions/commands {{{
" Force sudo write trick
    command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Fetch mthesaurus.txt from gutenberg with curl
    command! GetThesaurus :!curl --create-dirs http://www.gutenberg.org/files/3202/files/mthesaur.txt -o ~/.vim/thesaurus/mthesaur.txt

" Reverse lines
    command! -bar -range=% Reverse <line1>,<line2>g/^/m<line1>-1 | nohlsearch

" Session management
    function! GetSessions(arglead, cmdline, cursorpos) abort
        let paths = split(globpath(&runtimepath, 'sessions/*.vim'), "\n")
        let names = map(paths, 'fnamemodify(v:val, ":t:r")')
        if empty(a:arglead)
            return names
        else
            return filter(names, {idx, val -> len(val) >= len(a:arglead) && val[:len(a:arglead) - 1] ==# a:arglead})
        endif
    endfunction
    " Save
    command! -bang -nargs=? -complete=customlist,GetSessions Save :call MkSession("<bang>", <f-args>)
    function! MkSession(b, ...) abort
        if a:0 > 0
            execute "mksession" . a:b . " ~/.vim/sessions/" . a:1 . ".vim"
            echo "Saved session to ~/.vim/sessions/" . a:1 . ".vim"
        else
            execute "mksession! ~/.vim/sessions/temp.vim"
            echo "Saved session to ~/.vim/sessions/temp.vim"
        endif
    endfunction
    " Restore
    command! -nargs=? -complete=customlist,GetSessions Restore :call SourceSession(<f-args>)
    function! SourceSession(...) abort
        execute "source ~/.vim/sessions/" . (a:0 > 0 ? a:1 : 'temp') . ".vim"
    endfunction

" Enable easy mode (for teaching recitation with a non-Vim user)
    command! EM execute "set insertmode | source $VIMRUNTIME/evim.vim"

" JSON utilities
    " Format with python's JSON tool
    command! -range JT <line1>,<line2>!python3 -mjson.tool
    " Convert JSON to YAML
    command! -range JY <line1>,<line2>!python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'
    " Convert YAML to JSON
    command! -range YJ <line1>,<line2>!python3 -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout)'

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

    " Use the regexes in g:change_case to substitute text. Not strictly limited
    " to case. Used with operatorfunc in mappings.
    function! ChangeCase(vt, ...) abort
        let l:winview = winsaveview()
        if a:0
            silent exec 'normal! gvy'
        elseif a:vt ==? 'line'
            silent exec "normal! '[V']y"
        else
            silent exec 'normal! `[v`]y'
        endif
        let @@ = substitute(@@, g:change_case[0], g:change_case[1], 'ge')
        silent exec 'normal! gv"0P'
        nohlsearch
        call winrestview(l:winview)
    endfunction

    " Use a visual block selection to pad with spaces
    function! ExpandSpaces() abort
        " Index 3 includes overflow information for virtualedit
        let [start, startv] = getpos("'<")[2:3]
        let [end, endv]     = getpos("'>")[2:3]
        let cols = abs(end + endv - start - startv) + 1
        execute 'normal gv' . cols . 'I '
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
    function! ReadTemplate() abort
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
" * Double leader is for execution of meta-editing operations, like reading in
"   templates or inline execution
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
    xnoremap Q :norm @q<CR>
    xnoremap . :norm .<CR>
    " Make Y behave like C and D
    noremap Y y$
    " Swap ` and '
    noremap ' `
    noremap ` '
    " Make & keep flags
    nnoremap & :&&<CR>
    " Make temporary unlisted scratch buffer
    nnoremap <Leader>t :new<CR>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile<CR>
    " Search word underneath cursor/selection but don't jump
    nnoremap <silent> * :let wv=winsaveview()<CR>*:call winrestview(wv)<CR>
    vnoremap <silent> * :<C-u>let wv=winsaveview()<CR>gvy/<C-r>"<CR>:call winrestview(wv)<CR>
    " Redraw page and clear highlights
    noremap <silent> <C-l> :nohlsearch<CR><C-l>

" Editing
    " Convenient semicolon insertion
    nnoremap <silent> <Leader>; :let wv=winsaveview()<CR>:s/[^;]*\zs\ze\s*$/;/e \| nohlsearch<CR>:call winrestview(wv)<CR>
    vnoremap <silent> <Leader>; :let wv=winsaveview()<CR>:s/\v(\s*$)(;)@<!/;/g \| nohlsearch<CR>:call winrestview(wv)<CR>
    " Exchange operation-delete, highlight target, exchange (made obsolete by exchange.vim)
    "xnoremap gx <Esc>`.``gvP``P
    " Split current line by provided regex (\zs or \ze to preserve separators)
    nnoremap <silent> <expr> <Leader>s ':s/' . input('split/') . '/\r/g \| nohlsearch<CR>'
    " easy-align live interactive mode
    nmap ga <Plug>(LiveEasyAlign)
    vmap ga <Plug>(LiveEasyAlign)
    " Prompt for regex to tabularize on
    nnoremap <Leader>a :Tab/
    vnoremap <Leader>a :Tab/
    " Sort visual selection
    vnoremap <silent> <Leader>vs :sort /\ze\%V/<CR>gvyugvpgv:s/\s\+$//e \| nohlsearch<CR>``
    " Read in a template
    nnoremap <Leader><Leader>t :call ReadTemplate()<CR>

" Sessions
    nnoremap \s :Save<CR>
    nnoremap \r :Restore<CR>

" Managing Whitespace
    " Delete trailing whitespace and retab
    nnoremap <silent> <Leader><Tab> :let wv=winsaveview()<CR>:%s/\s\+$//e \| call histdel("/", -1) \| nohlsearch \| retab<CR>:call winrestview(wv)<CR>
    " Add blank line below/above line/selection, keep cursor in same position (can take count)
    nnoremap <silent> <Leader>j :<C-u>call append(line("."), repeat([''], v:count1))<CR>
    nnoremap <silent> <Leader>k :<C-u>call append(line(".") - 1, repeat([''], v:count1))<CR>
    vnoremap <silent> <Leader>j :<C-u>call append(line("'>"), repeat([''], v:count1))<CR>gv
    vnoremap <silent> <Leader>k :<C-u>call append(line("'<") - 1, repeat([''], v:count1))<CR>gv
    nnoremap <silent> <Leader>n :<C-u>call append(line("."), repeat([''], v:count1)) \| call append(line(".") - 1, repeat([''], v:count1))<CR>
    vnoremap <silent> <Leader>n :<C-u>call append(line("'>"), repeat([''], v:count1)) \| call append(line("'<") - 1, repeat([''], v:count1))<CR>
    " Expand line by padding visual block selection with spaces
    vnoremap <Leader>e <Esc>:call ExpandSpaces()<CR>

" Convenience
    noremap <Leader>d "_d
    noremap <Leader>D "_D
    noremap <Leader>p "0p
    noremap <Leader>P "0P

" Registers
    " Display registers
    nnoremap <silent> "" :registers<CR>
    " Copy contents of register to another, providing ' as an alias for "
    nnoremap <silent> <Leader>r :let r1 = substitute(nr2char(getchar()), "'", "\"", "") \| let r2 = substitute(nr2char(getchar()), "'", "\"", "")
          \ \| execute 'let @' . r2 . '=@' . r1 \| echo "Copied @" . r1 . " to @" . r2<CR>

" Navigation Matching navigation commands, like in unimpaired
    nnoremap ]b :bnext<CR>
    nnoremap [b :bprevious<CR>
    nnoremap ]B :blast<CR>
    nnoremap [B :bfirst<CR>

    nnoremap ]t :tnext<CR>
    nnoremap [t :tprevious<CR>
    nnoremap ]T :tlast<CR>
    nnoremap [T :tfirst<CR>

    nnoremap ]q :cnext<CR>
    nnoremap [q :cprevious<CR>
    nnoremap ]Q :clast<CR>
    nnoremap [Q :cfirst<CR>

    nnoremap ]l :lnext<CR>
    nnoremap [l :lprevious<CR>
    nnoremap ]L :llast<CR>
    nnoremap [L :lfirst<CR>

" Text objects
    " Inner line - line minus leading/trailing blanks
    vnoremap <silent> il :<C-u>normal! g_v^<CR>
    onoremap <silent> il :normal! g_v^<CR>
    " Around line - a line, minus the newline on the end
    vnoremap <silent> al :<C-u>normal! $v0<CR>
    onoremap <silent> al :normal! $v0<CR>
    " Inner document
    vnoremap <silent> id :<C-u>normal! GVgg<CR>
    onoremap <silent> id :normal! GVgg<CR>
    " Folds
    vnoremap <silent> iz :<C-u>normal! [zjV]zk<CR>
    xnoremap <silent> iz :normal! [zjV]zk<CR>
    vnoremap <silent> az :<C-u>normal! [zV]z<CR>
    xnoremap <silent> az :normal! [zV]z<CR>

" Netrw mappings (<Leader>l)
    " Open directory of current buffer in vertical split
    nnoremap <Leader>lv :Vex<CR>
    " Open directory of current working directory in vertical split
    nnoremap <Leader>ll :Lex<CR>

" fzf mappings (<Leader>f)
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
    " Tags in project
    nnoremap <Leader>ft :Tags<CR>

" Fugitive mappings (<Leader>g)
    nnoremap <Leader>gs  :Gstatus<CR>
    nnoremap <Leader>gpl :Gpull<CR>
    nnoremap <Leader>gps :Gpush<CR>
    nnoremap <Leader>gw  :Gwrite<CR>
    nnoremap <Leader>gc  :Gcommit<CR>
    nnoremap <Leader>gd  :Gvdiff<CR>

" Goyo mappings
    nnoremap <Leader>gy :Goyo<CR>

" Quick settings changes
    " .vimrc editing/sourcing
    nnoremap <Leader><Leader>ev :edit $MYVIMRC<CR>
    nnoremap <Leader><Leader>sv :source $MYVIMRC<CR>
    " Filetype ftplugin editing
    nnoremap <Leader><Leader>ef :edit ~/.vim/ftplugin/<C-r>=&filetype<CR>.vim<CR>
    " Change indent level on the fly
    nnoremap <Leader>i :let i=input('ts=sts=sw=') \| if i \| execute 'setlocal tabstop=' . i . ' softtabstop=' . i . ' shiftwidth=' . i \| endif
                \ \| redraw \| echo 'ts=' . &tabstop . ', sts=' . &softtabstop . ', sw='  . &shiftwidth . ', et='  . &expandtab<CR>
    " Binary switches
    nnoremap ]oc :set colorcolumn=+1<CR>
    nnoremap [oc :set colorcolumn=<CR>

" Changing case (gc)
    " Title Case
    let g:change_case_title=['\v\w+', '\u\L&']
    nnoremap <silent> gct  :let g:change_case=g:change_case_title<CR>:set operatorfunc=ChangeCase<CR>g@
    nnoremap <silent> gctt :let g:change_case=g:change_case_title<CR>g_v^:call ChangeCase(visualmode(), 1)<CR>
    xnoremap <silent> gct <Esc>:let g:change_case=g:change_case_title<CR>:call ChangeCase(visualmode(), 1)<CR>
    " Alternating caps (lowercase first)
    let g:change_case_alt_low = ['\v(\w)(.{-})(\w)', '\L\1\2\U\3']
    nnoremap <silent> gca :let g:change_case=g:change_case_alt_low<CR>:set operatorfunc=ChangeCase<CR>g@
    nnoremap <silent> gcaa :let g:change_case=g:change_case_alt_low<CR>g_v^:call ChangeCase(visualmode(), 1)<CR>
    xnoremap <silent> gca <Esc>:let g:change_case=g:change_case_alt_low<CR>:call ChangeCase(visualmode(), 1)<CR>
    " Alternating caps (uppercase first)
    let g:change_case_alt_up = ['\v(\w)(.{-})(\w)', '\U\1\2\L\3']
    nnoremap <silent> gcA :let g:change_case=g:change_case_alt_up<CR>:set operatorfunc=ChangeCase<CR>g@
    nnoremap <silent> gcAA :let g:change_case=g:change_case_alt_up<CR>g_v^:call ChangeCase(visualmode(), 1)<CR>
    xnoremap <silent> gcA <Esc>:let g:change_case=g:change_case_alt_up<CR>:call ChangeCase(visualmode(), 1)<CR>

" Inline execution
    " Run selection in python and replace with output for programmatic text generation
    nnoremap <Leader><Leader>p :.!python3<CR>
    vnoremap <Leader><Leader>p :!python3<CR>

" Base conversion utilities (gb)
    nnoremap <Leader>hx :Hexmode<CR>
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
    nmap gbdb <Plug>(DecToBin)
    nmap gbbd <Plug>(BinToDec)
    vmap gbdb <Plug>(DecToBin)
    vmap gbbd <Plug>(BinToDec)
    nmap gbdh <Plug>(DecToHex)
    nmap gbhd <Plug>(HexToDec)
    vmap gbdh <Plug>(DecToHex)
    vmap gbhd <Plug>(HexToDec)

" Quick notes
    " Global scratch buffer
    nnoremap <Leader><Leader>es :edit ~/scratch<CR>
    " Vimwiki quick notes file
    nnoremap <Leader>wq :e ~/wiki/quick/index.wiki<CR>

" Misc
    " Change working directory to directory of current file
    nnoremap <Leader><Leader>cd :cd %:h<CR>
    " Show calendar and date/time
    nnoremap \ec :!clear && cal -y && date -R<CR>
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
    command! PlugSetup call PlugSetup()
    function! PlugSetup() abort
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
            execute('PlugClean')
            execute('PlugUpdate')
        endif
    endfunction

    silent! if plug#begin('~/.vim/bundle')
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
        Plug 'godlygeek/tabular'                 " Tabularization and alignment
        Plug 'tommcdo/vim-exchange'              " Operators for exchanging text
        Plug 'vim-scripts/matchit.zip'
        Plug 'jiangmiao/auto-pairs', { 'for': ['java', 'c', 'cpp'] }

        " Fuzzy finding
        Plug 'junegunn/fzf'
        Plug 'junegunn/fzf.vim'

        " Interface and colorschemes
        Plug 'itchyny/lightline.vim'
        Plug 'arcticicestudio/nord-vim'

        " Text objects
        Plug 'kana/vim-textobj-user'
        Plug 'kana/vim-textobj-function'

        " Language server
        " Plug 'prabirshrestha/async.vim'
        " Plug 'prabirshrestha/vim-lsp'

        " Language-specific
        Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
        Plug 'JamshedVesuna/vim-markdown-preview', { 'for': 'markdown' }

        call plug#end()
    endif
" }}}

" Plugin settings {{{
" Netrw
    let g:netrw_banner=0

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
    function! LightlineKeymapName() abort
        return &keymap
    endfunction

    function! LightlineBufferline() abort
        call bufferline#refresh_status()
        return [g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after]
    endfunction

    let g:lightline = {
                \ 'active': {
                \   'left': [ [ 'mode', 'paste' ],
                \             [ 'readonly', 'buffilename', 'modified', 'fugitive', 'keymapname', 'charvalue' ] ]
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
                \   'fugitive': 'FugitiveHead',
                \ },
                \ }

" Goyo
    function! s:goyo_enter() abort
        set noshowcmd
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
" }}}

" Colorscheme can come anywhere after highlighting autocommands
    if &term =~ ".*-256color"
        colorscheme nord
        let g:lightline['colorscheme'] = 'nord'
    else
        colorscheme elflord
        let g:lightline['colorscheme'] = 'powerline'
    endif

" Local vimrc
    if !empty(glob('~/local.vimrc'))
        source ~/local.vimrc
    end

" Meow
    augroup meow
        autocmd! VimEnter * echo '>^.^<'
    augroup END

" vim:foldmethod=marker
