local LspSharedConfig = require("lsp_config/lsp_shared_config")
vim.lsp.config('lua_ls', {
  on_attach = LspSharedConfig.on_attach,
})
vim.lsp.enable("lua_ls")
