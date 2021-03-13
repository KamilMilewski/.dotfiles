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

-- Map copy to system clipboard
map('v', '<leader>y', '"+y', { noremap = true })

-- Map leave insert mode in vim terminal to ctrl+s
map('t', '<C-s>', '<C-\\><C-n>', { noremap = true })

-- Quick exit
map('n', '<leader>qq', '<cmd>:qa!<CR>', { noremap = true })

-- Map Rspec runner functions
map('n', '<leader>sf', '<cmd>lua run_current_spec_file()<CR>', { noremap = true })
map('n', '<leader>sl', '<cmd>lua run_current_spec_line()<CR>', { noremap = true })
map('n', '<leader>sm', '<cmd>lua run_last_spec_command()<CR>', { noremap = true })

