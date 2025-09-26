-- Harpoon
local harpoon = require "harpoon"

-- REQUIRED
harpoon:setup()
-- REQUIRED

-- Add the current buffer to the list
vim.keymap.set("n", "<leader>ha", function()
  harpoon:list():add()
end)

-- Remove a buffer from the list
vim.keymap.set("n", "<leader>hr", function()
  harpoon:list():remove()
end)

-- Toggle Harpoon quick menu
vim.keymap.set("n", "<leader>hl", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

-- Jump to a specific buffer in the list
vim.keymap.set("n", "<leader>1", function()
  harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>2", function()
  harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>3", function()
  harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>4", function()
  harpoon:list():select(4)
end)
vim.keymap.set("n", "<leader>5", function()
  harpoon:list():select(5)
end)
vim.keymap.set("n", "<leader>6", function()
  harpoon:list():select(6)
end)
vim.keymap.set("n", "<leader>7", function()
  harpoon:list():select(7)
end)
vim.keymap.set("n", "<leader>8", function()
  harpoon:list():select(8)
end)
vim.keymap.set("n", "<leader>9", function()
  harpoon:list():select(9)
end)
vim.keymap.set("n", "<leader>0", function()
  harpoon:list():select(10)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<F2>", function()
  harpoon:list():prev()
end)
vim.keymap.set("n", "<F3>", function()
  harpoon:list():next()
end)
