require('settings')
require('keymaps')

function run_current_spec_file()
  local file_path = vim.fn.expand('%f')
  local command = string.format("terminal bundle exec spring rspec %s", file_path)
  vim.api.nvim_set_var('rspec_runner_last_command', command)
  vim.api.nvim_command('w')
  vim.api.nvim_command(command)
end

function run_current_spec_line()
  local file_path = vim.fn.expand('%f')
  local line_number = vim.fn.line('.')
  local command = string.format("terminal bundle exec spring rspec %s:%s", file_path, line_number)
  vim.api.nvim_set_var('rspec_runner_last_command', command)
  vim.api.nvim_command('w')
  vim.api.nvim_command(command)
end

function run_last_spec_command()
  local file_path = vim.fn.expand('%f')
  local line_number = vim.fn.line('.')
  local command = vim.api.nvim_get_var("rspec_runner_last_command")
  vim.api.nvim_command('w')
  vim.api.nvim_command(command)
end

