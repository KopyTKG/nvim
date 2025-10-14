-- Keymaps for LSP
-- [<leader>a] Go to previous diagnostic message
vim.keymap.set(
  "n",
  "<leader>a",
  vim.diagnostic.goto_prev,
  { desc = "Go to previous [D]iagnostic message" }
)
-- [<leader>d] Go to next diagnostic message
vim.keymap.set(
  "n",
  "<leader>d",
  vim.diagnostic.goto_next,
  { desc = "Go to next [D]iagnostic message" }
)
-- [<leader>q] Show all diagnostic messages in the location list
vim.keymap.set(
  "n",
  "<leader>q",
  vim.diagnostic.setloclist,
  { desc = "Set [Q]uickfix list" }
)
-- [<leader>e] Show diagnostic message for current line in a floating window
vim.keymap.set(
  "n",
  "<leader>e",
  vim.diagnostic.open_float,
  { desc = "Open [E]rror diagnostics" }
)

-- [<leader>gd] Go to definition
vim.keymap.set(
  "n",
  "<leader>gd",
  vim.lsp.buf.definition,
  { desc = "Go to [G]o [D]efinition" }
)

-- [<leader>gw] Show hover information
vim.keymap.set(
  "n",
  "<leader>g",
  vim.lsp.buf.hover,
  { desc = "Show [G]o [W]ord info" }
)
