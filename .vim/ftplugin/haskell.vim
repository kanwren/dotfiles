setlocal tabstop=2 softtabstop=2 shiftwidth=2
setlocal textwidth=80
setlocal colorcolumn=81,121

let g:surround_76 = "{-# language \r #-}"

nnoremap <buffer> <Leader>$ :normal dsbi$<Space><CR>
nnoremap <buffer> <Leader>hi :let wv=winsaveview()<CR>yiwgg/module/;/where/;?)?<CR>O,<Space><C-r>"<Esc>:call winrestview(wv)<CR>j
