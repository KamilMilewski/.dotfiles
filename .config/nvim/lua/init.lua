require('settings')
require('keymaps')
require('plugin_config/nvim_rspec')

function clean_code()
  vim.api.nvim_command('w')
  vim.api.nvim_command("terminal bundle exec rubocop -A -c .rubocop_dev.yml %")
end

function clean_buffers()
  -- %bd! - delete all buffers
  -- e# - open the last buffer for editing
  -- #bd - delete the [No Name] buffer
  vim.api.nvim_command("%bd! | e# | bd#")
end

