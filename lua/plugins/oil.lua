return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Lazy-load on these triggers; oil takes over for directory paths too.
    lazy = false,
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Oil: open parent directory" },
      { "<leader>pv", "<cmd>Oil<cr>", desc = "Oil: open parent directory" },
      { "<leader>e", "<cmd>Oil --float<cr>", desc = "Oil: open in floating window" },
    },
    opts = {
      default_file_explorer = true, -- replaces netrw
      delete_to_trash = true,
      skip_confirm_for_simple_edits = false,
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 4,
        max_width = 100,
        max_height = 30,
        border = "rounded",
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = { "actions.cd", opts = { scope = "tab" } },
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
    },
  },
}
