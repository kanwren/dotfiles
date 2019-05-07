setlocal foldmethod=syntax
setlocal makeprg=javac\ %
setlocal errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

iabbrev sout System.out.println()<Esc>
iabbrev serr System.err.println()<Esc>

" S wraps in System.out.println()
let b:surround_83 = "System.out.println(\r)"

" Compile and run
noremap <buffer> <F8> :execute '!java %'<CR>
" Compile and open error window
noremap <buffer> <F9> :make \| copen<CR><C-w>w
" Just run
noremap <buffer> <F10> :execute '!java %<'<CR>
