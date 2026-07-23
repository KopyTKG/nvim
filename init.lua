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

-- Split navigations
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Scroll buffer
vim.opt.scrolloff = 10

-- Never show folded text. Some buffers — notably Roslyn's decompiled metadata
-- sources opened by "go to definition" — arrive folded, hiding everything but a
-- "+-- N lines" header. Disable folding outright, and re-enforce it whenever a
-- window shows a buffer (those metadata buffers are displayed after startup so
-- a one-time option isn't enough).
vim.opt.foldenable = false
vim.opt.foldlevelstart = 99
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "BufReadPost" }, {
  group = vim.api.nvim_create_augroup("kopy_no_folds", { clear = true }),
  callback = function()
    vim.wo.foldenable = false
  end,
})

-- Change Netrw directory listing
vim.g.netrw_liststyle = 0

-- Enable true color support
vim.o.termguicolors = true

-- Relative line numbers with cursor line number
vim.opt.number = true
vim.opt.cursorline = true

-- Set leader key to space
vim.g.mapleader = " "

require "lazy.init"
require "kopy.init"

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("Highlight on yank", {
    clear = true,
  }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--vim.api.nvim_exec(
--  [[
--augroup FormatAutogroup
--  autocmd!
--  autocmd BufWritePost * FormatWrite
--augroup END
--]],
--  true
--)

-- Fix leaking leader key in insert mode to use space normally
vim.api.nvim_set_keymap(
  "i",
  "<Space>",
  "<Space>",
  { noremap = true, silent = true }
)

-- Treesitter initializes properly on its own - no manual re-enabling needed
