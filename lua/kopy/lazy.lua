local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Load the plugin
require("lazy").setup {
  "wbthomason/packer.nvim",
  "nvim-lua/plenary.nvim",
  "neovim/nvim-lspconfig",
  "andweeb/presence.nvim",
  "MunifTanjim/prettier.nvim",
  "tpope/vim-fugitive",
  "rhysd/vim-clang-format",
  "hrsh7th/nvim-cmp",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "hrsh7th/cmp-nvim-lsp",
  "nvim-treesitter/nvim-treesitter",
  "mfussenegger/nvim-dap",
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup {}
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    requires = { { "nvim-lua/plenary.nvim" } },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      vim.cmd "colorscheme catppuccin"
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { { "nvim-lua/plenary.nvim" } },
  },

  -- MASON STUFF --
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
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls", -- lua
        "rust_analyzer", -- rust
        "clangd", -- c/c++
        "gopls", -- go
        "pyright", -- python
        "cmake", -- cmake
        "ts_ls", -- typescript/javascript
        "denols", -- deno runtime lsp
        "html", -- html
        "texlab", -- latex
        "eslint", -- eslint
        "tailwindcss", -- tailwind css
        "jsonls", -- json
        "pylsp", -- python lsp (alternative to pyright)
        "vimls", -- vimscript
        "ansiblels", -- ansible
        "ast_grep", -- ast grep (if supported by lspconfig)
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  ------------------------

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    tag = "v2.3.0",
    run = "make install_jsregexp",
  },
  {
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = {
        "markdown",
      }
    end,
    ft = { "markdown" },
  },
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "normen/vim-pio",
  "github/copilot.vim",
}
