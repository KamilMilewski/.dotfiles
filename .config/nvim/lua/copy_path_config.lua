-- NOTE: Depending on the context it:
-- - Ruby: allows to copy constant name under cursor
-- - YAML: allows to copy full path of a key under cursor

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
