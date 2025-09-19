-- NOTE: Force yaml files to be always detected as such. This is because vim-rails pluging tends to incorrectly detect
-- all yaml/yml files as eruby.yaml for some reason. This disrupts syntax highlighting and gets in a way of
-- .config/nvim/lua/copy_path_config.lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "eruby.yaml",
  callback = function()
    local fname = vim.api.nvim_buf_get_name(0)
    if not fname:match("%.ya?ml%.erb$") then
      -- NOTE: Only override if the file is NOT a real ERB template
      vim.bo.filetype = "yaml"
    end
  end,
})
