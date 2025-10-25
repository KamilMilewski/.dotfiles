-- check for Untracked and Staged changes asynchronously and return currently cached values in a form of `US`, `U` or `S`
-- shell snippets used below exits with code 0 if there are untracked (or staged in second job) changes found
-- (test -n checks if git command returned any character and returns status 0 if it does). It is then being checked
-- in on_exit callback
local GitUntrackedStatusCache = ''
local GitStagedStatusCache = ''

local function GitUntrackedCallback(_, data, _)
  if data == 0 then GitUntrackedStatusCache = 'U' else GitUntrackedStatusCache = '' end
end
local function GitStagedCallback(_, data, _)
  if data == 0 then GitStagedStatusCache = 'S' else GitStagedStatusCache = '' end
end

-- This function is being called by lualine
function GitCheckForBranchChanges()
  vim.fn.jobstart("test -n \"$(git diff --name-only)\"", 	  { on_exit = GitUntrackedCallback })
  vim.fn.jobstart("test -n \"$(git diff --name-only --cached)\"", { on_exit = GitStagedCallback })

  return (GitUntrackedStatusCache .. GitStagedStatusCache)
end

function LspProgress()
  -- 1) Prefer the aggregated progress string (returns "" when nothing's happening)
  if vim.lsp.status then
    local s = vim.lsp.status()
    if type(s) == "string" and s ~= "" then
      return "vim.lsp.status(): " .. s
    end
  end

  -- 2) Otherwise list attached clients using the new API
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = {}
  if vim.lsp.get_clients then
    clients = vim.lsp.get_clients({ bufnr = bufnr })
  end

  if not clients or #clients == 0 then
    return "no LSP clients"
  end

  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return "[" .. table.concat(names, ", ") .. "]"
end
