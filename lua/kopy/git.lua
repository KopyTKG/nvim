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

-- Keymaps for external programs
vim.keymap.set("n", "<F12>", function()
  vim.cmd "terminal lazygit"
  vim.cmd "startinsert"
end, { noremap = true, silent = true })
