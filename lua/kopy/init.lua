require("kopy.remap")

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
vim.opt.timeoutlen = 300

-- Split navigations
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Scroll buffer
vim.opt.scrolloff = 10

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = vim.api.nvim_create_augroup("Highlight on yank", {clear = true}),
	callback = function()
		vim.highlight.on_yank()
	end,
})
