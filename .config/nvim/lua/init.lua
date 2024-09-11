require('plugins')
require('settings')
require('keymaps')
require('plugin_config/lualine')
require('lsp_config/ruby_lsp_config')
require('lsp_config/lua_lsp_config')
require('autocomplete_config')
require('treesitter_config')

function CleanCode()
  vim.api.nvim_command('w')
  vim.api.nvim_command("terminal bundle exec rubocop -A -c .rubocop_dev.yml %")
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
