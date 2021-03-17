require('settings')
require('keymaps')
require('plugin/nvim_rspec')
require('plugin_config/nvim_rspec')

function clean_code()
  vim.api.nvim_command("terminal bundle exec rubocop -a %")
end
