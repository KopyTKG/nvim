return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      on_colors = function(c)
        -- Only override the dark variant (night); leave tokyonight-day as-is.
        local function is_dark(hex)
          local r = tonumber(hex:sub(2, 3), 16) or 0
          local g = tonumber(hex:sub(4, 5), 16) or 0
          local b = tonumber(hex:sub(6, 7), 16) or 0
          return (r + g + b) / 3 < 128
        end
        if not is_dark(c.bg) then return end

        -- Tailwind stone palette — UI chrome only; syntax colors untouched
        c.bg               = "#0c0a09" -- stone-950
        c.bg_dark          = "#0c0a09"
        c.bg_float         = "#1c1917" -- stone-900
        c.bg_highlight     = "#292524" -- stone-800
        c.bg_popup         = "#1c1917"
        c.bg_search        = "#d6d3d1" -- stone-300
        c.bg_sidebar       = "#0c0a09"
        c.bg_statusline    = "#1c1917"
        c.bg_visual        = "#44403c" -- stone-700
        c.border           = "#44403c"
        c.border_highlight = "#f5f5f4" -- stone-100
        c.fg               = "#fafaf9" -- stone-50
        c.fg_dark          = "#d6d3d1"
        c.fg_float         = "#fafaf9"
        c.fg_gutter        = "#44403c"
        c.fg_sidebar       = "#d6d3d1"
        c.comment          = "#78716c" -- stone-500
        c.terminal_black   = "#292524"
        -- Syntax-relevant keys (red, orange, yellow, green, blue, cyan,
        -- magenta, purple, teal, error, warn, info, hint, git.*) are left
        -- untouched so treesitter / LSP / diff colors stay readable.
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
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
