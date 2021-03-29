local M = {}
vim.api.nvim_set_var('nrspec_user_command_override', null)

local function is_spec_file(file_path)
  ending = [[_spec.rb]]
  return file_path:sub(-#ending) == ending
end

local function get_rspec_command()
  local default_command = 'bundle exec spring rspec'
  local user_override_command = vim.api.nvim_get_var('nrspec_user_command_override')
  if(user_override_command)
  then
    return user_override_command
  else
    return default_command
  end
end

function M.nrspec_run_current_file()
  local full_path = vim.fn.expand('%f')

  if( not is_spec_file(full_path) )
    -- please, continue
  then
    M.nrspec_run_last_command()
    return
  end

  local full_command = string.format("%s %s", get_rspec_command(), full_path)
  local command_with_msg = string.format(
    "terminal echo ' >>> Running spec file: %s\\n' && %s", full_command, full_command
  )
  vim.api.nvim_set_var('nrspec_last_full_command', full_command)
  vim.api.nvim_command('w')
  vim.api.nvim_command(command_with_msg)
end

function M.nrspec_run_current_line()
  local file_path = vim.fn.expand('%f')

  if( not is_spec_file(file_path) )
    -- please, continue
  then
    M.nrspec_run_last_command()
    return
  end

  local line_number = vim.fn.line('.')
  local full_path = string.format("%s:%s", file_path, line_number)
  local full_command = string.format("%s %s", get_rspec_command(), full_path)
  local command_with_msg = string.format(
    "terminal echo ' >>> Running spec line: %s\\n' && %s", full_command, full_command
  )
  vim.api.nvim_set_var('nrspec_last_full_command', full_command)
  vim.api.nvim_command('w')
  vim.api.nvim_command(command_with_msg)
end

function M.nrspec_run_last_command()
  local file_path = vim.fn.expand('%f')
  local line_number = vim.fn.line('.')
  local full_command = vim.api.nvim_get_var("nrspec_last_full_command")
  local command_with_msg = string.format(
    "terminal echo ' >>> Running last rspec command: %s\\n' && %s", full_command, full_command
  )
  vim.api.nvim_command('w')
  vim.api.nvim_command(command_with_msg)
end

function M.nrspec_run_last_failed()
  local full_command = string.format("%s --only-failures", get_rspec_command())
  local command_with_msg = string.format(
    "terminal echo ' >>> Running last failed specs: %s\\n' && %s", full_command, full_command
  )
  vim.api.nvim_command('w')
  vim.api.nvim_command(command_with_msg)
end

function M.nrspec_override_command()
  -- this is very likely pure retardness
  local vars = vim.api.nvim_command("let nrspec_user_command_override = input('Override nrspec command: ')")
end

return M

