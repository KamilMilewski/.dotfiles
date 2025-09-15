-- MIGEATION HELPERS
-- Rails migration helpers with proper :terminal buffer
local function get_migration_version()
  local filename = vim.fn.expand("%:t") -- current file name
  local version = string.match(filename, "^(%d+)_") -- grab leading digits
  return version
end

local function run_in_terminal(cmd)
  local full_cmd = table.concat(cmd, " ")
  vim.cmd("botright split | resize 15 | terminal " .. full_cmd)
end

vim.api.nvim_create_user_command("Migrate", function()
  local version = get_migration_version()
  if not version then
    print("Not a migration file!")
    return
  end
  run_in_terminal({ "bin/rails", "db:migrate:up", "VERSION=" .. version })
end, {})

vim.api.nvim_create_user_command("Rollback", function()
  local version = get_migration_version()
  if not version then
    print("Not a migration file!")
    return
  end
  run_in_terminal({ "bin/rails", "db:migrate:down", "VERSION=" .. version })
end, {})
