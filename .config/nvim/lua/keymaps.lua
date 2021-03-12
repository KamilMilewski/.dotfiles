local api = vim.api

-- Remap "leave insert mode"
api.nvim_set_keymap('i', 'jj', '<esc>', {})

-- Make movement between wrapped lines easier
api.nvim_set_keymap('n', 'j', 'gj', {})
api.nvim_set_keymap('n', 'k', 'gk', {})

-- Remap `leave insert mode` to ctrl+s in terminal
api.nvim_set_keymap('i', '<C-s>', '<ESC>', {})
