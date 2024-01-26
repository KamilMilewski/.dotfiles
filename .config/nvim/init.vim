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

" Do not jump on word highlighting
nnoremap * :keepjumps normal! mi*`i<CR>

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

" So vimgrep command will ignore irrelevant dirs
set wildignore+=*/node_modules/*

" Solarized8 (Color Theme) related:
set termguicolors
set background=dark
autocmd vimenter * ++nested colorscheme solarized8
let g:solarized_extra_hi_groups = 1

" Nvim Tree related:
" NOTE: rest of the config is in .config/nvim/lua/plugins.lua
nnoremap <leader>n :NvimTreeToggle<CR>

" FZF related
" Search for file name using fzf: only files in a repo
nnoremap <leader>o :GFiles!<CR>
" Search for file name using fzf: all files
nnoremap <leader>p :Files!<CR>
" Search file name & content combined using fzf & Rg
nnoremap <leader>d :Rg!<CR>
" Modified standard fzf.vim Rg! command that:
" - doesn't ignore hidden files.
" - searches only in file contents ignoring matches in filenames.
command! -bang -nargs=* Rgi  call fzf#vim#grep("rg -. --column --line-number --no-heading --color=always --smart-case --glob=!.git -- ".fzf#shellescape(<q-args>), fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

nnoremap <leader>f :Rgi!<CR>

" Search for buffer name using fzf
nnoremap <leader>b :Buffers<CR>
" Search current buffer lines using fzf
nnoremap <leader>l :BLines<CR>
" Search for files in git working directory
nnoremap <leader>i :GFiles?<CR>
" Search in files that changed between current and master branch
command! -nargs=* GDiffFiles call s:GDiffFiles(<q-args>)
function! s:GDiffFiles(...) abort
  let l:git_command = 'git diff --name-only master..HEAD'
  let l:files = systemlist(l:git_command)
  let l:query = join(a:000, ' ')
  let l:selected_file = fzf#run({
        \ 'source': l:files,
        \ 'sink': 'e',
        \ 'options': '--preview "bat --color=always --style=numbers,changes --line-range :500 {}"',
        \ })
endfunction
nnoremap <leader>u :GDiffFiles?<CR>


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

