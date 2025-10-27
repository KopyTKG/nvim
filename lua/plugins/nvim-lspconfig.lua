return {
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp_nvim_lsp = require "cmp_nvim_lsp"
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- List of servers for default setup
      local servers = {
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
      }

      -- Default setup for most servers using the new API
      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities })
        vim.lsp.enable(server)
      end
    end,
  },
}
