vim.g.mapleader = " "

vim.keymap.set({"n", "i", "v"},"<leader>s", "")


vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", vim.cmd.w)
vim.keymap.set("n", "<leader>c", [[:%s/<C-r><C-w>//g<Left><Left>]])

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keymaps for external programs
vim.keymap.set("n", "<F12>", function()
	vim.cmd("terminal lazygit")
	vim.cmd("startinsert")
end, { noremap = true, silent = true })


-- Keymaps for LSP
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Set [Q]uickfix list" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open [E]rror diagnostics" })

-- Split navigations
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move to the right window" })

-- Keymaps for commenting
vim.keymap.set("n", "<C-b>", "gcc", { desc = "Toggle line [C]omment" })
vim.keymap.set("n", "<C-n>", "gbc", { desc = "Toggle block [C]omment" })

-- Telescope
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc = '[P]roject [F]iles'})
vim.keymap.set('n', '<leader>pg', builtin.git_files, {desc = '[P]roject [G]it'})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({search = vim.fn.input("Grep > ")})
end, {desc = '[P]roject [S]earch'})
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })

-- Code formater
vim.keymap.set("n", "<leader>d", vim.lsp.buf.format, {})

-- Harpoon
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<C-a>", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end)
vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end)
vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end)
vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end)
vim.keymap.set("n", "<leader>0", function() harpoon:list():select(10) end)


-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<F2>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<F3>", function() harpoon:list():next() end)

-- Remove a buffer from the list
vim.keymap.set("n", "<C-d>", function() harpoon:list():remove() end)
