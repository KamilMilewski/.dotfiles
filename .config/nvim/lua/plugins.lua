-- Setup plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- Basic fzf integration. (FZF command)
  'junegunn/fzf',


  -- Extra fzf commands
  { 'junegunn/fzf.vim', dependencies = { 'junegunn/fzf' } },


  -- Color Theme
  'lifepillar/vim-solarized8',


  -- File explorer
  -- NOTE: 'kyazdani42/nvim-web-devicons' provides file icons. 'nerd-fonts-complete' AUR package has been
  -- installed for this to work, which is ~ 2Gb. Consider removing this package when uninstalling this plugin.
  {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require'nvim-tree'.setup {
	update_focused_file = {
	  -- enables the feature (jump right into current file when opening file explorer)
	  enable = true
	},
	actions = {
	  open_file = {
	    quit_on_open = true --false by default, closes the tree when you open a file
	  }
	},
	view = {
	  -- width of the window, can be either a number (columns) or a string in `%`
	  width = '25%'
	},
	git = {
	  ignore = false
	}
      }
    end
  },


  -- Ruby support
  { 'vim-ruby/vim-ruby', ft = 'ruby' },


  -- For rails specific goodies
  { 'tpope/vim-rails', ft = 'ruby' },


  -- Collection of common configurations for Nvim built-in LSP
  'neovim/nvim-lspconfig',


  -- Git plugin
  'tpope/vim-fugitive',


  -- Fast status line written in lua
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
	theme = 'solarized_dark',
	globalstatus = true,
	extensions = {'nvim-tree', 'fzf', 'fugitive'},
	ignore_focus = {'NvimTree', 'fzf'},
	sections = {
	  lualine_a = {'mode'},
	  lualine_b = {'branch', 'GitCheckForBranchChanges()', 'diff', 'diagnostics'},
	  lualine_c = {'filename'},
	  lualine_x = {'encoding', 'fileformat', 'filetype'},
	  lualine_y = {'progress'},
	  lualine_z = {'location'}
	},
      }
    end
  },


  -- For commenting/uncommenting with different file types handling.
  'tpope/vim-commentary',


  -- For auto pairing(ending) brackets.
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  },


  -- Like auto pairs, but for method definitions and 'if' statements
  'tpope/vim-endwise',


  -- To add/modify/remove surround stuff like ({"''"})
  'tpope/vim-surround',


  -- For being able to select ruby blocks(functions, classes, etc...)
  {
   'tek/vim-textobj-ruby',
   ft = 'ruby',
   dependencies = { 'kana/vim-textobj-user' }
  },


  -- For white spaces highlighting
  {
    'ntpeters/vim-better-whitespace',
    ft = { 'vim', 'lua', 'html', 'js', 'ts', 'tsx' }
  },


  -- For unified pane switching for tmux and vim. Thanks to this one can just do
  -- ctrl-hjkl to move between panes both in vim and tmux(with corresponding tmux
  -- plugin installed)
  'christoomey/vim-tmux-navigator',


  -- Extends repeat (.) vim functionality so it becomes aware of some Tpope plugin actions, like vim-surround
  'tpope/vim-repeat',


  -- Highlight letters to jump when using f/F movements
  {
    'unblevable/quick-scope',
      vim.cmd [[
	" Trigger a highlight in the appropriate direction when pressing these keys:
	let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

	augroup qs_colors
	  autocmd!
	  autocmd ColorScheme * highlight QuickScopePrimary guifg='#99CE64' gui=underline ctermfg=155 cterm=underline
	  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
	augroup END
      ]]
  },


  -- Display sign columns by modified (in git terms columns)
  'mhinz/vim-signify',


  -- HAML syntax highlighting
  'tpope/vim-haml',


  -- Faster html tags writing
  'mattn/emmet-vim',


  -- Provides:
  -- - line swap through [e and ]e
  -- - navigate quickfix list with [q and ]q
  'tpope/vim-unimpaired',


  -- CoffeScript syntax highlighting
  'kchmck/vim-coffee-script',


  -- TypeScript support
  'HerringtonDarkholme/yats.vim',


  -- A syntax highlighting for JavaScript
  'yuezk/vim-js',


  -- The React syntax highlighting and indenting. Also supports the typescript tsx file.
  'maxmellon/vim-jsx-pretty',

  --
  -- Autocompletion related:
  --

  -- Completion engine for nvim
  'hrsh7th/nvim-cmp',


  --Many things, but here mostly to convert from snake to camel case, etc
  --Want to turn fooBar into foo_bar?
  --Move over a word and press crs (coerce to snake_case). No need to highlight it.
  --MixedCase (crm), camelCase (crc),
  --snake_case (crs),
  --UPPER_CASE (cru),
  --dash-case (cr-),
  --dot.case (cr.),
  --space case (cr<space>),
  --and Title Case (crt)
  'tpope/vim-abolish',


  --
  -- Completion engine sources(List of compatible sources: https://github.com/topics/nvim-cmp):
  --

  -- LSP source
  {
    'hrsh7th/cmp-nvim-lsp',
    dependencies = {'hrsh7th/nvim-cmp'}
  },


  -- Buffer source
  {
    'hrsh7th/cmp-buffer',
    dependencies = { 'hrsh7th/nvim-cmp'}
  },


  -- Tabnine source (basic AI completions)
  {
    'tzachar/cmp-tabnine',
    build = './install.sh',
    dependencies = {'hrsh7th/nvim-cmp'}
  },

}
local opts = {

}

require("lazy").setup(plugins, opts)
