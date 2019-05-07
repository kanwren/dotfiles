setlocal formatoptions+=t
noremap  <buffer> <F9> :w \| ! pdflatex %<CR><CR>
inoremap <buffer> <F9> <Esc>:w \| ! pdflatex %<CR><CR>gi
noremap  <buffer> <F10> :! mupdf %<.pdf<CR><CR>
