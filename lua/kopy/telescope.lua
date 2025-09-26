-- Telescope
local builtin = require "telescope.builtin"

-- [<leader>pf] Find files in project
vim.keymap.set(
  "n",
  "<leader>ff",
  builtin.find_files,
  { desc = "[P]roject [F]iles" }
)
-- [<leader>pg] Find git files in project
vim.keymap.set(
  "n",
  "<leader>fg",
  builtin.git_files,
  { desc = "[P]roject [G]it" }
)

-- [<leader>ps] Search for a string in project
vim.keymap.set("n", "<leader>gw", function()
  builtin.grep_string { search = vim.fn.input "Grep > " }
end, { desc = "[P]roject [S]earch" })

-- [<leader>sw] Search for the current word under the cursor in the project
vim.keymap.set(
  "n",
  "<leader>fw",
  builtin.grep_string,
  { desc = "[S]earch current [W]ord" }
)
