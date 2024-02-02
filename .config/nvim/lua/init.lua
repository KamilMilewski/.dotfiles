require('plugins')
require('settings')
require('keymaps')
require('plugin_config/nvim_rspec')
require('lsp_config')
require('autocomplete_config')

function CleanCode()
  vim.api.nvim_command('w')
  vim.api.nvim_command("terminal bundle exec rubocop -A -c .rubocop_dev.yml %")
end

function CleanBuffers()
  -- %bd! - delete all buffers
  -- e# - open the last buffer for editing
  -- #bd - delete the [No Name] buffer
  vim.api.nvim_command("%bd! | e# | bd#")
end

-- nvim-lspconfig related
-- Uncomment line below when debugging LSP. Causes degraded performance and disk usage.
-- vim.lsp.set_log_level("debug")
