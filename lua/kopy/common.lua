-- [<leader>pv] to open netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- [<leader>w] Save file
vim.keymap.set("n", "<leader>w", vim.cmd.w)
-- [<leader>s] Regex search and replace for current word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/<C-r><C-w>//g<Left><Left>]])
-- [<Esc>] Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keymaps for commenting
vim.keymap.set("n", "<C-b>", "gc", { desc = "Toggle line [C]omment" })
vim.keymap.set("n", "<C-n>", "gb", { desc = "Toggle block [C]omment" })

-- Code formater
vim.keymap.set(
  "n",
  "<leader>f",
  ":FormatWrite<CR>",
  { noremap = true, silent = true }
)
