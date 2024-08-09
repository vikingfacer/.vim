set nocompatible              " be iMproved, required
filetype plugin indent on    " required

set backspace=indent,eol,start

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

set cursorline
set cursorcolumn

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
if executable('ag')
set grepprg=ag\ --vimgrep\ $*
endif
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

autocmd BufWritePre * :%s/\s\+$//e

filetype plugin on

let g:lsp_auto_enable = 1
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"


" C & CPP files
so ~/.vim/clang-setup.vim

" Python autocmds
so ~/.vim/python-setup.vim

" Rust autocmds
so ~/.vim/rust-setup.vim

" Zig autocmds
so ~/.vim/zig-setup.vim

" Nix autocmds
so ~/.vim/nix-setup.vim


if executable('stylish-haskell')
  autocmd BufWritePost *.hs !(stylish-haskell <afile>)
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


" Commands
command Copy :'<,'>w !xclip -selection clipboard
