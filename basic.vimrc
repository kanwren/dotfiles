" Basic
    set nocompatible
    set encoding=utf-8
    scriptencoding utf-8
    set ffs=unix,dos,mac
    if !syntax_on
        syntax on
    end
    filetype on
    filetype indent on
    filetype plugin on

" Spelling
    let $LANG='en'
    set nospell spelllang=en_us

" Buffers
    set hidden autoread noconfirm

" History
    set history=1000
    set undolevels=1000

" Disable annoying flashing/beeping
    set noerrorbells visualbell t_vb=

" Navigation
    set mouse-=a
    set scrolloff=0

" Display
    set lazyredraw
    set shortmess+=I
    set number relativenumber
    set list listchars=tab:>-,eol:¬,extends:>,precedes:<
    set nocursorline nocursorcolumn
    set laststatus=2 showmode statusline=[%n]\ %F%<\ \ \ %m%y%h%w%r\ \ %(0x%B\ %b%)%=%(col\ %c%)\ \ \ \ %(%l\ /\ %L%)\ \ \ \ %p%%%(\ %)
    set cmdheight=1 showcmd
    set wildmenu wildmode=longest:list,full

" Editing
    set virtualedit=all
    set splitbelow splitright
    set nojoinspaces
    set backspace=indent,eol,start
    set whichwrap+=<,>,h,l,[,]
    set nrformats=bin,hex

" Indentation
    set autoindent smartindent
    set tabstop=4 expandtab softtabstop=4 smarttab shiftwidth=4 noshiftround
    set cinoptions+=:0L0g0j1J1

" Searching
    set magic
    set ignorecase smartcase
    set showmatch
    set incsearch hlsearch

" Wrapping
    set nowrap
    set textwidth=80
    set formatoptions=croqjln

" Folds
    set foldmethod=manual
    set foldcolumn=1
    set foldlevelstart=99

" Timeouts
    set timeout timeoutlen=3000
    set ttimeout ttimeoutlen=0

" Autocommands
    if has('autocmd')
        augroup general_group
            autocmd!
            autocmd FileType help wincmd L
            autocmd BufReadPost *
                        \   if line("'\"") > 1 && line("'\"") <= line("$")
                        \ |     exe "normal! g'\""
                        \ | endif
            autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
            autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
            autocmd InsertLeave * match ExtraWhitespace /\s\+$/
        augroup END
    end

" Highlighting
    highlight ExtraWhitespace ctermbg=12
    highlight FoldColumn ctermbg=NONE
    highlight Folded ctermbg=NONE
    highlight CursorLineNr ctermbg=4 ctermfg=15
    set colorcolumn=81
    highlight ColorColumn ctermbg=8
    highlight Todo ctermbg=1 ctermfg=15

" Leader configuration
    map <Space> <nop>
    map <S-Space> <Space>
    let mapleader=" "

" Sudo write trick
    command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Functions
    function! SetIndents(...)
        if a:0 > 0
            execute 'setlocal tabstop=' . a:1
                        \ . ' softtabstop=' . a:1
                        \ . ' shiftwidth=' . a:1
        else
            let i = input('ts=sts=sw=', '')
            if i
                call SetIndents(i)
            endif
            echo 'ts=' . &tabstop
                        \ . ', sts=' . &softtabstop
                        \ . ', sw=' . &shiftwidth
                        \ . ', et=' . &expandtab
        endif
    endfunction

    function! CopyRegister()
        let r1 = substitute(nr2char(getchar()), "'", "\"", "")
        let r2 = substitute(nr2char(getchar()), "'", "\"", "")
        execute 'let @' . r2 . '=@' . r1
        echo "Copied @" . r1 . " to @" . r2
    endfunction

    function! ExpandSpaces()
        let [start, startv] = getpos("'<")[2:3]
        let [end, endv]     = getpos("'>")[2:3]
        let cols = abs(end + endv - start - startv) + 1
        let com  = 'normal ' . cols . 'I '
        normal gv
        execute com
    endfunction

" Basic
    noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
    noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
    nnoremap Q @q
    vnoremap Q :norm @q<CR>
    vnoremap . :norm .<CR>
    noremap Y y$
    noremap ' `
    noremap ` '
    vnoremap g/ :s/\%V
    noremap <C-l> :nohlsearch<CR><C-l>

" Convenience
    noremap <Leader>d "_d
    noremap <Leader>D "_D
    noremap <Leader>p "0p
    noremap <Leader>P "0P

" Editing
    nnoremap <Leader>; mxg_a;<Esc>`x
    vnoremap <Leader>; :s/\v(\s*$)(;)@<!/;/g<CR>
    nnoremap <silent> <expr> <Leader>s ':s/' . input('split/') . '/\r/g<CR>'
    vnoremap <Leader>vs :sort /\ze\%V/<CR>gvyugvpgv:s/\s\+$//e \| nohlsearch<CR>``
    nnoremap <expr> <Leader><Leader>k ':set keymap=' . (&keymap ==? 'dvorak' ? '' : 'dvorak') . '<CR>'

" Whitespace
    noremap <Leader><Tab> mx:%s/\s\+$//ge \| retab<CR>`x
    vnoremap <Leader>e <Esc>:call ExpandSpaces()<CR>
    nnoremap <silent> <Leader>o :<C-u>call append(line("."), repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>j<CR>
    nnoremap <silent> <Leader>O :<C-u>call append(line(".") - 1, repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>k<CR>
    nnoremap <silent> <Leader>n :<C-u>call append(line('.'), repeat([''], v:count1)) \| call append(line('.') - 1, repeat([''], v:count1))<CR>
    vnoremap <silent> <Leader>n <Esc>:call append(line("'>"), '') \| call append(line("'<") - 1, '')<CR>

" Navigation
    noremap <Leader>b :ls<CR>:b
    noremap <Leader>* mx*`x
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

" Registers
    noremap <silent> <Leader>r :call CopyRegister()<CR>
    noremap <silent> "" :registers<CR>

" Settings changes
    noremap <Leader><Leader>ev :edit $MYVIMRC<CR>
    noremap <Leader><Leader>sv :source $MYVIMRC<CR>
    noremap <expr> <Leader><Leader>i SetIndents()
    noremap <Leader><Leader>cc :set colorcolumn=<C-r>=&colorcolumn == 81 ? "" : 81<CR><CR>

" Conversion
    nnoremap <Leader><Leader>jt :.!python3 -mjson.tool<CR>
    vnoremap <Leader><Leader>jt :!python3 -mjson.tool<CR>
    vnoremap <silent> <Leader><Leader>cjy :!python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'<CR>
    vnoremap <silent> <Leader><Leader>cyj :!python3 -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout)'<CR>

" Inline execution
    nnoremap <Leader><Leader>p :.!python<CR>
    vnoremap <Leader><Leader>p :!python<CR>
    nnoremap <Leader><Leader>v 0"xy$:@x<CR>
    vnoremap <Leader><Leader>v "xy:@x<CR>

" Change working directory
    noremap <Leader><Leader>cd :cd %:h<CR>

" Global scratch buffer
    noremap <Leader><Leader>es :edit ~/scratch<CR>

" Common sequence abbrevations
    iabbrev xaz <C-r>='abcdefghijklmnopqrstuvwxyz'<CR>
    iabbrev xAZ <C-r>='ABCDEFGHIJKLMNOPQRSTUVWXYZ'<CR>
    iabbrev x09 <C-r>='0123456789'<CR>

" Date/time abbreviations
    iabbrev <expr> xymd   strftime("%Y-%m-%d")
    iabbrev <expr> xdate  strftime("%a %d %b %Y")
    iabbrev <expr> xtime  strftime("%I:%M %p")
    iabbrev <expr> xmtime strftime("%H:%M")
    iabbrev <expr> xiso   strftime("%Y-%m-%dT%H:%M:%S")

" Local vimrc
    if !empty(glob('~/local.vimrc'))
        source ~/local.vimrc
    end
