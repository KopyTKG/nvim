return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- Define your formatters
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier", "prettierd", stop_after_first = true },
      typescript = { "prettier", "prettierd", stop_after_first = true },
      typescriptreact = { "prettier", "prettierd", stop_after_first = true },
      javascriptreact = { "prettier", "prettierd", stop_after_first = true },
      json = { "prettier", "prettierd", stop_after_first = true },
      css = { "prettier", "prettierd", stop_after_first = true },
      scss = { "prettier", "prettierd", stop_after_first = true },
      html = { "prettier", "prettierd", stop_after_first = true },
      yaml = { "prettier", "prettierd", stop_after_first = true },
      sh = { "shfmt" },
      markdown = { "prettier", "prettierd", stop_after_first = true },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = { timeout_ms = 500 },
    formatters = {
      shfmt = {
        append_args = { "-i", "2" },
      },
      prettier = {
        prepend_args = function()
          return {
            "--config",
            vim.fn.expand "~/.config/nvim/formatter/.prettierrc",
            "--config-precedence",
            "cli-override",
          }
        end,
      },
      stylua = {
        prepend_args = function()
          return {
            "--config-path",
            vim.fn.expand "~/.config/nvim/formatter/stylua.toml",
          }
        end,
      },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
