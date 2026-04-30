return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      current_line_blame = false, -- toggle with <leader>gB
      on_attach = function(bufnr)
        local gs = require "gitsigns"
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Hunk navigation
        map("n", "]c", function() gs.next_hunk() end, "Gitsigns: Next hunk")
        map("n", "[c", function() gs.prev_hunk() end, "Gitsigns: Prev hunk")

        -- Hunk actions
        map("n", "<leader>gp", gs.preview_hunk, "Gitsigns: Preview hunk")
        map("n", "<leader>gs", gs.stage_hunk, "Gitsigns: Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Gitsigns: Reset hunk")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Gitsigns: Undo stage hunk")

        -- Buffer actions
        map("n", "<leader>gS", gs.stage_buffer, "Gitsigns: Stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Gitsigns: Reset buffer")

        -- Blame
        map("n", "<leader>gb", function() gs.blame_line { full = true } end, "Gitsigns: Blame line")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "Gitsigns: Toggle line blame")

        -- Diff
        map("n", "<leader>gd", gs.diffthis, "Gitsigns: Diff this")
      end,
    },
  },
}
