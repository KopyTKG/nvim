return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "master",
    build = ":TSUpdate",
    config = function()
      local languages = require "config.languages"
      require("nvim-treesitter.configs").setup {
        ensure_installed = languages.treesitter,
        sync_install = false,
        auto_install = true,
        indent = { enable = true },
        incremental_selection = { enable = true },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },
}
