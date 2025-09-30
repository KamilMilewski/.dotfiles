local lspconfig = require("lspconfig")
local LspSharedConfig = require("lsp_config/lsp_shared_config")
local util = require("lspconfig.util")

-- Ruby
lspconfig.ruby_lsp.setup({
  -- NOTE: This piece solves the issue with LSP not working in case there are two Gemfiles present in the project (for
  -- example there is another Gemfile in the Rails engine)
  -- Prefer .git/ if found
  -- Otherwise use Gemfile
  -- And finally fallback to current dir
  root_dir = util.root_pattern(".git", "Gemfile", "."),

  on_attach = LspSharedConfig.on_attach,
  flags = { debounce_text_changes = 150 },
})

-- -- Lua
-- lspconfig.lua_ls.setup({
--   on_attach = LspSharedConfig.on_attach,
-- })
