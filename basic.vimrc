" A stripped-down version of my .vimrc that has no plugins or plugin-specific
" mappings. The intention is that this can be used anywhere, independently,
" without anything besides vim, while still giving me a comfortable editing
" experience. For a very minimal vimrc, see bare.vimrc

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

" Backups
    set backup writebackup backupdir=~/.vim/backup
    set swapfile directory^=~/.vim/tmp
    if has('persistent_undo')
        set undofile undodir=~/.vim/undo
    endif

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
    set splitbelow splitright
    set number relativenumber
    set list listchars=tab:>-,eol:¬,extends:>,precedes:<
    set nocursorline nocursorcolumn
    set laststatus=2 showmode statusline=[%n]\ %F%<\ \ \ %m%y%h%w%r\ \ %(0x%B\ %b%)%=%(col\ %c%)\ \ \ \ %(%l\ /\ %L%)\ \ \ \ %p%%%(\ %)
    set cmdheight=1 showcmd
    set wildmenu wildmode=longest:list,full

" Editing
    set virtualedit=all
    set nojoinspaces
    set backspace=indent,eol,start
    set whichwrap+=<,>,h,l,[,]
    set nrformats=bin,hex
    set cpoptions+=y

" Indentation
    set autoindent smartindent
    set tabstop=4 expandtab softtabstop=4 smarttab shiftwidth=4 noshiftround
    set cinoptions+=:0L0g0j1J1

" Formatting
    set nowrap
    set textwidth=80
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

" Sudo write trick
    command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!

" JSON utilities
    command! -range JT <line1>,<line2>!python3 -mjson.tool
    command! -range JY <line1>,<line2>!python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'
    command! -range YJ <line1>,<line2>!python3 -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout)'

" Functions
    function! ExpandSpaces()
        let [start, startv] = getpos("'<")[2:3]
        let [end, endv]     = getpos("'>")[2:3]
        let cols = abs(end + endv - start - startv) + 1
        execute 'normal gv' . cols . 'I '
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
    noremap <Leader>t :new<CR>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile<CR>
    vnoremap gs :s/\%V
    noremap <C-l> :nohlsearch<CR><C-l>

" Editing
    nnoremap <silent> <Leader>; :let wv=winsaveview()<CR>:s/[^;]*\zs\ze\s*$/;/e \| nohlsearch<CR>:call winrestview(wv)<CR>
    vnoremap <silent> <Leader>; :let wv=winsaveview()<CR>:s/\v(\s*$)(;)@<!/;/g \| nohlsearch<CR>:call winrestview(wv)<CR>
    vnoremap gx <Esc>`.``gvP``P
    nnoremap <silent> <expr> <Leader>s ':s/' . input('split/') . '/\r/g \| nohlsearch<CR>'
    vnoremap <silent> <Leader>vs :sort /\ze\%V/<CR>gvyugvpgv:s/\s\+$//e \| nohlsearch<CR>``

" Whitespace
    noremap <Leader><Tab> m`:%s/\s\+$//e \| call histdel("/", -1) \| nohlsearch \| retab<CR>``
    nnoremap <silent> <C-j> :<C-u>call append(line("."), repeat([''], v:count1))<CR>
    nnoremap <silent> <C-k> :<C-u>call append(line(".") - 1, repeat([''], v:count1))<CR>
    vnoremap <silent> <C-j> :<C-u>call append(line("'>"), repeat([''], v:count1))<CR>gv
    vnoremap <silent> <C-k> :<C-u>call append(line("'<") - 1, repeat([''], v:count1))<CR>gv
    vnoremap <Leader>e <Esc>:call ExpandSpaces()<CR>

" Convenience
    noremap <Leader>d "_d
    noremap <Leader>D "_D
    noremap <Leader>p "0p
    noremap <Leader>P "0P

" Registers
    noremap <silent> "" :registers<CR>
    noremap <silent> <Leader>r :let r1 = substitute(nr2char(getchar()), "'", "\"", "") \| let r2 = substitute(nr2char(getchar()), "'", "\"", "")
          \ \| execute 'let @' . r2 . '=@' . r1 \| echo "Copied @" . r1 . " to @" . r2<CR>

" Navigation
    noremap <Leader>b :ls<CR>:b
    nnoremap <Leader>* :let wv=winsaveview()<CR>*:call winrestview(wv)<CR>
    vnoremap <Leader>* :let wv=winsaveview()<CR>y/<C-r>"<CR>:call winrestview(wv)<CR>
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
    noremap <Leader><Leader>ef :edit ~/.vim/ftplugin/<C-r>=&filetype<CR>.vim<CR>
    noremap <Leader>i :let i=input('ts=sts=sw=') \| if i \| execute 'setlocal tabstop=' . i . ' softtabstop=' . i . ' shiftwidth=' . i \| endif
                \ \| redraw \| echo 'ts=' . &tabstop . ', sts=' . &softtabstop . ', sw='  . &shiftwidth . ', et='  . &expandtab<CR>
    noremap ]oc :set colorcolumn=+1<CR>
    noremap [oc :set colorcolumn=<CR>
    noremap ]ot :set textwidth=120<CR>
    noremap [ot :set textwidth=80<CR>

" Misc
    noremap <Leader><Leader>es :edit ~/scratch<CR>
    noremap <Leader><Leader>cd :cd %:h<CR>

" Local vimrc
    if !empty(glob('~/local.vimrc'))
        source ~/local.vimrc
    end

