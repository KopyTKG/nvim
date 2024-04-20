vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", vim.cmd.w)

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keymaps for external programs
vim.keymap.set("n", "<F12>", function()
	vim.cmd("terminal lazygit")
	vim.cmd("startinsert")
end, { noremap=true,  silent = true })


-- Keymaps for LSP
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {desc = "Go to previous [D]iagnostic message"})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {desc = "Go to next [D]iagnostic message"})
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {desc = "Set [Q]uickfix list"})
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {desc = "Open [E]rror diagnostics"})

-- Split navigations
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", {desc = "Move to the left window"})
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", {desc = "Move to the right window"})


