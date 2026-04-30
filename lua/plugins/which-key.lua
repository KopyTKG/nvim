return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      spec = {
        -- Group labels for the leader namespace.
        { "<leader>f", group = "Find (fzf-lua)" },
        { "<leader>d", group = "DAP (Debug)" },
        { "<leader>g", group = "Git / Goto" },
        { "<leader>c", group = "Claude / Comment" },
        { "<leader>x", group = "Diagnostics (Trouble)" },
        { "<leader>l", group = "Lazygit" },
      },
    },
  },
}
