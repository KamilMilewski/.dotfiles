-- textDocument/diagnostic support until 0.10.0 is released. Consider removing after that.
-- from https://github.com/Shopify/ruby-lsp/blob/main/EDITORS.md#neovim-lsp
_timers = {}
local function setup_diagnostics(client, buffer)
  if require("vim.lsp.diagnostic")._enable then
    return
  end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)
    client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
      if err then
        local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
        vim.lsp.log.error(err_msg)
      end
      local diagnostic_items = {}
      if result then
        diagnostic_items = result.items
      end
      vim.lsp.diagnostic.on_publish_diagnostics(
        nil,
        vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
        { client_id = client.id }
      )
    end)
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,
    on_detach = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
    end,
  })
end

local on_attach = function(client, bufnr)
  require'lsp_config/lsp_shared_config'.setup_keymaps(client, bufnr)
  setup_diagnostics(client, bufnr)
end

require'lspconfig'.ruby_lsp.setup{
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  }
}
