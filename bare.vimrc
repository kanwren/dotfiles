" This is my bare minimum vim configuration, with sensible settings and a small
" number of core mappings for comfort. This is just about as portable as
" possible, primarily for remote curling. However, there are still sections
" for expanding if necessary.

set encoding=utf-8
scriptencoding utf-8
set ffs=unix,dos,mac
if !syntax_on
    syntax on
end
filetype plugin indent on

" Uncomment if backups are okay
" set backup writebackup backupdir=~/.vim/backup
" set swapfile directory^=~/.vim/tmp
" if has('persistent_undo')
"     set undofile undodir=~/.vim/undo
" endif

let $LANG='en'
set nospell spelllang=en_us

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
set cpoptions+=y
set autoindent
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
        autocmd!
        autocmd FileType help wincmd L
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    augroup END
    augroup highlight_group
        autocmd!
    augroup END
end

" Warning: all of these mappings override default behavior
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap Q @q
xnoremap Q :norm @q<CR>
xnoremap . :norm .<CR>
noremap Y y$
noremap ' `
noremap ` '
nnoremap & :&&<CR>
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
xnoremap gx <Esc>`.``gvP``P

" Leader mappings
" map <Space> <nop>
" map <S-Space> <Space>
" let mapleader=" "
" nnoremap <Leader><Tab> :let wv=winsaveview()<CR>:%s/\s\+$//e \| call histdel("/", -1) \| nohlsearch \| retab<CR>:call winrestview(wv)<CR>
" nnoremap <Leader>t :new<CR>:setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile<CR>
" nnoremap <silent> <expr> <Leader>s ':s/' . input('split/') . '/\r/g \| nohlsearch<CR>'
" nnoremap <silent> <expr> <Leader>a ":let p = input('tab/') \| execute ':Tabularize' . (empty(p) ? '' : ' /' . p)<CR>"

