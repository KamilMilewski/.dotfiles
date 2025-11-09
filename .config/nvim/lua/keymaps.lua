local map = vim.api.nvim_set_keymap

-- Set ladder key
vim.g.mapleader = ' '
map('n', '<Space>', '', { noremap = true })

-- Make movement between wrapped lines easier
map('n', 'j', 'gj', { noremap = true })
map('n', 'k', 'gk', { noremap = true })

-- Remap "leave insert mode". Works in nvim terminal too.
map('t', '<C-s>', '<C-\\><C-n>', { noremap = true })

-- Map `leave insert mode` to ctrl+s
map('i', '<C-s>', '<ESC>', { noremap = true })

-- Quick exit
map('n', '<leader>x', '<cmd>:qa!<CR>', { noremap = true })

-- Close current buffer
map('n', '<leader>w', '<cmd>:bd<CR>', { noremap = true })

-- Clear search highlight
map('n', '<leader>ch', '<cmd>:noh<CR>', { noremap = true })

-- Run clean code
map('n', '<leader>cc', '<cmd>lua CleanCode()<CR>', { noremap = true })

-- Run clean buffers
map('n', '<leader>cb', '<cmd>lua CleanBuffers()<CR>', { noremap = true })

-- Git open blame
map('n', '<leader>vb', '<cmd>:Git blame<CR>', { noremap = true })
-- Git diff
map('n', '<leader>vd', '<cmd>:terminal g d<CR>', { noremap = true })
-- Git quick save
map('n', '<leader>vz', '<cmd>:terminal g qs<CR>', { noremap = true })

-- Open linter error in a 'popup'
map('n', '<space>e', '<cmd>:lua vim.diagnostic.open_float(0, {scope="line"})<CR>', { noremap = true })

-- nvim_rspec (nrspec) related
map('n', '<leader>sf', [[<cmd>lua require('plugin/nvim_rspec').nrspec_run_current_file()<CR>]], { noremap = true })
map('n', '<leader>sl', [[<cmd>lua require('plugin/nvim_rspec').nrspec_run_current_line()<CR> ]], { noremap = true })
map('n', '<leader>sm', [[<cmd>lua require('plugin/nvim_rspec').nrspec_run_last_command()<CR> ]], { noremap = true })
map('n', '<leader>sn', [[<cmd>lua require('plugin/nvim_rspec').nrspec_run_last_failed()<CR> ]], { noremap = true })
map('n', '<leader>so', [[<cmd>lua require('plugin/nvim_rspec').nrspec_override_command()<CR>]], { noremap = true })
map('n', '<leader>sj', [[<cmd>lua require('plugin/nvim_rspec').create_spec()<CR>]], { noremap = true })

-- Yank current line without leading/trailing whitespace (to system clipboard, with highlight)
vim.keymap.set('n', '<leader>yy', function()
  local line = vim.fn.getline('.')
  line = string.gsub(line, '^%s*(.-)%s*$', '%1')  -- trim both sides
  vim.fn.setreg('+', line)                        -- copy to system clipboard

  -- manually highlight the yanked line
  local ns = vim.api.nvim_create_namespace('trimmed_yank')
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.fn.line('.') - 1  -- 0-based
  local _id = vim.api.nvim_buf_add_highlight(bufnr, ns, 'IncSearch', lnum, 0, -1)

  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  end, 150)  -- 150 ms like regular yank flash
end, { desc = 'Yank line trimmed (clipboard)' })

-- lsp related keymaps are defined in .config/nvim/lua/lsp_config/lsp_shared_config.lua
