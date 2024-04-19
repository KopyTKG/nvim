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
	"bashls",
	"rust_analyzer",
	"tailwindcss",
	"cssls",
	"dockerls",
	"gopls",
	"html",
	"jsonls",
	"pyright",
	"tsserver",
	"vimls",
	"yamlls"
    }
})
-- print("hello world")  
