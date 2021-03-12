local map = vim.api.nvim_set_keymap

-- Set ladder key
map('n', '<Space>', '', { noremap = true })
vim.g.mapleader = ' '

-- Remap "leave insert mode"
map('i', 'jj', '<esc>', { noremap = true })

-- Make movement between wrapped lines easier
map('n', 'j', 'gj', { noremap = true })
map('n', 'k', 'gk', { noremap = true })

-- Remap `leave insert mode` to ctrl+s in terminal
map('i', '<C-s>', '<ESC>', { noremap = true })
