
autocmd BufNewFile default.nix 0r ~/.vim/skeleton-files/skeleton-default.nix
if executable('nil')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'nil',
    \ 'cmd': {server_info->['nil']},
    \ 'whitelist': ['nix'],
    \ })
endif

if executable('nixfmt')
  autocmd BufWritePost *.nix !(nixfmt <afile>)
endif
