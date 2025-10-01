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
  "tpope/vim-fugitive",
  "rhysd/vim-clang-format",
  "hrsh7th/nvim-cmp",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
  "hrsh7th/cmp-nvim-lsp",
  "mfussenegger/nvim-dap",
  "normen/vim-pio",
  "github/copilot.vim",
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter").setup {
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
  {
    "MunifTanjim/prettier.nvim",
    config = function()
      require("prettier").setup {
        bin = "prettier",
        filetypes = {
          "css",
          "graphql",
          "html",
          "javascript",
          "javascriptreact",
          "json",
          "less",
          "markdown",
          "scss",
          "typescript",
          "typescriptreact",
          "yaml",
        },
        ["null-ls"] = {
          condition = function()
            return prettier.config_exists {
              -- if `false`, skips checking `package.json` for `"prettier"` key
              check_package_json = true,
            }
          end,
          runtime_condition = function(params)
            -- return false to skip running prettier
            return true
          end,
          timeout = 5000,
        },
        cli_options = {
          arrow_parens = "always",
          bracket_spacing = true,
          bracket_same_line = false,
          embedded_language_formatting = "auto",
          end_of_line = "lf",
          html_whitespace_sensitivity = "css",
          jsx_bracket_same_line = true,
          jsx_single_quote = true,
          print_width = 80,
          prose_wrap = "preserve",
          quote_props = "as-needed",
          semi = false,
          single_attribute_per_line = false,
          single_quote = true,
          tab_width = 1,
          trailing_comma = "all",
          use_tabs = false,
          vue_indent_script_and_style = false,
        },
      }
    end,
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      local util = require "formatter.util"

      function prettier()
        return {
          exe = "prettierd",
          args = {
            util.escape_path(util.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end
      require("formatter").setup {
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        -- Filetype-specific configurations
        filetype = {
          c = {
            -- Use clang-format for C files
            function()
              return {
                exe = "clang-format",
                args = {
                  "--style=file", -- Use the .clang-format file in the project root
                  "--assume-filename",
                  util.escape_path(util.get_current_buffer_file_path()),
                },
                stdin = true,
              }
            end,
          },
          cpp = {
            -- Use clang-format for C++ files
            function()
              return {
                exe = "clang-format",
                args = {
                  "--style=file", -- Use the .clang-format file in the project root
                  "--assume-filename",
                  util.escape_path(util.get_current_buffer_file_path()),
                },
                stdin = true,
              }
            end,
          },

          -- JavaScript, TypeScript, JSX, TSX, CJS using Prettier
          javascript = { prettier },
          typescript = { prettier },
          javascriptreact = { prettier },
          typescriptreact = { prettier },
          json = { prettier },
          css = { prettier },
          scss = { prettier },
          html = { prettier },
          yaml = { prettier },
          -- Lua files using Stylua
          lua = {
            -- Default stylua configuration
            require("formatter.filetypes.lua").stylua,

            -- Custom Stylua configuration
            function()
              return {
                exe = "stylua",
                args = {
                  "--config-path",
                  vim.fn.stdpath "config" .. "/formatter/stylua.toml",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                },
                stdin = true,
              }
            end,
          },

          -- Golang files using goimports
          go = {
            function()
              return {
                exe = "goimports",
                args = {
                  "-srcdir",
                  util.get_current_buffer_file_path(), -- Specify the directory
                },
                stdin = true,
              }
            end,
          },
        },
      }
    end,
    requires = { "MunifTanjim/prettier.nvim" },
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    requires = { { "nvim-lua/plenary.nvim" } },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd "colorscheme tokyonight-night"
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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      local install_tool = require "mason-tool-installer"
      install_tool.setup {
        lazy = true,
        ensure_installed = {
          "clang-format",
          "prettierd", -- prettier formatter
          "stylua", -- lua formatter
          "goimports", -- go formatter
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
      local lspconfig_util = require "lspconfig.util"
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
      }

      -- Servers with custom configs (skip in generic setup)
      local custom = { lua_ls = true, pyright = true, ts_ls = true }

      -- Default setup for most servers using the new API
      for _, server in ipairs(servers) do
        if not custom[server] then
          vim.lsp.config(server, { capabilities = capabilities })
          vim.lsp.enable(server)
        end
      end

      -- Custom setup for lua_ls
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      vim.lsp.enable "lua_ls"

      -- Custom setup for pyright
      vim.lsp.config("pyright", {
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
      })
      vim.lsp.enable "pyright"

      -- Custom setup for ts_ls (prefer project with package.json)
      vim.lsp.config("ts_ls", {
        root_dir = function(fname)
          return lspconfig_util.root_pattern(
            "package.json",
            "tsconfig.json",
            "jsconfig.json"
          )(fname) or lspconfig_util.find_git_ancestor(fname)
        end,
        single_file_support = false,
      })
      vim.lsp.enable "ts_ls"
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
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && bun install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
