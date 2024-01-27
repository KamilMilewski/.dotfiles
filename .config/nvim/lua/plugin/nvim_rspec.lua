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

-- returns true if string 'String' starts with 'Start' string
-- example usage:
-- string.starts("some string", "some")
-- => true
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

-- tries to open corresponding spec or creates if it doesn't exists
local function handle_spec(spec_type, generator_name)
  -- for app/concepts/user/create.rb variables will be:
  local resource = vim.fn.expand('%:h:t') -- user
  local action = vim.fn.expand('%:t:r')   -- create

  local spec_path = "spec/" .. spec_type .. "/" .. resource .. "/" .. action .. "_spec.rb"
  if(vim.fn.filereadable(spec_path) == 1)
  then
    vim.api.nvim_echo({{'Spec already exists', 'None'}}, false, {})
  else
    local command = string.format("bin/rails generate %s --resource %s --action %s", generator_name, resource, action)
    os.execute(command)
    local message = "Created spec file: '" .. spec_path .. "' by running command: '" .. command .. "'"
    vim.api.nvim_echo({{message, 'None'}}, false, {})
  end
  vim.cmd.edit(spec_path) -- to open just created/found spec file
end

local function handle_migrate_spec(migration_path)
  local spec_path = "spec/" .. string.gsub(migration_path, ".rb", "_spec.rb")

  if(vim.fn.filereadable(spec_path) == 1)
  then
    vim.api.nvim_echo({{'Spec already exists', 'None'}}, false, {})
  else
    local command = string.format("bin/rails generate migration_spec --migration_path %s", migration_path)
    os.execute(command)
    local message = "Created spec file: '" .. spec_path .. "' by running command: '" .. command .. "'"
    vim.api.nvim_echo({{message, 'None'}}, false, {})
  end
  vim.cmd.edit(spec_path) -- to open just created/found spec file
end

function M.create_spec()
  -- CASES TO HANDLE:
  --
  -- TODO:
  -- app/controllers/api/v1/users_controller.rb
  -- -- spec/requests/api/v1/users_controller_spec.rb
  --
  -- DONE:
  -- db/migrate/20230530110641_do_stuff.rb
  -- -- spec/db/migrate/20230731125129_do_stuff_spec.rb
  -- app/services/user/do_it.rb
  -- -- spec/services/user/do_it_spec.rg
  -- app/concepts/user/create.rb:
  -- -- spec/concepts/user/create_spec.rg

  local current_path = vim.fn.expand('%')
  if(string.starts(current_path, "app/concepts/"))
    then handle_spec("concepts", "operation_spec")
  elseif(string.starts(current_path, "app/services/"))
    then handle_spec("services", "service_spec")
  elseif(string.starts(current_path, "db/migrate"))
    then handle_migrate_spec(current_path)
  else
    vim.api.nvim_echo({{"Unhandled spec type", 'None'}}, false, {})
  end
end

return M

