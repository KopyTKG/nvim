require "kopy.init"

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

-- Fix leaking leader key in insert mode to use space normally
vim.api.nvim_set_keymap(
  "i",
  "<Space>",
  "<Space>",
  { noremap = true, silent = true }
)

-- Interactive replace command: prompts at each match to replace/skip/back/quit
local function interactive_replace(opts)
  local arg = opts.args or ""
  local pat = nil
  if arg ~= "" then
    pat = arg:match("%S+")
  else
    pat = vim.fn.getreg('/')
  end
  if pat == "" or pat == nil then
    vim.notify("No search pattern: use /pattern first or pass it as arg", vim.log.levels.WARN)
    return
  end

  local last = nil
  local function next_match()
    local pos = vim.fn.searchpos(pat, 'W')
    return pos[1], pos[2]
  end
  local function prev_match()
    local pos = vim.fn.searchpos(pat, 'bW')
    return pos[1], pos[2]
  end

  local lnum, col = next_match()
  if lnum == 0 then
    vim.notify("No matches", vim.log.levels.INFO)
    return
  end

  while lnum ~= 0 do
    local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
    local m = vim.fn.matchstrpos(line, pat, math.max(0, col - 1))
    if m[2] == -1 then
      -- fallback: if can't get match slice, move to next
      lnum, col = next_match()
      if lnum == 0 then break end
    end

    local match_text, s, e = m[1], m[2], m[3]
    -- place cursor at match start (s is 0-based)
    vim.api.nvim_win_set_cursor(0, {lnum, s})
    -- ensure the cursor is visible: open folds and center the line, then redraw
    pcall(vim.cmd, 'normal! zvzz')
    vim.cmd('redraw')

    local prompt = string.format('Replace at %d:%d -> "%s" (text / n / N / q): ', lnum, s + 1, match_text)
    local input = vim.fn.input(prompt, last or '')

    if input == 'q' then break end

    local skip = false
    if input == 'n' then
      lnum, col = next_match()
      if lnum == 0 then vim.notify("No more matches", vim.log.levels.INFO) end
      skip = true
    elseif input == 'N' then
      lnum, col = prev_match()
      if lnum == 0 then vim.notify("No previous matches", vim.log.levels.INFO) end
      skip = true
    end

    if not skip then
      if input == '' and last then input = last end
      last = input

      -- build new line: s is 0-based, string.sub is 1-based
      local before = (s > 0) and line:sub(1, s) or ""
      local after = (e < #line) and line:sub(e + 1) or ""
      local new_line = before .. input .. after

      vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, {new_line})
      -- move cursor after inserted text
      vim.api.nvim_win_set_cursor(0, {lnum, #before + #input})

      -- find next match after current cursor
      lnum, col = next_match()
    end

    if lnum == 0 then break end
  end
end

vim.api.nvim_create_user_command('IWR', function(opts) interactive_replace(opts) end, {nargs='?'})

