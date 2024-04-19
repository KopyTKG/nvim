vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", vim.cmd.w)

-- Keymaps for external programs
vim.keymap.set("n", "<F12>", function()
	vim.cmd("terminal lazygit")
	vim.cmd("startinsert")
end, { noremap=true,  silent = true })
