require('settings')
require('keymaps')

function RunCurrentSpecFile()
  vim.api.nvim_command('w')
  vim.api.nvim_command('terminal bundle exec spring rspec %')
end

function RunCurrentSpecLine()
  local file_path = vim.fn.expand('%f')
  local line_number = vim.fn.line('.')
  local command = string.format("terminal bundle exec spring rspec %s:%s", file_path, line_number)
  vim.api.nvim_command('w')
  vim.api.nvim_command(command)
end
