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

-- LSP go-to family — piped through fzf-lua so multiple results show as a
-- searchable picker with previews (instead of nvim's default location list).
local fzf = require "fzf-lua"

vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "LSP: Definitions (fzf)" })
vim.keymap.set("n", "gr", fzf.lsp_references, { desc = "LSP: References (fzf)" })
vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "LSP: Implementations (fzf)" })
vim.keymap.set("n", "gy", fzf.lsp_typedefs, { desc = "LSP: Type definitions (fzf)" })

-- Keep the leader-prefixed alias for muscle memory.
vim.keymap.set("n", "<leader>gd", fzf.lsp_definitions, { desc = "LSP: Definitions (fzf)" })

-- [<leader>g] Show hover information
vim.keymap.set("n", "<leader>g", vim.lsp.buf.hover, { desc = "LSP: Hover info" })
