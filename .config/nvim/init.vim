" Highlight all search results
set hlsearch
" Set smartcase(will go case sensitive when upper case chars are in search,
" ignore case needs to be set first for this to work)
set ignorecase
set smartcase
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
set encoding=UTF-8


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
nnoremap <leader>o :GFiles!<CR>
nnoremap <leader>p :Files!<CR>
" Search file content using fzf & Rg
nnoremap <leader>f :Rg!<CR>
" Search for buffer name using fzf
nnoremap <leader>b :Buffers<CR>
" Toggle NERDTree pane
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>m :NERDTreeFind<CR>

" NERDTree related:
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
" Show hidden files by default.
let NERDTreeShowHidden=1
" The default of 31 is just a little too narrow.
let g:NERDTreeWinSize=40
" Disable display of '?' text and 'Bookmarks' label.
let g:NERDTreeMinimalUI=1


" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Basic fzf integration. (FZF command)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Extra fzf commands
Plug 'junegunn/fzf.vim'
" File browsking/managing
Plug 'preservim/nerdtree'
" File icons form NERDTree. NOTE: nerd-fonts-complete AUR package has been
" installed for this to work, which is ~ 2Gb. Consider removing this package
" if this plugin gets removed!
Plug 'ryanoasis/vim-devicons'
" Ruby support
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
" Color Theme
Plug 'lifepillar/vim-solarized8'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Color Theme releated:
set background=dark
colorscheme solarized8_flat

