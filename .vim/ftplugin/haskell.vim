setlocal tabstop=2 softtabstop=2 shiftwidth=2

let g:surround_76 = "{-# language \r #-}"

nmap <Leader>cr :!cabal new-repl<CR>
nmap <Leader>cb :!cabal new-build<CR>
nmap <Leader>ce :e *.cabal<CR>
