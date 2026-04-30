local languages = require "config.languages"

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
      local ensure = {}
      vim.list_extend(ensure, languages.formatters)
      vim.list_extend(ensure, languages.dap_adapters)
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
