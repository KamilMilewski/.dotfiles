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

