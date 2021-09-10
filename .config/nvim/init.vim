runtime vim_config/plugins.vim

lua require 'init'

filetype on

" Enable file type-specific plugins
filetype plugin on
let g:markdown_fenced_languages = ['ruby', 'json', 'sh']

" file type specific configs:
autocmd FileType coffee setlocal expandtab

" Highlight yanked text
au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

" Disable spell check for terminal buffers
au TermOpen * setlocal nospell

" Markdown specific config
autocmd Filetype markdown setlocal wrap

" allow mouse scroll & mouse visual select
set mouse=a

" changes default Vim register to `+` register, which is linked to the system
" clipboard
set clipboard=unnamedplus

" Set hybrid line numbering (relative numbers + actual number at the current
" line). Also return back normal numbering when entering insert mode or if
" buffer focus lost.
set number relativenumber
augroup numbertoggle
  autocmd!
  " autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  " autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  autocmd InsertLeave * set relativenumber
  autocmd InsertEnter * set norelativenumber
augroup END


" Solarized8 (Color Theme) related:
set termguicolors
set background=dark
autocmd vimenter * ++nested colorscheme solarized8
let g:solarized_extra_hi_groups = 1


" Nvim Tree related:
nnoremap <leader>n :NvimTreeToggle<CR>
" jump right into current file when opening file explorer
let g:nvim_tree_follow = 1
let g:nvim_tree_width = 40
let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file


" FZF related
" Search for file name using fzf: only files in a repo
nnoremap <leader>o :GFiles!<CR>
" Search for file name using fzf: all files
nnoremap <leader>p :Files!<CR>
" Search file content using fzf & Rg
nnoremap <leader>f :Rg!<CR>
" Search for buffer name using fzf
nnoremap <leader>b :Buffers<CR>
" Search current buffer lines using fzf
nnoremap <leader>l :BLines<CR>


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


" Speeddating related
au VimEnter * :SpeedDatingFormat %d.%m.%Y


" Quick-scope related
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']


" Vim-signify related
" So that signs will appear in a reasonably time
set updatetime=100


" Custom commands
" Copy File Path(full) to system clipboard.
command Cfpf :let @+=expand("%:p")
" Copy File Path(Relative) to system clipboard.
command Cfpr :let @+=expand("%:.p")
" Format JSON
command! -range Formatjson <line1>,<line2>!python -m json.tool

