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
" Provides linting and acts as LSP (Language Server Protocol)
Plug 'dense-analysis/ale'
" Git plugin
Plug 'tpope/vim-fugitive'
" Minimalist and configurable statusline
Plug 'itchyny/lightline.vim'


" List ends here. Plugins become visible to Vim after this call.
call plug#end()