local map = vim.api.nvim_set_keymap

map('n', '<leader>sf', '<cmd>lua nrspec_run_current_file()<CR>', { noremap = true })
map('n', '<leader>sl', '<cmd>lua nrspec_run_current_line()<CR>', { noremap = true })
map('n', '<leader>sm', '<cmd>lua nrspec_run_last_command()<CR>', { noremap = true })
