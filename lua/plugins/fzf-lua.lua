return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local fzf = require "fzf-lua"
      fzf.setup {
        winopts = {
          height = 0.85,
          width = 0.90,
          preview = { layout = "flex", flip_columns = 130 },
        },
        files = { fd_opts = "--color=never --type f --hidden --follow --exclude .git" },
        grep = { rg_opts = "--color=never --no-heading --with-filename --line-number --column --smart-case --hidden --glob '!.git/'" },
      }
      -- Use fzf-lua for vim.ui.select (affects DAP DLL picker, code actions, etc.)
      fzf.register_ui_select()
    end,
  },
}
