
autocmd BufNewFile build.zig.zon 0r ~/.vim/skeleton-files/build.zig.zon

if executable('zig')
  autocmd BufWritePost *.zig !(zig fmt <afile>)
endif

if executable('zls')
  au User lsp_setup call lsp#register_server({
        \ 'name' : 'zls',
        \ 'cmd' : {server_info->['zls']},
        \ 'whitelist' : ['zig'],
        \ })
  autocmd FileType zig setlocal omnifunc=lsp#complete
endif

