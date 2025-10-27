return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      local install_tool = require "mason-tool-installer"
      install_tool.setup {
        lazy = true,
        ensure_installed = {
          "clang-format", -- C/C++ formatter
          "prettier", -- Prettier formatter
          "stylua", -- Lua formatter
          "goimports", -- Go formatter
          "csharpier", -- C# formatter
        },
      }
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "clangd",
        "gopls",
        "cmake",
        "ts_ls",
        "html",
        "texlab",
        "eslint",
        "tailwindcss",
        "jsonls",
        "vimls",
        "pyright",
        "zk",
        "docker_language_server",
        "prismals",
        "csharp_ls",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
