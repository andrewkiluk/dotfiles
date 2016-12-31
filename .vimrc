set nocompatible 
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-jdaddy'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/nerdcommenter'
Plugin 'ervandew/supertab'
Plugin 'vim-airline/vim-airline'
Plugin 'kshenoy/vim-signature'
Plugin 'airblade/vim-gitgutter'
Plugin 'duff/vim-scratch'
Plugin 'itchyny/vim-haskell-indent'
Plugin 'wellle/targets.vim'
Plugin 'vim-scripts/ReplaceWithRegister'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'godlygeek/tabular'
Plugin 'Shougo/vimproc.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'eagletmt/ghcmod-vim'
Plugin 'michaeljsmith/vim-indent-object'

call vundle#end()
filetype plugin indent on

runtime! plugin/sensible.vim

"Line numbers
set number
set relativenumber

" NerdTree command
map <Leader>n :NERDTreeToggle<CR>

" Set search highlighting to ON
 set hlsearch

"Allow toggling line numbers
:nmap <C-L> :set invnumber invrelativenumber<CR>

"Switch between buffers without saving
set hidden

" Persistent undo
set undofile
set undodir=~/.vim/undodir

" Buffer switching using Cmd-arrows 
:nnoremap <C-Right> :bnext<CR>
:nnoremap <C-Left> :bprevious<CR>

" When coding, auto-indent by 4 spaces, just like in K&R
" Note that this does NOT change tab into 4 spaces
" You can do that with set tabstop=4, which is a BAD idea
set shiftwidth=4
set softtabstop=4         "Insert 4 spaces when tab is pressed
set expandtab             "Always uses spaces instead of tab characters

syntax enable
colorscheme BusyBee

let g:CommandTHighlightColor='DiffAdd'

" Set cursor style
let &t_SI .= "\<Esc>[6 q"
let &t_EI .= "\<Esc>[2 q"
" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar


" Reset cursor on exit
autocmd VimLeave * let &t_me="\<Esc>[4 q"

"Leader-s replaces word under cursor
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

"vim-airline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

" Keep lines between cursor and edge when scrolling
set scrolloff=8

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %


