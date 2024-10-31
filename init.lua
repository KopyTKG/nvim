require("kopy")

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",        -- Lua
        "rust_analyzer", -- Rust
        "clangd",        -- C/C++
        "gopls",         -- Go
        "pyright",       -- Python
        "cmake",         -- CMake
        "ts_ls",      -- TypeScript/JavaScript
        "html",          -- HTML
        "eslint",        -- ESLint
        "tailwindcss",    -- Tailwind CSS
        "dockerls",      -- Docker
        "docker_compose_language_service", -- Docker Compose
        "jsonls",        -- JSON
        "pylsp",         -- Python LSP (alternative to Pyright)
        "vimls",         -- Vimscript
        "ansiblels",     -- Ansible
        "ast_grep"       -- AST Grep (if supported by lspconfig)
    },
    automatic_installation = true,
})


-- Setup lspconfig for each server
local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
    function(server_name)  -- Default handler for all servers
        lspconfig[server_name].setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities()
        })
    end,
    -- Custom settings for specific servers can be added here
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {"vim"}
                    }
                }
            },
            capabilities = require('cmp_nvim_lsp').default_capabilities()
        })
    end
})
