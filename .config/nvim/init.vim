runtime vim_config/plugins.vim

lua require 'init'

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
" Enable file type detection
filetype on
" Enable file type-specific indenting
filetype indent on
" Enable file type-specific plugins
filetype plugin on
" Other settings:
set timeoutlen=1000
set ttimeoutlen=5
set encoding=UTF-8
" Enable spell check
set spell
set spelllang=en,pl
" Enable Folding
set foldmethod=indent
set foldlevelstart=99 " start unfolded
" Enable vertical bar at 120chars
set colorcolumn=120
" to start scrolling starting n lines away from top/bottom
set scrolloff=4
" Disable swap file
set noswapfile
" Disable creation of backup files
set nobackup
" Enable markdown blocks syntax highlighting
let g:markdown_fenced_languages = ['ruby', 'json', 'sh']
" line below allows to do ':set list' to display whitespace characters
:set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" Markdown specific config
autocmd Filetype markdown setlocal wrap


" Remappings:
" Set ladder key
nnoremap <SPACE> <Nop>
let mapleader=" "

" Remap `leave insert mode` to jj
" inoremap jj <ESC>
" Map copy to system clipboard
vmap <leader>y "+y
" Map leave insert mode in vim terminal to ctrl+s
tnoremap <C-s> <C-\><C-n>
" Remap `leave insert mode` to ctrl+s
inoremap <C-s> <ESC>
" Source vim config
nnoremap <leader>sv :source $MYVIMRC<CR>
" Make movement between wrapped lines easier
" nnoremap j gj
" nnoremap k gk

" NERDTree related:

" Exit Vim if NERDTree is the only window left.
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
"     \ quit | endif
" Show hidden files by default.
let NERDTreeShowHidden=1
" The default of 31 is just a little too narrow.
let g:NERDTreeWinSize=40
" Disable display of '?' text and 'Bookmarks' label.
let g:NERDTreeMinimalUI=1

" Toggle NERDTree pane and auto jump to current buffer file location
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    if (expand("%:t") != '')
      exe ":NERDTreeFind"
    else
      exe ":NERDTreeToggle"
    endif
  endif
endfunction
nnoremap <leader>n :call NERDTreeToggleInCurDir()<CR>


" FZF related
" Search for file name using fzf: only files in a repo
nnoremap <leader>o :GFiles!<CR>
" Search for file name using fzf: all files
nnoremap <leader>p :Files!<CR>
" Search file content using fzf & Rg
nnoremap <leader>f :Rg!<CR>
" Search for buffer name using fzf
nnoremap <leader>b :Buffers<CR>
" Search corrent buffer lines using fzf
nnoremap <leader>l :BLines<CR>
" Fuzzy search notes file name
nmap <Leader>wo :Files! ~/Work/notes<CR>


" ALE related
let g:ale_echo_msg_format = '[%linter%] %s [%severity%][%code%]'
nnoremap gd :ALEGoToDefinition<CR>
nnoremap gr :ALEFindReferences<CR>


" Lightline related
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \		     [ 'filetype' ]]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }


" Color Theme related:
set background=dark
colorscheme solarized8_flat


" Custom commands
" Copy File Path(full) to system clipboard.
command Cfpf :let @+=expand("%:p")
" Copy File Path(Relative) to system clipboard.
command Cfpr :let @+=expand("%:.p")
" Format JSON
command! -range Formatjson <line1>,<line2>!python -m json.tool



" Run spec for current file
function! RunSpecFile()
  let spec_path = expand('%')
  exe ':w'
  exe ':terminal bundle exec spring rspec ' . spec_path
endfunction
command RunSpecFile call RunSpecFile()
nnoremap <leader>sf :RunSpecFile<CR>

" Run spec for current line
function! RunSpecLine()
  let spec_path = join([expand('%'),  line(".")], ':')
  exe ':w'
  exe ':terminal bundle exec spring rspec ' . spec_path
endfunction
command RunSpecLine call RunSpecLine()
nnoremap <leader>sl :RunSpecLine<CR>

