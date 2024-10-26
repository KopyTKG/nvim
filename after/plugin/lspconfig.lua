require("lspconfig").lua_ls.setup({
    settings = {
	Lua = {
	    diagnostics = {
		globals = {"vim"}
	    }
	}
    }
})

require("lspconfig").rust_analyzer.setup({})
require("lspconfig").clangd.setup({})
require("lspconfig").gopls.setup({})
require("lspconfig").lua_ls.setup({})
require("lspconfig").pyright.setup({})
require("lspconfig").cmake.setup({})

-- webdev
require("lspconfig").ts_ls.setup({})
require("lspconfig").html.setup({})
require("lspconfig").eslint.setup({})
require("lspconfig").tailwindcss.setup({})


local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = {"gopls", "ts_ls", "clangd", "pyright", "lua_ls", "rust_analyzer", "html", "cmake", "eslint", "tailwindcss"}
for _, lsp in ipairs(servers) do
    require("lspconfig")[lsp].setup({
	capabilities = capabilities
    })
end



