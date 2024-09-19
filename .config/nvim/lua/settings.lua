local o = vim.o -- options
local wo = vim.wo -- window options
local bo = vim.bo -- buffer options

-- Set smartcase (will go case sensitive when upper case chars are in search,
-- ignore case needs to be set first for this to work)
o.ignorecase = true
o.smartcase = true

-- Enable line numbers bar
wo.number = true

-- Do not wrap lines at the right edge of the screen
wo.wrap = false

-- Indenting is 2 spaces
o.shiftwidth = 2

-- Allows to switch buffers with unsaved changes
o.hidden = true

-- Other settings:
o.timeoutlen= 1000
o.ttimeoutlen = 5
o.encoding = 'UTF-8'

-- Enable spell check
wo.spell = true
bo.spelllang = 'en,pl'

-- Enable Folding
wo.foldmethod = 'indent'
o.foldlevelstart = 99 -- start unfolded

-- Enable vertical bar at 120chars
wo.colorcolumn = '120'

-- to start scrolling starting n lines away from top/bottom
o.scrolloff = 4

-- Disable swap file
o.swapfile = false
bo.swapfile = false

-- Disable creation of backup files
o.backup = false

-- line below allows to do ':set list' to display white space characters
o.listchars = 'eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣'

