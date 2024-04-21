-- Create an autocmd group and clear it to avoid duplicates
local augroup = vim.api.nvim_create_augroup("DisplayGitBranch", { clear = true })

-- Define the function to update the status line with the git branch
local function update_git_branch()
    -- Use 'git rev-parse --abbrev-ref HEAD' to get the current branch name
    local handle = io.popen("git -C " .. vim.fn.expand('%:p:h') .. " rev-parse --abbrev-ref HEAD 2> /dev/null")
    if handle then
        local git_branch = handle:read("*a"):gsub("\n", "")
        handle:close()

        -- Update a custom namespace in the statusline
        if git_branch ~= "" and git_branch ~= "HEAD" then
            vim.b.git_branch = git_branch
        else
            vim.b.git_branch = nil
        end
    end
end

-- Create an autocmd that triggers on buffer enter
vim.api.nvim_create_autocmd("BufEnter", {
    desc = "Update the status line with the git branch",
    group = augroup,
    callback = update_git_branch,
})

-- Example status line setup, assuming you use the 'statusline' option
vim.o.statusline = "%f %h%m%r git:%{get(b:, 'git_branch', 'No Branch')} %=%-14.(%l,%c%V%) %P"

