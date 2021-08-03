" Basic settings
scriptencoding utf-8
set ffs=unix

" These are pretty likely to break on minimal vim installations
set encoding=utf-8
filetype plugin indent on
if has('syntax') && (!exists('syntax_on') || !syntax_on)
    syntax on
endif

" Backups
" set swapfile directory=~/.vim/tmp//
" set backup writebackup backupcopy=auto
" if has("patch-8.1.0251")
"     set backupdir=~/.vim/backup//
" else
"     set backupdir=~/.vim/backup
" endif
" if has('persistent_undo')
"     set undofile undodir=~/.vim/undo//
"     if !isdirectory(&undodir) | call mkdir(&undodir, 'p') | endif
" endif
" for d in [&directory, &backupdir]
"     if !isdirectory(d) | call mkdir(d, 'p') | endif
" endfor

" Buffers
set hidden
set autoread
set noconfirm

" Disable annoying flashing/beeping
set noerrorbells
set visualbell t_vb=

" Navigation
set mouse-=a
set scrolloff=0

" Display
set lazyredraw
set shortmess+=I
set splitbelow splitright
set number relativenumber
set list listchars=tab:>-,extends:>,precedes:<
set laststatus=2
set statusline=[%n]\ %f%<\ %m%y%h%w%r\ \ %(0x%B\ %b%)%=%p%%\ \ %(%l/%L%)%(\ \|\ %c%V%)%(\ %)
set showmode
set cmdheight=1
set showcmd
set wildmenu
set wildmode=longest:list,full
" set signcolumn=yes

" set foldenable
" set foldcolumn=1
" set foldlevelstart=99
" set foldmethod=manual

" Editing
set virtualedit=all
set nojoinspaces
set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]
set nrformats=bin,hex
set cpoptions+=y

" Attempt to set up a clipboard
if has('clipboard')
    set clipboard=unnamed
    if has('unnamedplus')
        set clipboard+=unnamedplus
    endif
endif

" Indentation settings
set autoindent
set tabstop=4
set expandtab softtabstop=4
set shiftwidth=4
set smarttab
set noshiftround
set cinoptions+=:0L0g0j1J1

" Text formatting
set nowrap
set textwidth=80
set formatoptions=croqjln
set colorcolumn=+1

" Searching and case sensitivity
set magic
set noignorecase smartcase
set showmatch
set incsearch
if &t_Co > 2 || has("gui_running") | set hlsearch | endif

" Timeouts
set timeout timeoutlen=3000
set ttimeout ttimeoutlen=0

if has('autocmd')
    augroup general_group
        autocmd!
        " Open help window on right by default
        autocmd FileType help wincmd L
        " Return to last edit position when opening files
        autocmd BufReadPost *
                    \   if line("'\"") > 1 && line("'\"") <= line("$")
                    \ |     execute "normal! g`\""
                    \ | endif
        " Highlight trailing whitespace (except when typing at end of line)
        autocmd BufRead     * match ExtraWhitespace /\s\+$/
        autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
        autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
        autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    augroup END
    augroup highlight_group
        autocmd!
        autocmd ColorScheme * highlight ExtraWhitespace ctermbg=DarkBlue guibg=#1f75fe
        autocmd ColorScheme * highlight ColorColumn ctermbg=DarkGray guibg=#282c34
    augroup END
endif

noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap Q @q
xnoremap <silent> Q :normal @q<CR>
xnoremap <silent> . :normal .<CR>
xnoremap gx <Esc>`.``gvP``P
nnoremap gs :s//\r/g<Left><Left><Left><Left><Left>
xnoremap gs :s/\%V
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
nnoremap <silent> * :let wv=winsaveview()<CR>*:call winrestview(wv)<CR>
nnoremap <silent> # :let wv=winsaveview()<CR>#:call winrestview(wv)<CR>

" Leader mappings
map <Space> <nop>
map <S-Space> <Space>
let mapleader=" "

nnoremap <Leader><Tab> :%s/\s\+$//e \| nohlsearch \| retab<CR>

" Decent default colorscheme
colorscheme elflord

runtime macros/matchit.vim
silent! if !empty(glob('~/.vim/autoload/plug.vim')) && !empty(glob('~/.vim/plugged')) && plug#begin(glob('~/.vim/plugged'))
    Plug 'tpope/vim-surround'
    Plug 'mg979/vim-visual-multi'
    call plug#end()

    let g:VM_leader = '\'
    nmap <C-j> <Plug>(VM-Add-Cursor-Down)
    nmap <C-k> <Plug>(VM-Add-Cursor-Up)
else
    function! InstallVimPlug() abort
        if executable('curl')
            let out = system('curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
        elseif executable('wget')
            let out = system('mkdir -p ~/.vim/autoload && wget -O ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
        else
            echoerr 'curl or wget are required to install vim-plug'
            return
        endif
        if v:shell_error != 0
            echoerr output
            return
        endif
        call mkdir(expand('~/.vim/plugged'), 'p')
        echo "Installation completed"
    endfunction
    command! InstallVimPlug :call InstallVimPlug()
endif

