local languages = require "config.languages"

return {
  {
    "mason-org/mason.nvim",
    opts = {
      -- Keep the registry list in sync with after/plugin/mason.lua so the
      -- custom `roslyn` package resolves regardless of which setup runs first.
      registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
      },
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
      local ensure = {}
      vim.list_extend(ensure, languages.formatters)
      vim.list_extend(ensure, languages.dap_adapters)
      vim.list_extend(ensure, languages.mason_extra or {})
      require("mason-tool-installer").setup {
        lazy = true,
        ensure_installed = ensure,
      }
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = languages.lsp_servers,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
