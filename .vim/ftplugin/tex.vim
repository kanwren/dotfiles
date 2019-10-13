setlocal makeprg=cd\ %:h\ &&\ pdflatex\ %:t

set textwidth=80
" Automatically wrap at textwidth
setlocal formatoptions+=t

" Compile
nnoremap <buffer> <F2> :w \| !cd %:h && pdflatex %:t<CR><CR>
" View PDF
nnoremap <buffer> <F3> :! mupdf %<.pdf &<CR><CR>

" Use "m" to surround with \[\]
let b:surround_109 = "\\[ \r \\]"

" These could also be abbreviations, but the space consumption doesn't quite
" work and the delay isn't that annoying
inoremap <buffer> ,it \textit{}<Left>
inoremap <buffer> ,bf \textbf{}<Left>
inoremap <buffer> ,tt \texttt{}<Left>
inoremap <buffer> ,ul \underline{}<Left>
inoremap <buffer> ,em \emph{}<Left>
inoremap <buffer> ,tu \textsuperscript{}<Left>
inoremap <buffer> ,td \textsubscript{}<Left>
inoremap <buffer> ,{ \left\{\right\}<Esc>F{a
inoremap <buffer> ,} \{\}<Esc>F{a
inoremap <buffer> ,< \langle\rangle<Esc>F\i
inoremap <buffer> ,( \left(\right)<Esc>F\i
inoremap <buffer> ,[ \left[\right]<Esc>F\i

