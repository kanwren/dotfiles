setlocal foldmethod=syntax
setlocal makeprg=javac\ %
setlocal errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

function! Eatspace()
    let c = nr2char(getchar(0))
    return c =~ '\s' ? '' : c
endfunction

" Trigger these by pressing tab (auto-pairs messes with a normal space)
iabbrev sout System.out.println();<Left><Left><C-r>=Eatspace()<CR>
iabbrev serr System.err.println();<Left><Left><C-r>=Eatspace()<CR>
" Note: relies on auto-pairs
iabbrev psvm public static void main(String[] args) {<CR><C-r>=Eatspace()<CR>

" S wraps in System.out.println()
let b:surround_83 = "System.out.println(\r)"

" Compile and run
noremap <buffer> <F8> :execute '!java %'<CR>
" Compile and open error window
noremap <buffer> <F9> :make \| copen<CR><C-w>w
" Just run
noremap <buffer> <F10> :execute '!java %<'<CR>

" Getters/setters
function! MkGetter(type_name, var_name)
    let type_name = trim(a:type_name)
    let var_name = trim(a:var_name)
    if empty(type_name)
        echoerr 'Error: empty type name'
        return
    endif
    if empty(var_name)
        echoerr 'Error: empty var name'
        return
    endif
    let firstupper = toupper(var_name[0]) . var_name[1:]
    echo firstupper
    let lines = [
                \ '    public ' . type_name . ' get' .  firstupper . '() {',
                \ '        return ' . var_name . ';',
                \ '    }'
                \ ]
    return lines
endfunction

function! MkSetter(type_name, var_name)
    let type_name = trim(a:type_name)
    let var_name = trim(a:var_name)
    if empty(type_name)
        echoerr 'Error: empty type name'
        echo type_name
        return
    endif
    if empty(var_name)
        echoerr 'Error: empty var name'
        return
    endif
    let firstupper = toupper(var_name[0]) . var_name[1:]
    let lines = [
                \ '    public void set' .  firstupper . '(' . type_name . ' ' . var_name . ') {',
                \ '        this.' . var_name . ' = ' . var_name . ';',
                \ '    }'
                \ ]
    return lines
endfunction

function! MkGetterSetter(type_name, var_name)
    let g = MkGetter(a:type_name, a:var_name)
    let s = MkSetter(a:type_name, a:var_name)
    return g + [''] + s
endfunction

" TODO: auto-generation
let b:java_type_re = '\u\w*\|int\|boolean\|double\|char\|long\|short\|float'

nnoremap <buffer> <expr> <Leader>jg ":call append(line('.'), MkGetter(input('Type name: '), input('Variable name: ')))<CR>"
nnoremap <buffer> <expr> <Leader>js ":call append(line('.'), MkSetter(input('Type name: '), input('Variable name: ')))<CR>"
nnoremap <buffer> <expr> <Leader>jb ":call append(line('.'), MkGetterSetter(input('Type name: '), input('Variable name: ')))<CR>"
