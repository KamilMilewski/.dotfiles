" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')



" Basic fzf integration. (FZF command)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Extra fzf commands
Plug 'junegunn/fzf.vim'
" nerdtree: file browsing/managing
" nerdtree-git-plugin: provide git indicators for files
" vim-devicons: provide file icons form NERDTree. NOTE: nerd-fonts-complete AUR package has been
" installed for this to work, which is ~ 2Gb. Consider removing this package
" if this plugin gets removed!
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'
" Ruby support
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
" Color Theme
Plug 'lifepillar/vim-solarized8'
" Provides linting and acts as a LSP
Plug 'dense-analysis/ale'
" Git plugin
Plug 'tpope/vim-fugitive'
" Minimalist and configurable status line
Plug 'itchyny/lightline.vim'
" For commenting/uncommenting with different file types handling.
Plug 'tpope/vim-commentary'
" TypeScript support
Plug 'leafgarland/typescript-vim'
" For auto pairing(ending) brackets.
" NOTE: causes weird behaviour in vim config files when deleting comments
Plug 'jiangmiao/auto-pairs'
" Like auto pairs, but for method definitions and 'if' statements
Plug 'tpope/vim-endwise'
" To add/modify/remove surround stuff like ({"''"})
Plug 'tpope/vim-surround'


" List ends here. Plugins become visible to Vim after this call.
call plug#end()
