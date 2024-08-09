" Python autocmds
autocmd BufNewFile *.py 0r ~/.vim/skeleton-files/skeleton.py
if executable('black')
autocmd BufWritePost *.py !(black <afile>)
endif

if executable("pylsp")
    " pip install python-language-server
    augroup lsp_pyls
        autocmd!
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
        autocmd FileType py setlocal omnifunc=lsp#complete
    augroup lsp_pyls
endif

