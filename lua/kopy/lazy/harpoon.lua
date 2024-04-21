return {
	"theprimeagen/harpoon.nvim",
	branch = "harpoon2",
	requires = { {"nvim-lua/plenary.nvim"} },

	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
		vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

		vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
		vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
		vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<F2>", function() harpoon:list():prev() end)
		vim.keymap.set("n", "<F3>", function() harpoon:list():next() end)

		-- Remove a buffer from the list
		vim.keymap.set("n", "<leader>d", function() harpoon:list():remove() end)
	end
}
