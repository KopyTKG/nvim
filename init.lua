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

-- Ensure treesitter highlighting enabled for new buffers (covers Telescope previews)
vim.api.nvim_create_autocmd({
  "BufReadPost",
  "BufNewFile",
  "FileType",
  "BufEnter",
  "BufWinEnter",
  "VimEnter",
}, {
  callback = function()
    -- If TSBufEnable command exists, call it
    if vim.fn.exists ":TSBufEnable" == 2 then
      pcall(vim.cmd, "TSBufEnable highlight")
      return
    end

    -- Otherwise, attempt to enable when a parser exists for this buffer
    pcall(function()
      local ok, parser = pcall(vim.treesitter.get_parser, 0)
      if ok and parser then
        pcall(vim.cmd, "TSBufEnable highlight")
      end
    end)
  end,
})
