" A stripped-down version of my .vimrc that has no plugins or plugin-specific
" mappings. The intention is that this can be used anywhere, independently,
" without anything besides vim, while still giving me a comfortable editing
" experience. For a very minimal vimrc, see bare.vimrc

" Basic
    set encoding=utf-8
    scriptencoding utf-8
    set ffs=unix,dos,mac
    if !syntax_on
        syntax on
    end
    filetype plugin indent on

" Backups
    set backup writebackup backupdir=~/.vim/backup
    set swapfile directory^=~/.vim/tmp
    if has('persistent_undo')
        set undofile undodir=~/.vim/undo
    endif

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
    set autoindent
    set tabstop=4 expandtab softtabstop=4 smarttab shiftwidth=4 noshiftround
    set cinoptions+=:0L0g0j1J1

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
    set timeout timeoutlen=3000
    set ttimeout ttimeoutlen=0

" Autocommands/highlighting
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
        augroup highlight_group
            autocmd!
            autocmd ColorScheme * highlight ExtraWhitespace ctermbg=12
                              \ | highlight FoldColumn ctermbg=NONE
                              \ | highlight Folded ctermbg=NONE
                              \ | highlight CursorLineNr ctermbg=4 ctermfg=15
                              \ | highlight ColorColumn ctermbg=8
                              \ | highlight Todo ctermbg=1 ctermfg=15
        augroup END
    end

" Force sudo write trick
    command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!

" JSON utilities
    command! -range JT <line1>,<line2>!python3 -mjson.tool
    command! -range JY <line1>,<line2>!python3 -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)'
    command! -range YJ <line1>,<line2>!python3 -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout)'

" Functions
    function! ExpandSpaces() abort
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
    xnoremap Q :norm @q<CR>
    xnoremap . :norm .<CR>
    noremap Y y$
    noremap ' `
    noremap ` '
    nnoremap & :&&<CR>
    nnoremap <Leader>t :new<CR>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile<CR>
    nnoremap <silent> * :let wv=winsaveview()<CR>*:call winrestview(wv)<CR>
    vnoremap <silent> * :<C-u>let wv=winsaveview()<CR>gvy/<C-r>"<CR>:call winrestview(wv)<CR>
    nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" Editing
    nnoremap <silent> <Leader>; :let wv=winsaveview()<CR>:s/[^;]*\zs\ze\s*$/;/e \| nohlsearch<CR>:call winrestview(wv)<CR>
    vnoremap <silent> <Leader>; :let wv=winsaveview()<CR>:s/\v(\s*$)(;)@<!/;/g \| nohlsearch<CR>:call winrestview(wv)<CR>
    xnoremap gx <Esc>`.``gvP``P
    nnoremap <silent> <expr> <Leader>s ':s/' . input('split/') . '/\r/g \| nohlsearch<CR>'
    vnoremap <silent> <Leader>vs :sort /\ze\%V/<CR>gvyugvpgv:s/\s\+$//e \| nohlsearch<CR>``

" Whitespace
    nnoremap <silent> <Leader><Tab> :let wv=winsaveview()<CR>:%s/\s\+$//e \| call histdel("/", -1) \| nohlsearch \| retab<CR>:call winrestview(wv)<CR>
    nnoremap <silent> <Leader>j :<C-u>call append(line("."), repeat([''], v:count1))<CR>
    nnoremap <silent> <Leader>k :<C-u>call append(line(".") - 1, repeat([''], v:count1))<CR>
    vnoremap <silent> <Leader>j :<C-u>call append(line("'>"), repeat([''], v:count1))<CR>gv
    vnoremap <silent> <Leader>k :<C-u>call append(line("'<") - 1, repeat([''], v:count1))<CR>gv
    nnoremap <silent> <Leader>n :<C-u>call append(line("."), repeat([''], v:count1)) \| call append(line(".") - 1, repeat([''], v:count1))<CR>
    vnoremap <silent> <Leader>n :<C-u>call append(line("'>"), repeat([''], v:count1)) \| call append(line("'<") - 1, repeat([''], v:count1))<CR>
    vnoremap <Leader>e <Esc>:call ExpandSpaces()<CR>

" Convenience
    nnoremap <Leader>d "_d
    nnoremap <Leader>D "_D
    nnoremap <Leader>p "0p
    nnoremap <Leader>P "0P

" Registers
    nnoremap <silent> "" :registers<CR>
    nnoremap <silent> <Leader>r :let r1 = substitute(nr2char(getchar()), "'", "\"", "") \| let r2 = substitute(nr2char(getchar()), "'", "\"", "")
          \ \| execute 'let @' . r2 . '=@' . r1 \| echo "Copied @" . r1 . " to @" . r2<CR>

" Navigation
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

" Quick settings changes
    nnoremap <Leader><Leader>ev :edit $MYVIMRC<CR>
    nnoremap <Leader><Leader>sv :source $MYVIMRC<CR>
    nnoremap <Leader><Leader>ef :edit ~/.vim/ftplugin/<C-r>=&filetype<CR>.vim<CR>
    nnoremap <Leader>i :let i=input('ts=sts=sw=') \| if i \| execute 'setlocal tabstop=' . i . ' softtabstop=' . i . ' shiftwidth=' . i \| endif
                \ \| redraw \| echo 'ts=' . &tabstop . ', sts=' . &softtabstop . ', sw='  . &shiftwidth . ', et='  . &expandtab<CR>
    nnoremap ]oc :set colorcolumn=+1<CR>
    nnoremap [oc :set colorcolumn=<CR>
    nnoremap ]ot :set textwidth=120<CR>
    nnoremap [ot :set textwidth=80<CR>

" Misc
    nnoremap <Leader><Leader>es :edit ~/scratch<CR>
    nnoremap <Leader><Leader>cd :cd %:h<CR>

" Decent colorscheme
    colorscheme elflord

" Local vimrc
    if !empty(glob('~/local.vimrc'))
        source ~/local.vimrc
    end

