set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'sheerun/vim-polyglot'
Plugin 'kien/ctrlp.vim'
Plugin 'ap/vim-buftabline'
Plugin 'rust-lang/rust.vim'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'ajh17/vimcompletesme'

" Color scheme
Plugin 'kien/rainbow_parentheses.vim'

call vundle#end()
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
if executable("pyls")
    " pip install python-language-server
    augroup lsp_pyls
        autocmd!
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
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
        autocmd FileType py setlocal omnifunc=lsp#complete
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
