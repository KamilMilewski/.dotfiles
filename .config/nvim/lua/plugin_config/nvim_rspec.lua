local map = vim.api.nvim_set_keymap

map('n', '<leader>sf', [[<cmd>lua require('plugin/nvim_rspec').nrspec_run_current_file()<CR>]], { noremap = true })
map('n', '<leader>sl', [[<cmd>lua require('plugin/nvim_rspec').nrspec_run_current_line()<CR> ]], { noremap = true })
map('n', '<leader>sm', [[<cmd>lua require('plugin/nvim_rspec').nrspec_run_last_command()<CR> ]], { noremap = true })
map('n', '<leader>sn', [[<cmd>lua require('plugin/nvim_rspec').nrspec_run_last_failed()<CR> ]], { noremap = true })
map('n', '<leader>so', [[<cmd>lua require('plugin/nvim_rspec').nrspec_override_command()<CR>]], { noremap = true })
map('n', '<leader>sj', [[<cmd>lua require('plugin/nvim_rspec').create_spec()<CR>]], { noremap = true })

