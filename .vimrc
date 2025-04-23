"set mouse-=a
syntax on
set nopaste
colorscheme desert

"filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
"set expandtab

set splitbelow
set splitright

call plug#begin('~/.vim/plugged')

" GitHub Copilot plugin
Plug 'github/copilot.vim'

call plug#end()
