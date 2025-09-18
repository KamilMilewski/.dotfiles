-- NOTE: This config solves the issue with LSP not working in case there are two Gemfiles present in the project (for
-- example there is another Gemfile in the Rails engine)

local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

lspconfig.ruby_lsp.setup({
  -- Prefer .git/ if found
  -- Otherwise use Gemfile
  -- And finally fallback to current dir

  root_dir = util.root_pattern(".git", "Gemfile", "."),
})
