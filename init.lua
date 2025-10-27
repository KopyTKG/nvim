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

-- Ensure treesitter highlighting enabled for new buffers (covers Telescope previews)
vim.api.nvim_create_autocmd({
  "BufReadPost",
  "BufNewFile",
  "FileType",
  "BufEnter",
  "BufWinEnter",
  "VimEnter",
}, {
  callback = function()
    -- If TSBufEnable command exists, call it
    if vim.fn.exists ":TSBufEnable" == 2 then
      pcall(vim.cmd, "TSBufEnable highlight")
      return
    end

    -- Otherwise, attempt to enable when a parser exists for this buffer
    pcall(function()
      local ok, parser = pcall(vim.treesitter.get_parser, 0)
      if ok and parser then
        pcall(vim.cmd, "TSBufEnable highlight")
      end
    end)
  end,
})
