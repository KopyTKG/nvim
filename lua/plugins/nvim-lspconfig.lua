return {
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp_nvim_lsp = require "cmp_nvim_lsp"
      local capabilities = cmp_nvim_lsp.default_capabilities()
      local languages = require "config.languages"

      -- Configure global defaults for all LSP servers
      vim.lsp.config("*", {
        capabilities = capabilities,
        root_markers = { ".git" },
      })

      -- Custom server configs (applied before enable)
      vim.lsp.config("ts_ls", {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      })

      vim.lsp.config("eslint", {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      })

      vim.lsp.config("svelte", {
        filetypes = { "svelte" },
        root_markers = { "svelte.config.js", "svelte.config.cjs", "package.json" },
        settings = {
          svelte = {
            plugin = {
              typescript = { enable = false },
              css = { enable = true, diagnostics = { enable = true } },
              html = { enable = true, completions = { enable = true, emmet = false } },
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
        flags = { debounce_text_changes = 500 },
      })

      vim.lsp.config("graphql", {
        filetypes = { "graphql", "typescriptreact", "javascriptreact", "svelte" },
      })

      -- Enable all servers from the central config
      for _, server in ipairs(languages.lsp_servers) do
        vim.lsp.enable(server)
      end

      -- Handle Svelte LSP attach with autocommand
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "svelte" then
            -- Aggressively disable problematic features for Svelte
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.documentHighlightProvider = false
            client.server_capabilities.codeLensProvider = nil
          end
        end,
      })
    end,
  },
}
