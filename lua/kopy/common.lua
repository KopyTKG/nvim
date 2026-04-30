-- [<leader>w] Save file
vim.keymap.set("n", "<leader>w", vim.cmd.w)
-- [<leader>s] Regex search and replace for current word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/<C-r><C-w>//g<Left><Left>]])
-- [<Esc>] Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keymaps for commenting
vim.keymap.set("n", "<leader>cl", "gc", { desc = "Toggle line [C]omment" })
vim.keymap.set("n", "<leader>cb", "gb", { desc = "Toggle block [C]omment" })

-- Code formater
vim.keymap.set(
  "n",
  "<leader>f",
  ":FormatWrite<CR>",
  { noremap = true, silent = true }
)

-- Claude Code Integration
vim.keymap.set("n", "<leader>co", ":terminal claude<CR>", {
  noremap = true,
  silent = true,
  desc = "Open Claude Code",
})

vim.keymap.set("n", "<leader>cop", ":terminal claude --model opus<CR>", {
  noremap = true,
  silent = true,
  desc = "Open Claude Code with Opus",
})

vim.keymap.set("n", "<leader>coh", ":terminal claude --model haiku<CR>", {
  noremap = true,
  silent = true,
  desc = "Open Claude Code with Haiku",
})
