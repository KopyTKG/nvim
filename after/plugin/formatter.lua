local util = require "formatter.util"

function prettier()
  return {
    exe = "prettierd",
    args = {
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
  }
end

require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- Filetype-specific configurations
  filetype = {
    c = {
      -- Use clang-format for C files
      function()
        return {
          exe = "clang-format",
          args = {
            "--style=file", -- Use the .clang-format file in the project root
            "--assume-filename",
            util.escape_path(util.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end,
    },
    cpp = {
      -- Use clang-format for C++ files
      function()
        return {
          exe = "clang-format",
          args = {
            "--style=file", -- Use the .clang-format file in the project root
            "--assume-filename",
            util.escape_path(util.get_current_buffer_file_path()),
          },
          stdin = true,
        }
      end,
    },

    -- JavaScript, TypeScript, JSX, TSX, CJS using Prettier
    javascript = { prettier },
    typescript = { prettier },
    javascriptreact = { prettier },
    typescriptreact = { prettier },
    json = { prettier },
    css = { prettier },
    scss = { prettier },
    html = { prettier },
    yaml = { prettier },
    -- Lua files using Stylua
    lua = {
      -- Default stylua configuration
      require("formatter.filetypes.lua").stylua,

      -- Custom Stylua configuration
      function()
        return {
          exe = "stylua",
          args = {
            "--config-path",
            vim.fn.stdpath "config" .. "/formatter/stylua.toml",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end,
    },

    -- Golang files using goimports
    go = {
      function()
        return {
          exe = "goimports",
          args = {
            "-srcdir",
            util.get_current_buffer_file_path(), -- Specify the directory
          },
          stdin = true,
        }
      end,
    },
  },
}
