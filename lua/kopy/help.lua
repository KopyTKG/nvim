function HelpPopup()
  local helpText = [[
┌──────────────────────────────────────────────────────────────┐
│                        NVIM HELP MENU                        │
└──────────────────────────────────────────────────────────────┘

Sections:
  1. Common
  2. Telescope
  3. Harpoon
  4. Split Screen
  5. LSP
  6. GIT
  7. Netrw

Leader Key: <Space>

═══════════════════════════════════════════════════════════════
 COMMON
───────────────────────────────────────────────────────────────
  • Open File Explorer      	 		  [<Leader>e]
  • Save File              	 		  [<Leader>w]
  • Search & Replace       	 		  [<Leader>s]
  • Comment Line           	 		 [<Leader>cl]
  • Comment Block          	 		 [<Leader>cb]
  • Format Code            	 		  [<Leader>f]

═══════════════════════════════════════════════════════════════
 TELESCOPE
───────────────────────────────────────────────────────────────
  • Find Files             			 [<Leader>ff]
  • Find Git Files         			 [<Leader>fg]
  • Grep for word          			 [<Leader>gw]
  • Search current word    			 [<Leader>fw]

═══════════════════════════════════════════════════════════════
 HARPOON
───────────────────────────────────────────────────────────────
  • Add file to Harpoon        			 [<Leader>ha]
  • Remove file from Harpoon   			 [<Leader>hr]
  • Toggle Harpoon menu        			 [<Leader>hl]
  • Jump to file 1-10          		        [<Leader>1-0]
  • Previous Harpoon file      				 [F2]
  • Next Harpoon file          				 [F3]

═══════════════════════════════════════════════════════════════
 SPLIT SCREEN
───────────────────────────────────────────────────────────────
  • Horizontal Split       			 [<Leader>jj]
  • Vertical Split         			 [<Leader>hh]
  • Move to Left Window    			  [<Leader>h]
  • Move to Right Window   			  [<Leader>l]
  • Move to Upper Window   			  [<Leader>k]
  • Move to Lower Window   			  [<Leader>j]

═══════════════════════════════════════════════════════════════
 LSP
───────────────────────────────────────────────────────────────
  • Go to Definition       			 [<leader>gd]
  • Show Hover Info        			  [<leader>k]
  • Show Diagnostics       			  [<leader>e]
  • Next Diagnostic        			  [<leader>d]
  • Previous Diagnostic    			  [<leader>a]
  • Show all diagnostics   			  [<leader>q]

═══════════════════════════════════════════════════════════════
 GIT
───────────────────────────────────────────────────────────────
  • Open Lazygit           	[F12]

═══════════════════════════════════════════════════════════════
 NETRW
───────────────────────────────────────────────────────────────
  • Open Netrw             			 [<Leader>pv]
  • Create file            	 		  [<leader>f]
  • Create directory       				  [d]
  • Rename file            			      [<C-r>]
  • Delete                 			   	  [D]

Press 'q' or <Esc> to close this help.
  ]]

  local buf = vim.api.nvim_create_buf(false, true)
  local lines = vim.split(helpText, "\n")

  local width = 64
  local height = math.floor(vim.o.lines * 0.85)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
  }

  vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "q",
    "<cmd>close<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    buf,
    "n",
    "<Esc>",
    "<cmd>close<CR>",
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

vim.keymap.set("n", "<F1>", HelpPopup, { noremap = true, silent = true })
