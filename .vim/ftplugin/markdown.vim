setlocal formatoptions=croqjlnt

" View as PDF in zathura through pandoc
noremap <Leader>v :!pandoc -s % --pdf-engine=pdflatex -t latex \| zathura -<CR><CR>
" Compile to PDF
noremap <Leader>c :!pandoc -s % --pdf-engine=pdflatex -o %<.pdf<CR>
" View compiled PDF
noremap <C-p> :!zathura %<.pdf &<CR><CR>

