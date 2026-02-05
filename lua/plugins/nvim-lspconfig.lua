return {
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lspconfig = require "lspconfig"
      local cmp_nvim_lsp = require "cmp_nvim_lsp"
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- List of servers for default setup
      local servers = {
        "lua_ls",
        "clangd",
        "gopls",
        "cmake",
        "html",
        "texlab",
        "tailwindcss",
        "jsonls",
        "vimls",
        "zk",
        "prismals",
        "csharp_ls",
      }

      -- Default setup for most servers using the new API
      for _, server in ipairs(servers) do
        lspconfig[server].setup { capabilities = capabilities }
      end

      -- TypeScript LSP - exclude Svelte files
      lspconfig.ts_ls.setup {
        capabilities = capabilities,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      }

      -- ESLint - exclude Svelte files
      lspconfig.eslint.setup {
        capabilities = capabilities,
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      }

      lspconfig.pyright.setup {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      }

      lspconfig.svelte.setup {
        capabilities = capabilities,
        filetypes = { "svelte" },
        root_dir = lspconfig.util.root_pattern("svelte.config.js", "svelte.config.cjs", "package.json"),
        settings = {
          svelte = {
            plugin = {
              typescript = {
                -- Completely disable TS integration to prevent memory leaks
                enable = false,
              },
              css = {
                enable = true,
                diagnostics = { enable = true },
              },
              html = {
                enable = true,
                completions = { enable = true, emmet = false },
              },
              svelte = {
                compilerWarnings = {
                  ["a11y-accesskey"] = "ignore",
                  ["a11y-invalid-attribute"] = "ignore",
                },
                defaultScriptLanguage = "ts",
              },
            },
          },
        },
        on_attach = function(client, bufnr)
          -- Aggressively disable problematic features
          client.server_capabilities.semanticTokensProvider = nil
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          client.server_capabilities.documentHighlightProvider = false
          client.server_capabilities.codeLensProvider = nil
        end,
        flags = {
          debounce_text_changes = 500, -- Increased from 300ms
        },
      }
    end,
  },
}
