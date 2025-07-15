require "kopy.lazy"

require("mason-tool-installer").setup {
  ensure_installed = {
    "prettier", -- prettier formatter
    "stylua", -- lua formatter
    "goimports", -- go formatter
    "cpplint", -- C++ linter
  },
}

-- Set relative line numbers
vim.opt.relativenumber = true
-- Set mouse to work in all modes
vim.opt.mouse = "a"

-- Set clipboard to system clipboard
vim.opt.clipboard = "unnamedplus"

-- Set breakindent
vim.opt.breakindent = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Save undo history
vim.opt.undofile = true

-- Keep sign column open
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 250

-- Split navigations
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Scroll buffer
vim.opt.scrolloff = 10

-- Change Netrw directory listing
vim.g.netrw_liststyle = 0

-- Enable true color support
vim.o.termguicolors = true

-- Enable true color support
vim.o.termguicolors = true

-- Define custom highlight groups for Git branches
vim.cmd "highlight GitBranch guifg=#ff0000 guibg=#000000 gui=bold"

local function git_branch()
  local branch =
    vim.fn.system "git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'"

  if string.len(branch) > 0 then
    return branch
  else
    return ":"
  end
end

local function statusline()
  local set_color_1 = "%#GitBranch#"

  local branch = git_branch()

  local set_color_2 = "%#StatusLine#"

  local file_name = " %f"

  local modified = "%m"

  local align_right = "%="

  local filetype = " %y"

  local linecol = " %l:%c"

  return string.format(
    "%s %s %s%s%s%s%s%s",
    set_color_1,
    branch,
    set_color_2,
    file_name,
    modified,
    align_right,
    filetype,
    linecol
  )
end

vim.opt.statusline = statusline()

-- Display statusline always
vim.opt.laststatus = 2

-- Relative line numbers with cursor line number
vim.opt.number = true
vim.opt.cursorline = true

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("Highlight on yank", {
    clear = true,
  }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]],
  true
)

vim.g.mapleader = " "

vim.api.nvim_set_keymap(
  "i",
  "<Space>",
  "<Space>",
  { noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>w", vim.cmd.w)
vim.keymap.set("n", "<leader>s", [[:%s/<C-r><C-w>//g<Left><Left>]])

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keymaps for external programs
vim.keymap.set("n", "<F12>", function()
  vim.cmd "terminal lazygit"
  vim.cmd "startinsert"
end, { noremap = true, silent = true })

-- Keymaps for LSP
vim.keymap.set(
  "n",
  "[d",
  vim.diagnostic.goto_prev,
  { desc = "Go to previous [D]iagnostic message" }
)
vim.keymap.set(
  "n",
  "]d",
  vim.diagnostic.goto_next,
  { desc = "Go to next [D]iagnostic message" }
)
vim.keymap.set(
  "n",
  "<leader>q",
  vim.diagnostic.setloclist,
  { desc = "Set [Q]uickfix list" }
)
vim.keymap.set(
  "n",
  "<leader>e",
  vim.diagnostic.open_float,
  { desc = "Open [E]rror diagnostics" }
)

-- Split navigations
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move to the left window" })
vim.keymap.set(
  "n",
  "<C-l>",
  "<C-w><C-l>",
  { desc = "Move to the right window" }
)

-- Keymaps for commenting
vim.keymap.set("n", "<C-b>", "gc", { desc = "Toggle line [C]omment" })
vim.keymap.set("n", "<C-n>", "gb", { desc = "Toggle block [C]omment" })

-- Telescope
local builtin = require "telescope.builtin"

vim.keymap.set(
  "n",
  "<leader>pf",
  builtin.find_files,
  { desc = "[P]roject [F]iles" }
)
vim.keymap.set(
  "n",
  "<leader>pg",
  builtin.git_files,
  { desc = "[P]roject [G]it" }
)
vim.keymap.set("n", "<leader>ps", function()
  builtin.grep_string { search = vim.fn.input "Grep > " }
end, { desc = "[P]roject [S]earch" })
vim.keymap.set(
  "n",
  "<leader>sw",
  builtin.grep_string,
  { desc = "[S]earch current [W]ord" }
)

-- Code formater
vim.keymap.set(
  "n",
  "<leader>d",
  ":FormatWrite<CR>",
  { noremap = true, silent = true }
)

-- Harpoon
local harpoon = require "harpoon"

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<C-a>", function()
  harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<leader>1", function()
  harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>2", function()
  harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>3", function()
  harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>4", function()
  harpoon:list():select(4)
end)
vim.keymap.set("n", "<leader>5", function()
  harpoon:list():select(5)
end)
vim.keymap.set("n", "<leader>6", function()
  harpoon:list():select(6)
end)
vim.keymap.set("n", "<leader>7", function()
  harpoon:list():select(7)
end)
vim.keymap.set("n", "<leader>8", function()
  harpoon:list():select(8)
end)
vim.keymap.set("n", "<leader>9", function()
  harpoon:list():select(9)
end)
vim.keymap.set("n", "<leader>0", function()
  harpoon:list():select(10)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<F2>", function()
  harpoon:list():prev()
end)
vim.keymap.set("n", "<F3>", function()
  harpoon:list():next()
end)

-- Remove a buffer from the list
vim.keymap.set("n", "<C-d>", function()
  harpoon:list():remove()
end)
