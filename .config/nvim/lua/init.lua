require('plugins')
require('settings')
require('keymaps')

require('plugin_config/lualine')
require('plugin_config/vim-rails')

require('lsp_config/ruby_lsp_config')
require('lsp_config/lua_lsp_config')
require('lsp_config/project_root_detection_config')
require('autocomplete_config')
require('treesitter_config')
require('rails_migrations_helpers')
require('copy_path_config')
require('git_utils')

function CleanCode()
  vim.api.nvim_command('w')

  if vim.fn.filereadable('.rubocop.yml') == 1 then
    vim.api.nvim_command("terminal bundle exec rubocop -A -c .rubocop.yml %")
  else
    vim.api.nvim_command("terminal bundle exec rubocop -A %")
  end
end

function CleanBuffers()
  -- %bdelete   - delete all buffers
  -- edit #     - opens file for edition. `#` in this context means alternate file name (previously being opened)
  -- #bd        - delete the [No Name] buffer
  -- normal `"  - execute in normal mode: go to last line number

  vim.api.nvim_command("%bdelete|edit #| bd# |normal `\"")
end

-- nvim-lspconfig related
-- Uncomment line below when debugging LSP. Causes degraded performance and disk usage.
-- vim.lsp.set_log_level("debug")

-- Gruvbox color themer related
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
