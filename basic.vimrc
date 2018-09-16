set nocompatible

set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase'  | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

autocmd FileType help wincmd L
syntax on
filetype on
filetype indent on
filetype plugin on

color default

set lazyredraw

set swapfile
set backup
set writebackup
set backupdir=~/.vim/backup
set directory^=~/.vim/tmp

set autoread
set noconfirm
set hidden
set history=50

set laststatus=2
set statusline=buf\ %n:\ \"%F\"%<\ \ \ %m%y%h%w%r%=%(col\ %c%)\ \ \ \ \ \ %(%l\ /\ %L%)\ \ \ \ \ \ %p%%

set wildmenu
set wildmode=longest:list,full

set cmdheight=1
set showcmd
set showmode

set noerrorbells novisualbell

set number relativenumber
set lines=51

set showmatch
set incsearch hlsearch
set smartcase

set nojoinspaces
set ve=block
set nospell spelllang=en_us
set splitbelow splitright
set nowrap
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]

set timeout timeoutlen=500

set ttyfast
set scrolloff=0

set list listchars=tab:>-,eol:~,extends:>,precedes:<
set modelines=0
set foldmethod=manual
set foldcolumn=1
set textwidth=80
set formatoptions=croqln1

set autoindent smartindent
set tabstop=4
set cinoptions+=:0
set expandtab softtabstop=4 shiftwidth=4
set smarttab
set noshiftround

nnoremap <Tab> :retab<CR>mz:%s/\s\+$//ge<CR>`z
nnoremap Y y$
inoremap jk <ESC>
inoremap kj <ESC>
nnoremap Q @q
map <Space> \
nmap <S-Space> <Space>

highlight FoldColumn ctermbg=1
highlight Folded ctermbg=1
highlight ColorColumn ctermbg=1
set colorcolumn=81
call matchadd('ColorColumn', '\%81v\S', 100)
highlight ExtraWhitespace ctermbg=3
match ExtraWhitespace /\s\+$/
highlight CursorLineNr ctermbg=1 ctermfg=7
