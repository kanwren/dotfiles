" This is my bare minimum vim configuration, with sensible settings and a small
" number of core mappings for comfort. This is just about as portable as
" possible, primarily for remote curling.

set nocompatible
set encoding=utf-8
scriptencoding utf-8
set ffs=unix,dos,mac
if !syntax_on
    syntax on
end

let $LANG='en'
set nospell spelllang=en_us

" Uncomment if backups are okay
" set backup writebackup backupdir=~/.vim/backup
" set swapfile directory^=~/.vim/tmp
" if has('persistent_undo')
"     set undofile undodir=~/.vim/undo
" endif

set hidden autoread noconfirm
set noerrorbells visualbell t_vb=
set lazyredraw
set number relativenumber
set splitbelow splitright
set cmdheight=1 showcmd
set laststatus=2 showmode statusline=[%n]\ %F%<\ \ \ %m%y%h%w%r\ \ %(0x%B\ %b%)%=%(col\ %c%)\ \ \ \ %(%l\ /\ %L%)\ \ \ \ %p%%%(\ %)
set wildmenu wildmode=longest:list,full

set virtualedit=all
set nojoinspaces
set backspace=indent,eol,start
set whichwrap+=h,l,[,]
set nrformats=bin,hex
set autoindent smartindent
set tabstop=4 expandtab softtabstop=4 smarttab shiftwidth=4 noshiftround
set cinoptions+=:0L0g0j1J1
set nowrap textwidth=80 formatoptions=croqjln

set magic
set noignorecase smartcase
set showmatch
set incsearch
if &t_Co > 2 || has("gui_running")
    set hlsearch
endif

set timeout timeoutlen=3000 ttimeout ttimeoutlen=0

if has('autocmd')
    augroup general_group
        autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |     exe "normal! g'\"" | endif
    augroup END
end

" All of these mappings override default behavior in very minor ways
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap Q @q
vnoremap Q :norm @q<CR>
vnoremap . :norm .<CR>
noremap Y y$
noremap ' `
noremap ` '
nnoremap & :&&<CR>
noremap <C-l> :nohlsearch<CR><C-l>
vnoremap gs :s/\%V
vnoremap gx <Esc>`.``gvP``P

" Leader mappings
" map <Space> <nop>
" map <S-Space> <Space>
" let mapleader=" "
" noremap <Leader>t :new<CR>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile<CR>

