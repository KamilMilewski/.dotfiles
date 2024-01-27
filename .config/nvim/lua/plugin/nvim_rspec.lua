local M = {}
vim.api.nvim_set_var('nrspec_user_command_override', nil)

local function is_spec_file(file_path)
  local ending = [[_spec.rb]]
  return file_path:sub(-#ending) == ending
end

local function get_rspec_command()
  local default_command = 'bundle exec rspec'
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
    -- its not a spec file, let's run last executed spec then
    M.nrspec_run_last_command()
    return
  end

  local full_command = string.format("%s %s", get_rspec_command(), full_path)
  local command_with_msg = string.format(
    "terminal echo ' >>> Running spec file: %s\\n' && %s", full_command, full_command
  )
  vim.api.nvim_set_var('nrspec_last_full_command', full_command)
  vim.api.nvim_command('w') -- save current buffer first
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
  vim.api.nvim_command('w') -- save current buffer first
  vim.api.nvim_command(command_with_msg)
end

function M.nrspec_run_last_command()
  local full_command = vim.api.nvim_get_var("nrspec_last_full_command")
  local command_with_msg = string.format(
    "terminal echo ' >>> Running last rspec command: %s\\n' && %s", full_command, full_command
  )
  vim.api.nvim_command('w') -- save current buffer first
  vim.api.nvim_command(command_with_msg)
end

function M.nrspec_run_last_failed()
  local full_command = string.format("%s --only-failures", get_rspec_command())
  local command_with_msg = string.format(
    "terminal echo ' >>> Running last failed specs: %s\\n' && %s", full_command, full_command
  )
  vim.api.nvim_command('w') -- save current buffer first
  vim.api.nvim_command(command_with_msg)
end

function M.nrspec_override_command()
  -- this is very likely pure retardness
  vim.api.nvim_command("let nrspec_user_command_override = input('Override nrspec command: ')")
end

function M.create_spec()
  local resource = vim.fn.expand('%:h:t')
  local action = vim.fn.expand('%:t:r')

  local spec_path = "spec/concepts/" .. resource .. "/" .. action .. "_spec.rb"
  if(vim.fn.filereadable(spec_path) == 1)
  then
    vim.api.nvim_echo({{'Spec already exists', 'None'}}, false, {})
  else
    local command = string.format("bin/rails generate operation_spec --resource %s --action %s", resource, action)
    os.execute(command)
    local message = "Created spec file: '" .. spec_path .. "' by running command: '" .. command .. "'"
    vim.api.nvim_echo({{message, 'None'}}, false, {})
  end
  vim.cmd.edit(spec_path) -- to open just created/found spec file
end

return M

