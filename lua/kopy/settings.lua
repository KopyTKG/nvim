-- Set relative line numbers
vim.opt.relativenumber = true
-- Set mouse to work in all modes
vim.opt.mouse = "a"

-- Set clipboard to system clipboard
vim.opt.clipboard = "unnamedplus"

-- Set breakindent
vim.opt.breakindent = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Save undo history
vim.opt.undofile = true

-- Keep sign column open
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 250

-- Split avigations
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Scroll buffer
vim.opt.scrolloff = 10

-- Change Netrw directory listing
vim.g.netrw_liststyle = 0

-- Enable true color support
vim.o.termguicolors = true

-- Enable true color support
vim.o.termguicolors = true

-- Relative line numbers with cursor line number
vim.opt.number = true
vim.opt.cursorline = true

-- Set leader key to space
vim.g.mapleader = " "
