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
        "lua_ls",
        "rust_analyzer",
        "clangd",
        "gopls",
        "pyright",
        "cmake",
        "ts_ls",
        "html",
        "texlab",
        "eslint",
        "tailwindcss",
        "jsonls",
        "pylsp",
        "vimls",
        "ansiblels",
        "ast_grep",
        "harper_ls",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require "lspconfig"
      local cmp_nvim_lsp = require "cmp_nvim_lsp"
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- List of servers for default setup
      local servers = {
        "clangd",
        "gopls",
        "rust_analyzer",
        "html",
        "texlab",
        "eslint",
        "tailwindcss",
        "jsonls",
        "cmake",
        "pylsp",
        "vimls",
        "ansiblels",
      }

      -- Default setup for most servers
      for _, server in ipairs(servers) do
        lspconfig[server].setup {
          capabilities = capabilities,
        }
      end

      -- Custom setup for lua_ls
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      }

      -- Custom setup for pyright
      lspconfig.pyright.setup {
        settings = {
          python = {
            analysis = {
              extrapaths = { "." },
              autosearchpaths = true,
              uselibrarycodefortypes = true,
              diagnosticmode = "workspace",
            },
          },
        },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }

      -- Custom setup for ts_ls (prefer project with package.json)
      lspconfig.ts_ls.setup {
        root_dir = function(fname)
          return lspconfig.util.root_pattern(
            "package.json",
            "tsconfig.json",
            "jsconfig.json"
          )(fname) or lspconfig.util.find_git_ancestor(fname)
        end,
        single_file_support = false,
      }

      -- You can add more custom server setups here...
    end,
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
