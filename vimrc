set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" alternatively, pass a path where Vundle should install plugins

" Plugins
Plug 'jistr/vim-nerdtree-tabs'
Plug 'sheerun/vim-polyglot'
Plug 'kien/ctrlp.vim'
Plug 'ap/vim-buftabline'
Plug 'rust-lang/rust.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ajh17/vimcompletesme'
Plug 'kergoth/vim-bitbake'
Plug 'LnL7/vim-nix'

" Color scheme
Plug 'kien/rainbow_parentheses.vim'

call plug#end()
filetype plugin indent on    " required

" keybindings
nnoremap <C-up> k<C-y>
nnoremap <C-down> j<C-e>

set statusline=%<%f%<%{FileTime()}%<%h%m%r%=%-20.(line=%03l,col=%02c%V,totlin=%L%)\%h%m%r%=%-30(,BfNm=%n%Y%)\%P\*%=%{CurTime()}
set rulerformat=%15(%c%V\ %p%%%)
"set rulerformat=%<%f%<%{FileTime()}%<%h%m%r%=%-20.(line=%03l,col=%02c%V,totlin=%L%)\%h%m%r%=%-30(,BfNm=%n%Y%)\%P\*%=%{CurTime()}

function! FileTime()
  let ext=tolower(expand("%:e"))
  let fname=tolower(expand('%<'))
  let filename=fname . '.' . ext
  let msg=""
  let msg=msg." ".strftime("(Modified %b,%d %y %H:%M:%S)",getftime(filename))
  return msg
endfunction

function! CurTime()
  let ftime=""
  let ftime=ftime." ".strftime("%b,%d %y %H:%M:%S")
  return ftime
endfunction

" Vim Completes Me autocmd setting
autocmd FileType vim let b:vcm_tab_complete = 'vim'

filetype plugin on
" set omnifunc=syntaxcomplete#Complete
set statusline=%f               " filename relative to current $PWD
set statusline+=%h              " help file flag
set statusline+=%m              " modified flag
set statusline+=%r              " readonly flag
set statusline+=\ [%{&ff}]      " Fileformat [unix]/[dos] etc...
set statusline+=\ (%{strftime(\"%Y-%m-%d\ %H:%M\",getftime(expand(\"%:p\")))})  " last modified timestamp
set statusline+=%=              " Rest: right align
set statusline+=%l,%c%V         " Position in buffer: linenumber, column, virtual column
set statusline+=\ %P            " Position in buffer: Percentage

set laststatus=2

" show whitespace
set listchars=tab:--,trail:·,extends:>,precedes:<,space:·
set list
" highlight search result
set hlsearch

" search
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m
"
" vim flash current search result
if exists("g:loaded_blink_search") || v:version < 700 || &cp
  finish
endif
let g:loaded_blink_search = 1

nnoremap <silent> n n:call <SID>BlinkCurrentMatch()<CR>
nnoremap <silent> N N:call <SID>BlinkCurrentMatch()<CR>

function! s:BlinkCurrentMatch()
  let target = '\c\%#'.@/
  let match = matchadd('IncSearch', target)
  redraw
  sleep 100m
  call matchdelete(match)
  redraw
endfunction

" C & CPP files
function ClangFormatBuffer()
  if &modified && !empty(findfile('.clang-format', expand('%:p:h') . ';'))
    let cursor_pos = getpos('.')
    :%!clang-format
    call setpos('.', cursor_pos)
  endif
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

" Rust autocmds
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
        autocmd FileType rs setlocal omnifunc=lsp#complete
endif

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

if executable('rnix-lsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rnix-lsp',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'rnix-lsp']},
        \ 'whitelist': ['nix'],
        \ })
endif

if executable('nixfmt')
  autocmd BufWritePost *.nix !(nixfmt <afile>)
endif

"·Rainbow·settings¬
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


let g:spelunker_highlight_type = 2

" personal settings
set number
set ts=4
syntax on
set clipboard=unnamed
set scroll=1
set spell
colorscheme neon-dark-256
