local leader = vim.g.mapleader or " "

-- [<leader>f] Create a new file with the name provided
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local key = leader .. "f"
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      key,
      [[:call feedkeys('%')<CR>]],
      { noremap = true, silent = true }
    )
  end,
})
