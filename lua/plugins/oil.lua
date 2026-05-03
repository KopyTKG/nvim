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
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil_preview",
        callback = function(args)
          local winid = vim.api.nvim_get_current_win()
          local cfg = vim.api.nvim_win_get_config(winid)
          local width = cfg.width
          if width then
            local left, right = "(n) No", "(y) Yes"
            local pad = width - vim.fn.strdisplaywidth(left) - vim.fn.strdisplaywidth(right)
            if pad < 1 then
              pad = 1
            end
            vim.api.nvim_win_set_config(winid, {
              footer = left .. string.rep(" ", pad) .. right,
              footer_pos = "left",
            })
          end

          -- Strip oil's in-buffer "[Y]es [N]o" line; it's redundant with the footer.
          vim.schedule(function()
            local bufnr = args.buf
            if not vim.api.nvim_buf_is_valid(bufnr) then
              return
            end
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            for i = #lines, 1, -1 do
              if lines[i]:find("%[Y%]es") and lines[i]:find("%[N%]o") then
                local was_modifiable = vim.bo[bufnr].modifiable
                vim.bo[bufnr].modifiable = true
                vim.api.nvim_buf_set_lines(bufnr, i - 1, i, false, { "" })
                vim.bo[bufnr].modifiable = was_modifiable
                break
              end
            end
          end)
        end,
      })
    end,
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
      confirmation = {
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
