let g:lc3_docker_target = '/cs2110/src'

" Copy all .asm files in the same directory as the current file to the docker
" target directory
function! DockerCpAsms() abort
    let cont_hex = trim(system('docker ps -q | head -n1'))
    echo 'Using container ' . cont_hex
    let asm_files = glob('%:h/*.asm', 0, 1)
    if empty(asm_files)
        echoerr 'Error: no .asm files in ' . expand('%:h')
    endif
    for f in asm_files
        echo 'Copying ' . f . ' to ' . g:lc3_docker_target . '...'
        call system('docker cp '. f . ' ' . cont_hex . ':' . g:lc3_docker_target)
    endfor
    echo 'Done'
endfunction

nnoremap <buffer> <silent> <F2> :call DockerCpAsms()<CR>

function! CapitalizeInsts() abort
    %s/\v<(add|ld|st|jsrr|jsr|and|ldr|str|rti|not|ldi|sti|jmp|ret|lea|trap|br|brn|brz|brp|brnz|brnp|brzp|brnzp|getc|out|puts|in|putsp|halt|ldb|ldw|lshf|rshfl|rshfa|stb|stw|xor)>/\U&/g
endfunction
