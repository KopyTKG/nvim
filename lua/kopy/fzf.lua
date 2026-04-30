-- fzf-lua keymaps (replaces telescope)
local fzf = require "fzf-lua"

vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fg", fzf.git_files, { desc = "[F]ind [G]it files" })
vim.keymap.set("n", "<leader>gw", fzf.live_grep, { desc = "[G]rep live (project)" })
vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "[F]ind [W]ord under cursor" })

-- A few extras fzf-lua excels at (cheap, kept minimal):
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "[F]ind [B]uffers" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "[F]ind [R]ecent" })
vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "[F]ind [K]eymaps" })
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "[F]ind [D]iagnostics" })
