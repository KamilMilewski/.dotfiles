local api = vim.api

-- Remap "leave insert mode"
vim.api.nvim_set_keymap('i', 'jj', '<esc>', {})
-- Make movement between wrapped lines easier
vim.api.nvim_set_keymap('n', 'j', 'gj', {})
vim.api.nvim_set_keymap('n', 'k', 'gk', {})