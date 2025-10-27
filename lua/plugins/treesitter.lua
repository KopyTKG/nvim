return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "c",
          "cpp",
          "go",
          "lua",
          "python",
          "rust",
          "tsx",
          "typescript",
          "javascript",
          "markdown",
          "vimdoc",
          "vim",
          "prisma",
        },
        sync_install = false,
        auto_install = true,
        indent = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },
}
