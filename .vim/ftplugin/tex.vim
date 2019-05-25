" Automatically wrap at textwidth
setlocal formatoptions+=t

" Compile
noremap <buffer> <leader>c :w \| !pdflatex %<CR><CR>
" View PDF
noremap <buffer> <C-p> :! zathura %<.pdf<CR><CR>

" function! Eatchar(pat)
"   let c = nr2char(getchar(0))
"   return (c =~ a:pat) ? '' : c
" endfunction

" These could also be abbreviations, but the space consumption doesn't quite
" work and the delay isn't that annoying
inoremap <buffer> ,it \textit{}<Left>
inoremap <buffer> ,bf \textbf{}<Left>
inoremap <buffer> ,tt \texttt{}<Left>
inoremap <buffer> ,ul \underline{}<Left>
inoremap <buffer> ,em \emph{}<Left>
inoremap <buffer> ,bb \mathbb{}<Left>
inoremap <buffer> ,tu \textsuperscript{}<Left>
inoremap <buffer> ,td \textsubscript{}<Left>
inoremap <buffer> ,mb \{\}<Left>

