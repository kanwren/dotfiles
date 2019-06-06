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
    set noignorecase smartcase
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
    set colorcolumn=+1
    highlight ColorColumn ctermbg=8
    highlight Todo ctermbg=1 ctermfg=15

" Leader configuration
    map <Space> <nop>
    map <S-Space> <Space>
    let mapleader=" "

" Sudo write trick
    command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Functions
    function! SetIndents()
        let i = input('ts=sts=sw=')
        if i
            execute 'setlocal tabstop=' . i . ' softtabstop=' . i . ' shiftwidth=' . i
        endif
        echo 'ts=' . &tabstop . ', sts=' . &softtabstop . ', sw='  . &shiftwidth . ', et='  . &expandtab
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

" Leader configuration
    map <Space> <nop>
    map <S-Space> <Space>
    let mapleader=" "

" Essential
    noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
    noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
    nnoremap Q @q
    vnoremap Q :norm @q<CR>
    vnoremap . :norm .<CR>
    noremap Y y$
    noremap ' `
    noremap ` '
    nnoremap & :&&<CR>
    nnoremap gs :%s/\v
    vnoremap gs :s/\%V\v
    noremap <C-l> :nohlsearch<CR><C-l>

" Editing
    nnoremap <Leader>; mx:s/[^;]*\zs\ze\s*$/;/e \| nohlsearch<CR>`x
    vnoremap <Leader>; :s/\v(\s*$)(;)@<!/;/g<CR>
    vnoremap gx <Esc>`.``gvP``P
    nnoremap <silent> <expr> <Leader>s ':s/' . input('split/') . '/\r/g \| nohlsearch<CR>'
    vnoremap <silent> <Leader>vs :sort /\ze\%V/<CR>gvyugvpgv:s/\s\+$//e \| nohlsearch<CR>``

" Whitespace
    nnoremap <silent> <Leader>o :<C-u>call append(line("."), repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>j<CR>
    nnoremap <silent> <Leader>O :<C-u>call append(line(".") - 1, repeat([''], v:count1)) \| norm <C-r>=v:count1<CR>k<CR>
    nnoremap <silent> <Leader>n :<C-u>call append(line('.'), repeat([''], v:count1)) \| call append(line('.') - 1, repeat([''], v:count1))<CR>
    vnoremap <silent> <Leader>n <Esc>:call append(line("'>"), '') \| call append(line("'<") - 1, '')<CR>
    vnoremap <Leader>e <Esc>:call ExpandSpaces()<CR>
    noremap <Leader><Tab> mx:%s/\s\+$//e \| nohlsearch \| retab<CR>`x

" Convenience
    noremap <Leader>d "_d
    noremap <Leader>D "_D
    noremap <Leader>p "0p
    noremap <Leader>P "0P

" Registers
    noremap <silent> "" :registers<CR>
    noremap <silent> <Leader>r :call CopyRegister()<CR>

" Navigation
    noremap <Leader>b :ls<CR>:b
    nnoremap <Leader>* mx*`x
    vnoremap <Leader>* mxy/<C-r>"<CR>`x
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

" Quick settings changes
    noremap <Leader><Leader>ev :edit $MYVIMRC<CR>
    noremap <Leader><Leader>sv :source $MYVIMRC<CR>
    noremap <expr> <Leader><Leader>i SetIndents()
    noremap ]oc :set colorcolumn=+1<CR>
    noremap [oc :set colorcolumn=<CR>
    noremap ]ot :set textwidth=120<CR>
    noremap [ot :set textwidth=80<CR>

" Inline execution
    nnoremap <Leader><Leader>v 0"xy$:@x<CR>
    vnoremap <Leader><Leader>v "xy:@x<CR>

" Misc
    noremap <Leader><Leader>cd :cd %:h<CR>

" Plugin setup
    command! PlugSetup call PlugSetup()
    function! PlugSetup()
        let plug_loc = '~/.vim/autoload/plug.vim'
        let plug_source = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        if empty(glob(plug_location))
            echom 'vim-plug not found. Installing...'
            if executable('curl')
                silent exec '!curl -fLo curl -fLo ' . expand(plug_loc) . ' --create-dirs ' . plug_source
            elseif executable('wget')
                call mkdir(fnamemodify(s:plugin_loc, ':h'), 'p')
                silent exec '!wget --force-directories --no-check-certificate -O ' . expand(plug_loc) . ' ' . plug_source
            else
                echom 'Error: could not download vim-plug'
            endif
        endif
    endfunction

    " call plug#begin('~/.vim/bundle')
        " Plug 'tpope/vim-surround'
    " call plug#end()

" Local vimrc
    if !empty(glob('~/local.vimrc'))
        source ~/local.vimrc
    end

