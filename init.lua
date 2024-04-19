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
    -- Enable the LSP server
    enable = true,
    -- Enable the LSP server for the following languages
    languages = {
	"proselint",
	"standardjs",
	"vale",
	"ansible-language-server",
	"ansible-lint",
	"docker-compose-language-service",
	"dockerfile-language-server",
	"eslint-lsp",
	"eslint_d",
	"json-lsp",
	"lua-language-server",
	"prettier",
	"python-lsp-server",
	"rust-analyzer",
	"tailwindcss-language-server",
	"vim-language-server",
	"xmlformatter"
    }
})
-- print("hello world")  
