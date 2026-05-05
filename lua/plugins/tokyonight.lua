return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd "colorscheme tokyonight-night"
      vim.keymap.set("n", "<leader>=", function()
        if vim.g.colors_name == "tokyonight-day" then
          vim.cmd "colorscheme tokyonight-night"
        else
          vim.cmd "colorscheme tokyonight-day"
        end
      end, { desc = "Toggle dark/light theme" })
    end,
  },
}
