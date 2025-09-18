-- Split navigations
-- [<leader>h] Move to the left window
vim.keymap.set(
  "n",
  "<leader>h",
  "<C-w><C-h>",
  { desc = "Move to the left window" }
)
-- [<leader>l] Move to the right window
vim.keymap.set(
  "n",
  "<leader>l",
  "<C-w><C-l>",
  { desc = "Move to the right window" }
)
-- [<leader>j] Move to the lower window
vim.keymap.set(
  "n",
  "<leader>j",
  "<C-w><C-j>",
  { desc = "Move to the lower window" }
)
-- [<leader>k] Move to the upper window
vim.keymap.set(
  "n",
  "<leader>k",
  "<C-w><C-k>",
  { desc = "Move to the upper window" }
)

-- Slip making
-- [<leader>hh] Split the window vertically
vim.keymap.set(
  "n",
  "<leader>hh",
  "<C-w>v",
  { desc = "Split the window vertically" }
)
-- [<leader>jj] Split the window horizontally
vim.keymap.set(
  "n",
  "<leader>jj",
  "<C-w>s",
  { desc = "Split the window horizontally" }
)
