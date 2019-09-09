setlocal tabstop=2 softtabstop=2 shiftwidth=2

command! FixCabal :%s/^\(\s*\)\(.\(cabal-version\)\@<!\)\{-,}:\zs\s\+/\r\1  /g | %s/cabal-version: \zs \+//

