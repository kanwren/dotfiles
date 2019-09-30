setlocal tabstop=2 softtabstop=2 shiftwidth=2
setlocal textwidth=80
setlocal colorcolumn=81,121

" Wrap with language extension pragma, with proper capitalization
let g:surround_108 = "{-# language \r #-}"

" Change "a (function application)" to "a $ function application"
nnoremap <buffer> <Leader>$ :normal dsbi$<Space><CR>

" Add identifier under cursor to (existing) export list
nnoremap <buffer> <Leader>HE :let wv=winsaveview()<CR>yiwgg/module/;/where/;?)?<CR>O,<Space><C-r>"<Esc>:call winrestview(wv)<CR>j

" Split (Constraint) => Type -> Type across multiple lines:
" func :: (Constraint)
"   => Type
"   -> Type
" (note: this is hacky and not very flexible)
nnoremap <Leader>HS :s/\zs<Space>\ze[=-]><Space>/\r<Space><Space>/g<CR>

" Generate hasktags
nnoremap <Leader>HT :!hasktags --ctags .<CR><CR>

let g:hs_exts = ['AllowAmbiguousTypes', 'ApplicativeDo', 'Arrows', 'BangPatterns', 'BinaryLiterals', 'BlockArguments', 'CApiFFI', 'ConstrainedClassMethods', 'ConstraintKinds', 'CPP', 'DataKinds', 'DatatypeContexts', 'DefaultSignatures', 'DeriveAnyClass', 'DeriveDataTypeable', 'DeriveFoldable', 'DeriveFunctor', 'DeriveGeneric', 'DeriveLift', 'DeriveTraversable', 'DerivingStrategies', 'DerivingVia', 'DisambiguateRecordFields', 'DuplicateRecordFields', 'EmptyCase', 'EmptyDataDecls', 'ExistentialQuantification', 'ExplicitForAll', 'ExplicitNamespaces', 'ExtendedDefaultRules', 'FlexibleContexts', 'FlexibleInstances', 'ForeignFunctionInterface', 'FunctionalDependencies', 'GADTs', 'GADTSyntax', 'GeneralizedNewtypeDeriving', 'HexFloatLiterals', 'ImplicitParams', 'ImplicitPrelude', 'ImpredicativeTypes', 'IncoherentInstances', 'InstanceSigs', 'InterruptibleFFI', 'KindSignatures', 'LambdaCase', 'LiberalTypeSynonyms', 'MagicHash', 'MonadComprehensions', 'MonadFailDesugaring', 'MonoLocalBinds', 'MonomorphismRestriction', 'MultiParamTypeClasses', 'MultiWayIf', 'NamedFieldPuns', 'NamedWildCards', 'NegativeLiterals', 'NPlusKPatterns', 'NullaryTypeClasses', 'NumDecimals', 'NumericUnderscores', 'OverlappingInstances', 'OverloadedLabels', 'OverloadedLists', 'OverloadedStrings', 'PackageImports', 'ParallelListComp', 'PartialTypeSignatures', 'PatternGuards', 'PatternSynonyms', 'PolyKinds', 'PostfixOperators', 'QuantifiedConstraints', 'QuasiQuotes', 'Rank2Types', 'RankNTypes', 'RebindableSyntax', 'RecordWildCards', 'RecursiveDo', 'RoleAnnotations', 'Safe', 'ScopedTypeVariables', 'StandaloneDeriving', 'StarIsType', 'StaticPointers', 'Strict', 'StrictData', 'TemplateHaskell', 'TemplateHaskellQuotes', 'TraditionalRecordSyntax', 'TransformListComp', 'Trustworthy', 'TupleSections', 'TypeApplications', 'TypeFamilies', 'TypeFamilyDependencies', 'TypeInType', 'TypeOperators', 'TypeSynonymInstances', 'UnboxedSums', 'UnboxedTuples', 'UndecidableInstances', 'UndecidableSuperClasses', 'UnicodeSyntax', 'Unsafe', 'ViewPatterns']

function! CompleteHsLanguageExts(A, L, P) abort
    let exts = g:hs_exts[:]
    " call filter(exts, 'v:val[:len(a:A) - 1] ==? a:A')
    call filter(exts, 'v:val =~? a:A')
    return exts
endfunction

function! InsertExt(ext) abort
    if !empty(trim(a:ext))
        call append(0, '{-# language ' . a:ext . ' #-}')
        " Append blank line if module comes right after language extension
        if getline(2) =~# 'module'
            call append(1, '')
        endif
    endif
endfunction

" Prompt for and insert a language extension at the top of the current buffer
nnoremap <Leader>HL :call InsertExt(input('ext: ', '', 'customlist,CompleteHsLanguageExts'))<CR>
