local LspSharedConfig = require("lsp_config/lsp_shared_config")
vim.lsp.config('ruby_lsp', {
  on_attach = LspSharedConfig.on_attach,
  root_markers = { "Gemfile.lock", "Gemfile", ".git" }
})
vim.lsp.enable("ruby_lsp")
