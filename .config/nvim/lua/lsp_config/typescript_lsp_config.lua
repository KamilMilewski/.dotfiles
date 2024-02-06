require'lspconfig'.tsserver.setup{
  on_attach = require'lsp_config/lsp_shared_config'.setup_keymaps,
  flags = {
    debounce_text_changes = 150,
  }
}
