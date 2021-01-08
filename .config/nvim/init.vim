" Highlight all search results
set hlsearch
" Enable autoindent
set autoindent
" Indenting is 2 spaces 
set shiftwidth=2
" Allows to switch buffers with unsaved changes
set hidden
" We're running Vim, not Vi!
set nocompatible
" Enable line numbers bar
set number 
" Enable line/column number status at the bottom-right corner
set ruler
" Do not wrap files at the right edge of the screen
set nowrap
" Enable syntax highlighting
syntax on             
" Enable filetype detection
filetype on
" Enable filetype-specific indenting
filetype indent on
" Enable filetype-specific plugins
filetype plugin on
" Other settings:
set timeoutlen=1000
set ttimeoutlen=5



" Remappings:
" Set ladder key
nnoremap <SPACE> <Nop>
let mapleader=" "
" Remap `leave insert mode` to jj
inoremap jj <ESC>
" Remap panes navigations to just ctrl+hjkl instead of ctrl+w+hjkl
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" Search for file name using fzf
nmap <C-P> :GFiles<CR>
" Search for buffer name using fzf
nnoremap <leader>b :Buffers<CR>
" Toggle NERDTree pane
nnoremap <leader>n :NERDTreeToggle<CR>



" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Basic fzf integration. (FZF command)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Extra fzf commands
Plug 'junegunn/fzf.vim'
" File browsking/managing
Plug 'preservim/nerdtree'
" Ruby support
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
