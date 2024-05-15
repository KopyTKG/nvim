require("kopy.remap")

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
vim.opt.timeoutlen = 300

-- Split navigations
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Scroll buffer
vim.opt.scrolloff = 10

-- Change Netrw directory listing
vim.g.netrw_liststyle = 3

-- Enable true color support
vim.o.termguicolors = true

-- Enable true color support
vim.o.termguicolors = true

-- Define custom highlight groups for Git branches
vim.cmd('highlight GitBranch guifg=#ff0000 guibg=#000000 gui=bold')

local function git_branch()

    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")

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
	group = vim.api.nvim_create_augroup("Highlight on yank", {clear = true}),
	callback = function()
		vim.highlight.on_yank()
	end,
})
