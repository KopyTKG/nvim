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
      -- Don't let mason-lspconfig auto-enable every installed Mason package.
      -- Servers are enabled explicitly in nvim-lspconfig.lua from the central
      -- list, so auto-enable is redundant here — and harmful: it would attach
      -- stray installed servers (e.g. a stale `omnisharp`) alongside the ones
      -- we want. C# in particular must be served by Roslyn alone; a second
      -- C# client breaks the LSP keymaps (gd/gr/gi/hover).
      automatic_enable = false,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}
