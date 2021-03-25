require('settings')
require('keymaps')
require('plugin_config/nvim_rspec')

function clean_code()
  vim.api.nvim_command('w')
  vim.api.nvim_command("terminal bundle exec rubocop -a %")
end

function clean_buffers()
  vim.api.nvim_command("%bd!")
end

