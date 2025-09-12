lua require 'init'

filetype on

" Enable file type-specific plugins
filetype plugin on
let g:markdown_fenced_languages = ['ruby', 'json', 'sh', 'lua']

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

" Do not jump on word highlighting (on shift-* press)
nnoremap * :keepjumps normal! mi*`i<CR>

" Disable Perl provider
let g:loaded_perl_provider = 0
" Disable Python provider
let g:loaded_python3_provider = 0

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
  " Get the default branch (main or master or otherwise)
  let l:default_branch = systemlist('git symbolic-ref refs/remotes/origin/HEAD')[0]
  let l:default_branch = substitute(l:default_branch, 'refs/remotes/origin/', '', '')

  " Fallback to 'main' if detection fails
  if empty(l:default_branch)
    let l:default_branch = 'main'
  endif

  " Get list of changed files since default branch
  let l:git_command = 'git diff --name-only ' . l:default_branch . '..HEAD'
  let l:files = systemlist(l:git_command)

  " Run fzf with preview using bat
  call fzf#run({
        \ 'source': l:files,
        \ 'sink': 'e',
        \ 'options': '--preview "bat --color=always --style=numbers,changes --line-range :500 {}"',
        \ })
endfunction
nnoremap <leader>u :GDiffFiles?<CR>


" Vim-signify related
" So that signs will appear in a reasonably time
set updatetime=100


" Custom commands
" Copy full file path with line number
command Cfpf :let @+=expand("%:p") . ":" . line(".")
" Copy relative file path with line number
command Cfpr :let @+=expand("%:.") . ":" . line(".")

" Format JSON
command! -range Formatjson <line1>,<line2>!python -m json.tool
