set textwidth=80
" Automatically wrap at textwidth
setlocal formatoptions+=t

" Compile
noremap <buffer> <leader>c :w \| !pdflatex %<CR><CR>
" View PDF
noremap <buffer> <C-p> :! zathura %<.pdf &<CR><CR>

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

let b:turkish_mappings = 0

function! ToggleTurkish()
    if b:turkish_mappings == 0
        inoremap <buffer> i. ı
        inoremap <buffer> I. İ
        inoremap <buffer> s, ş
        inoremap <buffer> S, Ş
        inoremap <buffer> c, ç
        inoremap <buffer> C, Ç
        inoremap <buffer> o; ö
        inoremap <buffer> O; Ö
        inoremap <buffer> u; ü
        inoremap <buffer> U; Ü
        inoremap <buffer> g, ǧ
        let b:turkish_mappings = 1
    else
        iunmap <buffer> i.
        iunmap <buffer> I.
        iunmap <buffer> s,
        iunmap <buffer> S,
        iunmap <buffer> c,
        iunmap <buffer> C,
        iunmap <buffer> o;
        iunmap <buffer> O;
        iunmap <buffer> u;
        iunmap <buffer> U;
        iunmap <buffer> g,
        let b:turkish_mappings = 0
    endif
endfunction

noremap <Leader>q :call ToggleTurkish()<CR>

