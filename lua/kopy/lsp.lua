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

-- LSP go-to family, on the <leader>l* prefix (bare g-prefixed maps were being
-- shadowed in-session, so these live under leader instead).
--
-- Definition / type-definition use the native vim.lsp.buf.* calls — the same
-- ones the right-click "Go to Definition" menu runs — so they jump straight in
-- the current window (usually a single result). Wrapped in functions so they're
-- always called with no args (binding the bare reference can let the keymap
-- system pass an argument the function misreads as options).
--
-- References / implementations usually have many results, so they go through
-- fzf-lua for a searchable picker with previews (a single result jumps directly).
local fzf = require "fzf-lua"

vim.keymap.set("n", "<leader>ld", function()
  vim.lsp.buf.definition()
end, { desc = "LSP: Go to definition" })
vim.keymap.set("n", "<leader>ly", function()
  vim.lsp.buf.type_definition()
end, { desc = "LSP: Type definition" })
vim.keymap.set("n", "<leader>lr", function()
  fzf.lsp_references()
end, { desc = "LSP: References (fzf)" })
vim.keymap.set("n", "<leader>li", function()
  fzf.lsp_implementations()
end, { desc = "LSP: Implementations (fzf)" })

-- [<leader>g] Show hover information
vim.keymap.set(
  "n",
  "<leader>l",
  vim.lsp.buf.hover,
  { desc = "LSP: Hover info" }
)
