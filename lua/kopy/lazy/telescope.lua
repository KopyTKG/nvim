-- Telescope for fuzzy finding, etc.
return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.6',  -- Use a specific version to avoid breaking changes
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		require('telescope').setup({})
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>pf', builtin.find_files, {desc = '[P]roject [F]iles'})
		vim.keymap.set('n', '<leader>pg', builtin.git_files, {desc = '[P]roject [G]it'})
		vim.keymap.set('n', '<leader>ps', function()
			builtin.grep_string({search = vim.fn.input("Grep > ")})
		end, {desc = '[P]roject [S]earch'})
		vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
	end
}


