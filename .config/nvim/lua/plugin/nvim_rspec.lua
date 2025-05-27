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

local generic_spec_content = [[
# frozen_string_literal: true

require \"rails_helper\"

RSpec.describe YourConstantHere do
end]]
function M.create_spec()
  -- HANDLED CASES:
  -- app/controllers/api/v1/users_controller.rb
  -- -- spec/requests/api/v1/users_controller_spec.rb
  -- db/migrate/20230530110641_do_stuff.rb
  -- -- spec/db/migrate/20230731125129_do_stuff_spec.rb
  -- app/services/user/do_it.rb
  -- -- spec/services/user/do_it_spec.rg
  -- app/concepts/user/create.rb:
  -- -- spec/concepts/user/create_spec.rg
  -- app/jobs/hard_job.rb
  -- -- spec/jobs/hard_job_spec.rb
  --
  -- and more

  local spec_to_file_mapping = {
    {
      ["match_file_path"] = function (path) return string.starts(path, "spec/db/migrate/") end,
      ["get_file_path"]   = function (path)
	path = string.gsub(path, "_spec.rb", ".rb")
	return string.gsub(path, "spec/", "")
      end
    },
    {
      ["match_file_path"] = function (path) return string.starts(path, "spec/requests/") end,
      ["get_file_path"]   = function (path)
	path = string.gsub(path, "_spec.rb", ".rb")
	return string.gsub(path, "spec/requests/", "app/controllers/")
      end
    },
    {
      ["match_file_path"] = function (path) return string.starts(path, "spec/engines/") end,
      ["get_file_path"]   = function (path)
	path = string.gsub(path, "_spec.rb", ".rb")
	return string.gsub(path, "spec/engines/", "engines/")
      end
    },
    { -- a default branch for generic, simple case where spec file path closely reflects path to the tested file
      ["match_file_path"] = function () return true end,
      ["get_file_path"]   = function (path)
	path = string.gsub(path, "_spec.rb", ".rb")
	return string.gsub(path, "spec/", "app/")
      end
    },
  }

  local file_to_spec_mapping = {
    {
      ["match_file_path"]       = function (path)
	return (
	  string.starts(path, "app/concepts/")
	  and not string.find(path, "/contract/")
	  and not string.find(path, "/macro/")
	  and not string.find(path, "/input/")
	)
      end,
      ["get_file_path"]         = function (path)
	path = string.gsub(path, ".rb", "_spec.rb")
	return string.gsub(path, "app/concepts", "spec/concepts")
      end,
      ["get_spec_file_command"] = function (path)
	return string.format("bin/rails generate operation_spec --file_path %s", path)
      end
    },
    {
      ["match_file_path"]       = function (path) return string.starts(path, "app/services/") end,
      ["get_file_path"]         = function (path)
	path = string.gsub(path, ".rb", "_spec.rb")
	return string.gsub(path, "app/services", "spec/services")
      end,
      ["get_spec_file_command"] = function (path)
	return string.format("bin/rails generate service_spec --file_path %s", path)
      end
    },
    {
      ["match_file_path"]       = function (path) return string.starts(path, "db/migrate/") end,
      ["get_file_path"]         = function (path)
	return "spec/" .. string.gsub(path, ".rb", "_spec.rb")
      end,
      ["get_spec_file_command"] = function (path)
	return string.format("bin/rails generate migration_spec --file_path %s", path)
      end
    },
    {
      ["match_file_path"]       = function (path) return string.starts(path, "app/controllers/api/v1/") end,
      ["get_file_path"]         = function (path)
	path =  string.gsub(path, "app/controllers/", "spec/controllers/")
	return string.gsub(path, ".rb", "_spec.rb")
      end,
      ["get_spec_file_command"] = function (path)
	return string.format("bin/rails generate controller_spec --file_path %s", path)
      end
    },
    {
      ["match_file_path"]       = function (path) return string.starts(path, "app/jobs/") end,
      ["get_file_path"]         = function (path)
	path = string.gsub(path, ".rb", "_spec.rb")
	return  string.gsub(path, "app/jobs", "spec/jobs")
      end,
      ["get_spec_file_command"] = function (path)
	return string.format("bin/rails generate job_spec --file_path %s", path)
      end
    },
    -- Generic specs below (won't have ruby generator run for them)
    {
      ["match_file_path"]       = function (path) return string.starts(path, "app/") end,
      ["get_file_path"]         = function (path)
	path = string.gsub(path, ".rb", "_spec.rb")
	return  string.gsub(path, "app/", "spec/")
      end,
      ["get_spec_file_command"] = function (path)
	path = string.gsub(path, ".rb", "_spec.rb")
	path = string.gsub(path, "app/", "spec/")

	local directory_path = string.gsub(path, '%w+_spec.rb\z', "")

	return string.format('mkdir -p %s && echo "%s" > %s', directory_path, generic_spec_content, path)
      end,
      ["message"]  	 = "\nSpec file created"
    },
    {
      ["match_file_path"]       = function (path) return string.starts(path, "engines/") end,
      ["get_file_path"]         = function (path)
	path = string.gsub(path, ".rb", "_spec.rb")
	return  string.gsub(path, "engines/", "spec/engines/")
      end,
      ["get_spec_file_command"] = function (path)
	path = string.gsub(path, ".rb", "_spec.rb")
	path = string.gsub(path, "engines/", "spec/engines/")

	local directory_path = string.gsub(path, '%w+_spec.rb\z', "")

	return string.format('mkdir -p %s && echo "%s" > %s', directory_path, generic_spec_content, path)
      end,
      ["message"]  	 = "\nSpec file created"
    },
  }

  -- as just `expand("%")` sometimes yields path relative to current working directory and sometimes an absolute path.
  -- Read more at https://stackoverflow.com/questions/4525261/getting-relative-paths-in-vim#comment34943121_22856943
  local current_path = vim.fn.expand("%:~:.")

  if(string.starts(current_path, "spec/")) then
    local file_path

    for _, mapping_case in ipairs(spec_to_file_mapping) do
      if (mapping_case.match_file_path(current_path)) then
	file_path = mapping_case.get_file_path(current_path)
	break
      end
    end

    vim.cmd.edit(file_path) -- open corresponding tested file
  else
    local spec_path
    local command
    local custom_message

    for i, mapping_case in ipairs(file_to_spec_mapping) do
      if (mapping_case.match_file_path(current_path)) then
	spec_path      = mapping_case.get_file_path(current_path)
	command        = mapping_case.get_spec_file_command(current_path)
	custom_message = mapping_case.message
	break
      end

      if(file_to_spec_mapping[i + 1]) == nil then -- if its the last element and nothing has been found up until now
	vim.api.nvim_echo({{"Unhandled spec type: " .. current_path, 'None'}}, false, {})
	return
      end
    end

    if(vim.fn.filereadable(spec_path) == 1) then
      vim.api.nvim_echo({{'Moved to existing spec', 'None'}}, false, {})
      vim.cmd.edit(spec_path) -- open found spec
    else
      local userConfirmation = vim.fn.input("No spec file found - should I create it (y/n)?: ")
      local message

      if (userConfirmation == "y") then
	os.execute(command)
	message = custom_message or ("\nCreated spec file: '" .. spec_path .. "' by running command: '" .. command .. "'")
	vim.cmd.edit(spec_path) -- open created spec
      else
	message = " Aborted"
      end
      vim.api.nvim_echo({{message, 'None'}}, false, {})
    end
  end
end

return M

