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

local lang = {
}

for _, l in ipairs(lang) do
	if not require('mason-registry').is_installed(l) then
    		vim.cmd("MasonInstall " .. l)
	end
end

require("mason-lspconfig").setup({
    -- Enable the LSP server
    enable = true,
    -- Enable the LSP server for the following languages
    languages = lang
})
