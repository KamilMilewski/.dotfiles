-- NOTE: Get the default branch of the current git repo
-- Falls back to "master" if detection fails.
local function get_default_branch()
  local handle = io.popen("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null")
  if not handle then
    return "master"
  end

  local result = handle:read("*a")
  handle:close()

  if not result or result == "" then
    return "master"
  end

  -- result looks like: "refs/remotes/origin/main\n"
  local branch = result:match("refs/remotes/origin/(.+)")
  return vim.trim(branch or "master")
end

vim.api.nvim_create_user_command("GetDefaultBranch", function()
  local branch = get_default_branch()
  vim.notify("Default branch: " .. branch, vim.log.levels.INFO)
end, {})

-- NOTE: command that allows to reset currently opened file to master branch
vim.api.nvim_create_user_command("ResetToMaster", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file loaded", vim.log.levels.ERROR)
    return
  end

  local branch = get_default_branch()

  local cmd = { "git", "restore", "--source=" .. branch, "--", file }
  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Reset " .. file .. " to " .. branch .. " (unstaged)", vim.log.levels.INFO)
        vim.cmd("edit!")
      else
        vim.notify("Failed to reset " .. file .. " to " .. branch, vim.log.levels.ERROR)
      end
    end,
  })
end, {})
