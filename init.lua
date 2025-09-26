require "kopy.init"

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("Highlight on yank", {
    clear = true,
  }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]],
  true
)

-- Fix leaking leader key in insert mode to use space normally
vim.api.nvim_set_keymap(
  "i",
  "<Space>",
  "<Space>",
  { noremap = true, silent = true }
)
