set timeoutlen=1000
set ttimeoutlen=5

" remap `leave insert mode` to jj
inoremap jj <ESC>

" remap panes navigations to just ctrl+hjkl instead of ctrl+w+hjkl
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" highlight syntax
syntax on 

" highlight all search results
set hlsearch

" enable autoindent
set autoindent

" indenting is 2 spaces 
set shiftwidth=2
