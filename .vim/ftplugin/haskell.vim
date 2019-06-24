setlocal tabstop=2 softtabstop=2 shiftwidth=2
setlocal textwidth=80
setlocal colorcolumn=121

" Wrap with language extension pragma, with proper capitalization
let g:surround_108 = "{-# lAnGuAgE \r #-}"

" Change long (function application) to long $ function application
nnoremap <buffer> <Leader>$ :normal dsbi$<Space><CR>
" Add identifier under cursor to existing import list
nnoremap <buffer> <Leader>hi :let wv=winsaveview()<CR>yiwgg/module/;/where/;?)?<CR>O,<Space><C-r>"<Esc>:call winrestview(wv)<CR>j
" Split (Constraint) => Type -> Type across multiple lines:
" func :: (Constraint)
"   => Type
"   -> Type
nnoremap <Leader>xw :s/\zs<Space>\ze[=-]><Space>/\r<Space><Space>/g<CR>
