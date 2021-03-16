function nrspec_run_current_file()
  local file_path = vim.fn.expand('%f')
  local command = string.format("terminal bundle exec spring rspec %s", file_path)
  vim.api.nvim_set_var('nrspec_last_command', command)
  vim.api.nvim_command('w')
  vim.api.nvim_command(command)
end

function nrspec_run_current_line()
  local file_path = vim.fn.expand('%f')
  local line_number = vim.fn.line('.')
  local command = string.format("terminal bundle exec spring rspec %s:%s", file_path, line_number)
  vim.api.nvim_set_var('nrspec_last_command', command)
  vim.api.nvim_command('w')
  vim.api.nvim_command(command)
end

function nrspec_run_last_command()
  local file_path = vim.fn.expand('%f')
  local line_number = vim.fn.line('.')
  local command = vim.api.nvim_get_var("nrspec_last_command")
  vim.api.nvim_command('w')
  vim.api.nvim_command(command)
end

function nrspec_run_last_failed()
  local command = string.format("terminal bundle exec spring rspec --only-failures")
  vim.api.nvim_set_var('nrspec_last_command', command)
  vim.api.nvim_command('w')
  vim.api.nvim_command(command)
end
