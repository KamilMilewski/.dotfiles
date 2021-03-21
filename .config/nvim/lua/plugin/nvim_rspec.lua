local M = {}

local function is_spec_file(file_path)
  ending = [[_spec.rb]]
  return file_path:sub(-#ending) == ending
end

function M.nrspec_run_current_file()
  local full_path = vim.fn.expand('%f')

  -- abort if not a spec file
  if( not is_spec_file(full_path) )
  then
    vim.api.nvim_command([[echo 'NVRSpec: not a spec file']])
    return
  end

  local rspec_command = string.format("bundle exec spring rspec %s", full_path)
  local command_with_msg = string.format(
    "terminal echo ' >>> Running spec file: %s\\n' && %s", full_path, rspec_command
  )
  vim.api.nvim_set_var('nrspec_last_rspec_command', rspec_command)
  vim.api.nvim_set_var('nrspec_last_full_path', full_path)
  vim.api.nvim_command('w')
  vim.api.nvim_command(command_with_msg)
end

function M.nrspec_run_current_line()
  local file_path = vim.fn.expand('%f')

  -- abort if not a spec file
  if( not is_spec_file(file_path) )
  then
    vim.api.nvim_command([[echo 'NVRSpec: not a spec file']])
    return
  end

  local line_number = vim.fn.line('.')
  local full_path = string.format("%s:%s", file_path, line_number)
  local rspec_command = string.format("bundle exec spring rspec %s", full_path)
  local command_with_msg = string.format(
    "terminal echo ' >>> Running spec line: %s\\n' && %s", full_path, rspec_command
  )
  vim.api.nvim_set_var('nrspec_last_rspec_command', rspec_command)
  vim.api.nvim_set_var('nrspec_last_full_path', full_path)
  vim.api.nvim_command('w')
  vim.api.nvim_command(command_with_msg)
end

function M.nrspec_run_last_command()
  local file_path = vim.fn.expand('%f')
  local line_number = vim.fn.line('.')
  local rspec_command = vim.api.nvim_get_var("nrspec_last_rspec_command")
  local command_with_msg = string.format(
    "terminal echo ' >>> Running last rspec command: %s\\n' && %s", rspec_command, rspec_command
  )
  vim.api.nvim_command('w')
  vim.api.nvim_command(command_with_msg)
end

function M.nrspec_run_last_failed()
  local rspec_command = string.format("bundle exec spring rspec --only-failures")
  local command_with_msg = string.format(
    "terminal echo ' >>> Running last failed specs: %s\\n' && %s", rspec_command, rspec_command
  )
  vim.api.nvim_command('w')
  vim.api.nvim_command(command_with_msg)
end

return M

