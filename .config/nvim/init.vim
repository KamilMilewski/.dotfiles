runtime vim_config/plugins.vim

lua require 'init'

filetype on

" Enable file type-specific plugins
filetype plugin on
let g:markdown_fenced_languages = ['ruby', 'json', 'sh']

" Highlight yanked text
au TextYankPost * silent! lua vim.highlight.on_yank { timeout=150 }

" Disable spell check for terminal buffers
au TermOpen * setlocal nospell

" Markdown specific config
autocmd Filetype markdown setlocal wrap

" Color Theme related:
set background=dark
colorscheme solarized8_flat


" NERDTree related:

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
" Search current buffer lines using fzf
nnoremap <leader>l :BLines<CR>


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

" Speeddating related
au VimEnter * :SpeedDatingFormat %d.%m.%Y


" Custom commands
" Copy File Path(full) to system clipboard.
command Cfpf :let @+=expand("%:p")
" Copy File Path(Relative) to system clipboard.
command Cfpr :let @+=expand("%:.p")
" Format JSON
command! -range Formatjson <line1>,<line2>!python -m json.tool

