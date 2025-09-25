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

  -- get current cursor position
  local cursor = vim.api.nvim_win_get_cursor(0)

  -- get blob content from git
  local cmd = { "git", "show", branch .. ":" .. vim.fn.fnamemodify(file, ":.") }

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if not data then return end
      -- replace buffer content
      vim.api.nvim_buf_set_lines(0, 0, -1, false, data)
      -- restore cursor
      vim.api.nvim_win_set_cursor(0, cursor)
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Loaded " .. file .. " from " .. branch .. " into buffer (unsaved)", vim.log.levels.INFO)
      else
        vim.notify("Failed to load " .. file .. " from " .. branch, vim.log.levels.ERROR)
      end
    end,
  })
end, {})
