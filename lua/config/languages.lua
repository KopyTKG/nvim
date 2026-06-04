-- Single source of truth for all language tooling.
-- Mason, LSP, conform, and treesitter configs all read from this file.

local M = {}

-- LSP servers installed by Mason and enabled by lspconfig.
-- Servers needing custom config are still configured in nvim-lspconfig.lua,
-- but they don't need to be listed there separately.
M.lsp_servers = {
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
  "omnisharp",
  "tombi",
  "svelte",
  "cssls",
  "graphql",
  "zls",
  "ols",
}

-- Formatters installed by Mason.
M.formatters = {
  "clang-format",
  "prettier",
  "stylua",
  "goimports",
  "csharpier",
  "black",
  "latexindent",
  "ols",
}

-- DAP adapters installed by Mason.
M.dap_adapters = {
  "netcoredbg",
}

-- Treesitter parsers.
M.treesitter = {
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
  "svelte",
  "c_sharp",
  "graphql",
  "zig",
}

return M
