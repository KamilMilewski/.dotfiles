local map = vim.api.nvim_set_keymap

-- Set ladder key
map('n', '<Space>', '', { noremap = true })
vim.g.mapleader = ' '

-- Remap "leave insert mode"
map('i', 'jj', '<esc>', { noremap = true })

-- Make movement between wrapped lines easier
map('n', 'j', 'gj', { noremap = true })
map('n', 'k', 'gk', { noremap = true })

-- Map copy to system clipboard
map('v', '<leader>y', '"+y', { noremap = true })

-- Map `leave insert mode` in vim terminal to ctrl+s
map('t', '<C-s>', '<C-\\><C-n>', { noremap = true })

-- Map `leave insert mode` to ctrl+s
map('i', '<C-s>', '<ESC>', { noremap = true })

-- Quick exit
map('n', '<leader>qq', '<cmd>:qa!<CR>', { noremap = true })

-- Clear search highlight
map('n', '<leader>ch', '<cmd>:noh<CR>', { noremap = true })

-- Run clean code
map('n', '<leader>cc', '<cmd>lua clean_code()<CR>', { noremap = true })
