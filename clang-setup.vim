
function ClangFormatBuffer()
  if executable('clang-format')
  if &modified && !empty(findfile('.clang-format', expand('%:p:h') . ';'))
    let cursor_pos = getpos('.')
    :%!clang-format
    call setpos('.', cursor_pos)
  else
    :%!clang-format
  endif
  endif
endfunction

let g:lsp_diagnostics_enabled = 0
function LspWarnOff()
    let g:lsp_diagnostics_enabled = 0
endfunction

" language server protocol
if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
        autocmd FileType objc setlocal omnifunc=lsp#complete
        autocmd FileType objcpp setlocal omnifunc=lsp#complete
    augroup end
endif

" Format code
autocmd BufWritePre *.h,*.hpp,*.c,*.cpp,*.vert,*.frag :call ClangFormatBuffer()

autocmd BufNewFile *.c 0r ~/.vim/skeleton-files/skeleton.c
autocmd bufnewfile *.c exe "1,".4."g/<current-year>*/s//" .strftime("%Y")

autocmd BufNewFile *.h 0r ~/.vim/skeleton-files/skeleton.h
autocmd bufnewfile *.h exe "1,".4."g/<current-year>*/s//" .strftime("%Y")
autocmd bufnewfile *.h exe "%s/filename/".expand("%:t")

