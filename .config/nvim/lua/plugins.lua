return require('packer').startup(function(use)

  -- Basic fzf integration. (FZF command)
  -- Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  use 'junegunn/fzf'

  -- Extra fzf commands
  use {
   'junegunn/fzf.vim',
    requires = {{ 'junegunn/fzf' }}
  }

  -- Color Theme
  use 'lifepillar/vim-solarized8'

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- File explorer
  -- NOTE: 'kyazdani42/nvim-web-devicons' provides file icons. 'nerd-fonts-complete' AUR package has been
  -- installed for this to work, which is ~ 2Gb. Consider removing this package when uninstalling this plugin.
  use {
      'kyazdani42/nvim-tree.lua',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function() require'nvim-tree'.setup {
	update_focused_file = {
	  -- enables the feature (jump right into current file when opening file explorer)
	  enable = true
	},
	nvim_tree_quit_on_open = {
	  enable = true --false by default, closes the tree when you open a file
	},
	view = {
	  -- width of the window, can be either a number (columns) or a string in `%`
	  width = '25%'
	}
      } end
  }

  -- Ruby support
  use {
    'vim-ruby/vim-ruby',
    ft = 'ruby'
  }

  -- For rails specific goodies
  use {
    'tpope/vim-rails',
    ft = 'ruby'
  }

  -- Collection of common configurations for Nvim built-in LSP
  use 'neovim/nvim-lspconfig'

  -- Git plugin
  use 'tpope/vim-fugitive'

  -- Minimalist and configurable status line
  use 'itchyny/lightline.vim'

  -- For commenting/uncommenting with different file types handling.
  use 'tpope/vim-commentary'

  -- For auto pairing(ending) brackets.
  -- NOTE: causes weird behaviour in vim config files when deleting comments
  use 'jiangmiao/auto-pairs'

  -- Like auto pairs, but for method definitions and 'if' statements
  use 'tpope/vim-endwise'

  -- To add/modify/remove surround stuff like ({"''"})
  use 'tpope/vim-surround'

  -- For being able to select ruby blocks(functions, classes, etc...)
  use {
   'tek/vim-textobj-ruby',
   ft = 'ruby',
   requires = {{ 'kana/vim-textobj-user' }}
  }

  -- For white spaces highlighting
  use {
    'ntpeters/vim-better-whitespace',
    ft = { 'ruby', 'vim', 'lua', 'html', 'js', 'ts', 'tsx' }
  }

  -- For unified pane switching for tmux and vim. Thanks to this one can just do
  -- ctrl-hjkl to move between panes both in vim and tmux(with corresponding tmux
  -- plugin installed)
  use 'christoomey/vim-tmux-navigator'

  -- For nice dates auto-increment (Ctrl-a)
  use 'tpope/vim-speeddating'

  -- Extends repeat (.) vim functionality so it becomes aware of some Tpope plugin actions, like vim-surround
  use 'tpope/vim-repeat'

  -- Highlight letters to jump when using f/F movements
  use 'unblevable/quick-scope'

  -- Display sign columns by modified (in git terms columns)
  use 'mhinz/vim-signify'

  -- HAML syntax highlighting
  use 'tpope/vim-haml'

  -- Faster html tags writing
  use 'mattn/emmet-vim'

  -- Provides:
  -- - line swap through [e and ]e
  -- - navigate quickfix list with [q and ]q
  use 'tpope/vim-unimpaired'

  -- JavaScript related:
  -- CoffeScript syntax highlighting
  use 'kchmck/vim-coffee-script'

  -- TypeScript support
  use 'HerringtonDarkholme/yats.vim'

  -- A syntax highlighting for JavaScript
  use 'yuezk/vim-js'

  -- The React syntax highlighting and indenting. Also supports the typescript tsx file.
  use 'maxmellon/vim-jsx-pretty'

  -- Autocompletion related:

  -- Completion engine for nvim
  use 'hrsh7th/nvim-cmp'

  -- Completion engine sources(List of compatible sources: https://github.com/topics/nvim-cmp):
  -- LSP source
  use {
    'hrsh7th/cmp-nvim-lsp',
    requires = {{ 'hrsh7th/nvim-cmp'}}
  }

  -- Buffer source
  use {
    'hrsh7th/cmp-buffer',
    requires = {{ 'hrsh7th/nvim-cmp'}}
  }

  -- Tabnine source (basic AI completions)
  use {
    'tzachar/cmp-tabnine',
    run = './install.sh',
    requires = 'hrsh7th/nvim-cmp'
  }
end)
