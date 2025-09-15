require('plugins')
require('settings')
require('keymaps')
require('plugin_config/lualine')
require('lsp_config/ruby_lsp_config')
require('lsp_config/lua_lsp_config')
require('autocomplete_config')
require('treesitter_config')
require('rails_migrations_helpers')

function CleanCode()
  vim.api.nvim_command('w')

  if vim.fn.filereadable('.rubocop.yml') == 1 then
    vim.api.nvim_command("terminal bundle exec rubocop -A -c .rubocop.yml %")
  else
    vim.api.nvim_command("terminal bundle exec rubocop -A %")
  end
end

function CleanBuffers()
  -- %bdelete   - delete all buffers
  -- edit #     - opens file for edition. `#` in this context means alternate file name (previously being opened)
  -- #bd        - delete the [No Name] buffer
  -- normal `"  - execute in normal mode: go to last line number

  vim.api.nvim_command("%bdelete|edit #| bd# |normal `\"")
end

-- nvim-lspconfig related
-- Uncomment line below when debugging LSP. Causes degraded performance and disk usage.
-- vim.lsp.set_log_level("debug")

-- Gruvbox color themer related
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])




local ts_utils = require('nvim-treesitter.ts_utils')

local function get_yaml_path()
  local node = ts_utils.get_node_at_cursor()
  local path = {}

  -- Climb to the nearest block_mapping_pair if starting on a value or scalar
  while node and node:type() ~= 'block_mapping_pair' do
    node = node:parent()
  end

  while node do
    if node:type() == 'block_mapping_pair' then
      local key_node = node:child(0)
      if key_node then
        local key_text = vim.treesitter.get_node_text(key_node, 0)
        table.insert(path, 1, key_text)
      end
    end
    node = node:parent()
  end

  if #path == 0 then
    print("No YAML path found")
    return
  end

  local result = table.concat(path, '.')
  vim.fn.setreg('+', result)
  print("YAML Path: " .. result)
end

local function get_ruby_constant_path()
  local node = ts_utils.get_node_at_cursor()
  local path = {}

  while node do
    local type = node:type()
    if type == 'class' or type == 'module' then
      local name_node = node:child(1)
      if name_node then
        local name = vim.treesitter.get_node_text(name_node, 0)
        table.insert(path, 1, name)
      end
    end
    node = node:parent()
  end

  local result = table.concat(path, '::')
  vim.fn.setreg('+', result)
  print("Constant name: " .. result)
end

-- Unified context-aware function
local yaml_like_filetypes = {
  yaml = true,
  yml = true,
  ['eruby.yaml'] = true,
  ['yaml.erb'] = true,
}

local function CopyContextPath()
  local ft = vim.bo.filetype

  if yaml_like_filetypes[ft] then
    get_yaml_path()
  elseif ft == 'ruby' then
    get_ruby_constant_path()
  else
    print("Unsupported filetype: " .. ft)
  end
end

-- Keybinding and command
vim.api.nvim_create_user_command('Cp', CopyContextPath, {}) -- Cp - as Copy path
vim.keymap.set('n', '<leader>yp', ':Cp<CR>', { noremap = true, silent = true })
