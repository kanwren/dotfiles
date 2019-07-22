" This is a pretty minimal vim configuration, with sensible settings and a
" (relatively) small number of core mappings for comfort, as well as some of my
" most common leader mappings.

set encoding=utf-8
scriptencoding utf-8
set ffs=unix,dos,mac
if !syntax_on | syntax on | end
filetype plugin indent on

" Uncomment if backups are okay
" set backup writebackup backupdir=~/.vim/backup
" set swapfile directory^=~/.vim/tmp
" if has('persistent_undo')
"     set undofile undodir=~/.vim/undo
" endif

let $LANG='en'
set nospell spelllang=en_us
set history=1000 undolevels=1000

set hidden autoread noconfirm
set noerrorbells visualbell t_vb=
set lazyredraw
set number relativenumber
set splitbelow splitright
set cmdheight=1 showcmd
set laststatus=2 showmode statusline=[%n]\ %F%<\ %m%y%h%w%r\ \ %(0x%B\ %b%)%=%p%%\ \ %(%l/%L%)%(\ \|\ %c%V%)%(\ %)
set wildmenu wildmode=longest:list,full
set list listchars=tab:>-,eol:¬,extends:>,precedes:<

set virtualedit=all
set nojoinspaces
set backspace=indent,eol,start
set whichwrap+=h,l,[,]
set nrformats=bin,hex
set cpoptions+=y
set autoindent
set tabstop=4 expandtab softtabstop=4 smarttab shiftwidth=4 noshiftround
set cinoptions+=:0L0g0j1J1
set nowrap textwidth=80 formatoptions=croqjln
set magic
set noignorecase smartcase
set showmatch
set incsearch
if &t_Co > 2 || has("gui_running") | set hlsearch | endif
" set foldenable foldmethod=manual foldcolumn=1 foldlevelstart=99

set timeout timeoutlen=3000 ttimeout ttimeoutlen=0

if has('autocmd')
    augroup general_group
        autocmd!
        autocmd FileType help wincmd L
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
        autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
        autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
        autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    augroup END
    augroup highlight_group
        autocmd!
        autocmd ColorScheme * highlight ExtraWhitespace ctermbg=12
                          \ | highlight ColorColumn ctermbg=8
                          \ | highlight StatusLine ctermfg=0 ctermbg=15
                          \ | highlight StatusLineNC ctermfg=0 ctermbg=7
                          \ | highlight VertSplit ctermfg=0
                          \ | highlight FoldColumn ctermbg=NONE
                          \ | highlight Folded ctermbg=NONE
                          \ | highlight CursorLineNr ctermbg=4 ctermfg=15
    augroup END
end

" Basic commands
command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!
command! CD :cd %:h
command! -bar -range=% Reverse <line1>,<line2>g/^/m<line1>-1 | nohlsearch

" Basic mappings
" Warning: all of these mappings override default behavior in some way
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap Q @q
xnoremap <silent> Q :g/^/normal! @q<CR>:call histdel("/", -1) \| nohlsearch<CR>
xnoremap <silent> . :g/^/normal! .<CR>:call histdel("/", -1) \| nohlsearch<CR>
noremap Y y$
noremap ' `
noremap ` '
nnoremap & :&&<CR>
xnoremap gx <Esc>`.``gvP``P
nnoremap <silent> * :let wv=winsaveview()<CR>*:call winrestview(wv)<CR>
nnoremap <silent> "" :registers<CR>
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" Leader mappings
map <Space> <nop>
map <S-Space> <Space>
let mapleader=" "
nnoremap <Leader><Tab> :let wv=winsaveview()<CR>:%s/\s\+$//e \| call histdel("/", -1) \| nohlsearch \| retab<CR>:call winrestview(wv)<CR>
nnoremap <silent> <expr> <Leader>s ':s/' . input('split/') . '/\r/g \| nohlsearch<CR>'
vnoremap <silent> <Leader>vs :sort /\ze\%V/<CR>gvyugvpgv:s/\s\+$//e \| nohlsearch<CR>``
nnoremap <Leader>t :new<CR>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile<CR>
vnoremap <Leader>e <Esc>:execute 'normal gv' . (abs(getpos("'>")[2] + getpos("'>")[3] - getpos("'<")[2] - getpos("'<")[3]) + 1) . 'I '<CR>
nnoremap <Leader><Leader>es :edit ~/scratch<CR>
nnoremap <Leader>i :let i=input('ts=sts=sw=') \| if i \| execute 'setlocal tabstop=' . i . ' softtabstop=' . i . ' shiftwidth=' . i \| endif
            \ \| redraw \| echo 'ts=' . &tabstop . ', sts=' . &softtabstop . ', sw='  . &shiftwidth . ', et='  . &expandtab<CR>
nnoremap <silent> <Leader>r :let r1 = substitute(nr2char(getchar()), "'", "\"", "") \| let r2 = substitute(nr2char(getchar()), "'", "\"", "")
      \ \| execute 'let @' . r2 . '=@' . r1 \| echo "Copied @" . r1 . " to @" . r2<CR>

" Reasonable colorscheme
colorscheme elflord

" Local vimrc
if !empty(glob('~/local.vimrc'))
    source ~/local.vimrc
end
