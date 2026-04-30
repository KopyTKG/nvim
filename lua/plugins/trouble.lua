return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      auto_close = true,
      focus = true,
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble: Workspace diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Trouble: Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Trouble: Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "Trouble: LSP defs/refs" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Trouble: Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Trouble: Quickfix list" },
    },
  },
}
