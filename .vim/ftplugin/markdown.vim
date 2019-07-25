setlocal formatoptions=croqjlnt

" Compile to PDF
nnoremap <F2> :w \| !cd %:h && pandoc -s %:t --pdf-engine=pdflatex -o %:t:r.pdf<CR>
" View compiled PDF
nnoremap <F3> :!zathura %<.pdf &<CR><CR>
" View as PDF in zathura through pandoc
"noremap <F3> :!pandoc -s % --pdf-engine=pdflatex -t latex \| zathura -<CR><CR>

