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
  -- C#: served by Roslyn (seblyng/roslyn.nvim). Installed via `mason_extra`
  -- from a custom registry, not enabled through mason-lspconfig, so it is
  -- intentionally absent from this list. Replaces the old `omnisharp`.
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

-- Extra Mason packages that aren't plain LSP servers/formatters/DAP adapters,
-- installed by mason-tool-installer. `roslyn` comes from the custom
-- github:Crashdummyy/mason-registry registry (see after/plugin/mason.lua) and
-- is picked up automatically by roslyn.nvim. `tree-sitter-cli` is required by
-- nvim-treesitter's `main` branch, which compiles parsers from source
-- (see lua/plugins/treesitter.lua); Mason puts it on Neovim's PATH.
M.mason_extra = {
  "roslyn",
  "tree-sitter-cli",
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
  "xml", -- also drives XAML highlighting (see lua/kopy/dotnet.lua)
}

return M
