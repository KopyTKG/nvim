return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>lz", "<cmd>LazyGit<cr>", desc = "Open Lazygit" },
    },
    init = function()
      -- Floating window appearance
      vim.g.lazygit_floating_window_scaling_factor = 0.95
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      -- Auto-close the floating window when lazygit exits (no orphaned terminal buffer).
      vim.g.lazygit_use_neovim_remote = 0
    end,
  },
}
