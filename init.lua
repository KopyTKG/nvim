require "kopy"

require("mason").setup {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
}

require("mason-lspconfig").setup {
  ensure_installed = {
    "lua_ls", -- lua
    "rust_analyzer", -- rust
    "clangd", -- c/c++
    "gopls", -- go
    "pyright", -- python
    "cmake", -- cmake
    "ts_ls", -- typescript/javascript
    "html", -- html
    "eslint", -- eslint
    "tailwindcss", -- tailwind css
    "dockerls", -- docker
    "docker_compose_language_service", -- docker compose
    "jsonls", -- json
    "pylsp", -- python lsp (alternative to pyright)
    "vimls", -- vimscript
    "ansiblels", -- ansible
    "ast_grep", -- ast grep (if supported by lspconfig)
  },
  automatic_installation = true,
}

require("mason-tool-installer").setup {
  ensure_installed = {
    "prettier", -- prettier formatter
    "stylua", -- lua formatter
    "goimports", -- go formatter
  },
}

-- setup lspconfig for each server
local lspconfig = require "lspconfig"
require("mason-lspconfig").setup_handlers {
  function(server_name) -- default handler for all servers
    lspconfig[server_name].setup {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }
  end,
  -- custom settings for specific servers can be added here
  ["lua_ls"] = function()
    lspconfig.lua_ls.setup {
      settings = {
        lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }
  end,
  ["pyright"] = function()
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
  end,
}
