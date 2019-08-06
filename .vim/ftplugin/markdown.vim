setlocal formatoptions=croqjlnt

" Compile to PDF
nnoremap <F2> :w \| !cd %:h && pandoc -s %:t --pdf-engine=pdflatex -o %:t:r.pdf<CR>
" View compiled PDF
nnoremap <F3> :!zathura %<.pdf &<CR><CR>

