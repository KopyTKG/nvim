function HelpPopup()
  local helpText = [[
┌──────────────────────────────────────────────────────────────┐
│                        NVIM HELP MENU                        │
└──────────────────────────────────────────────────────────────┘

Sections:
  1. Common
  2. FZF-Lua
  3. DAP (Debug)
  4. Split Screen
  5. LSP
  6. Git (Lazygit + Gitsigns)
  7. Oil (File Explorer)
  8. Trouble (Diagnostics)
  9. AI Tools

Tip: type <Leader> and pause — which-key shows all available keys.

Leader Key: <Space>

═══════════════════════════════════════════════════════════════
 COMMON
───────────────────────────────────────────────────────────────
  • Save File              	 		  [<Leader>w]
  • Search & Replace       	 		  [<Leader>s]
  • Format Code            	 		  [<Leader>f]

═══════════════════════════════════════════════════════════════
 FZF-LUA
───────────────────────────────────────────────────────────────
  • Find Files             			 [<Leader>ff]
  • Find Git Files         			 [<Leader>fg]
  • Live Grep (project)    			 [<Leader>gw]
  • Search current word    			 [<Leader>fw]
  • Find Buffers           			 [<Leader>fb]
  • Find Recent Files      			 [<Leader>fr]
  • Find Help Tags         			 [<Leader>fh]
  • Find Keymaps           			 [<Leader>fk]
  • Find Diagnostics       			 [<Leader>fd]

═══════════════════════════════════════════════════════════════
 DAP (DEBUG)
───────────────────────────────────────────────────────────────
  • Continue / Start         				 [F5]
  • Step Over                			        [F10]
  • Step Into                			        [F11]
  • Step Out                 			        [F12]
  • Toggle Breakpoint        			 [<Leader>db]
  • Conditional Breakpoint   			 [<Leader>dB]
  • Toggle REPL              			 [<Leader>dr]
  • Toggle DAP UI            			 [<Leader>du]
  • Terminate Session        			 [<Leader>dt]
  • Eval Expression          			 [<Leader>de]

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
  • Show Hover Info        			  [<leader>g]
  • Show Diagnostics       			  [<leader>e]
  • Next Diagnostic        			  [<leader>d]
  • Previous Diagnostic    			  [<leader>a]
  • Show all diagnostics   			  [<leader>q]

═══════════════════════════════════════════════════════════════
 GIT (LAZYGIT + GITSIGNS)
───────────────────────────────────────────────────────────────
  Lazygit:
  • Open Lazygit           			 [<Leader>lz]

  Gitsigns (in-buffer):
  • Next hunk              				 []c]
  • Prev hunk              				 [[c]
  • Preview hunk           			 [<Leader>gp]
  • Stage hunk             			 [<Leader>gs]
  • Reset hunk             			 [<Leader>gr]
  • Undo stage hunk        			 [<Leader>gu]
  • Stage buffer           			 [<Leader>gS]
  • Reset buffer           			 [<Leader>gR]
  • Blame line (full)      			 [<Leader>gb]
  • Toggle line blame      			 [<Leader>gB]
  • Diff this              			 [<Leader>gd]

═══════════════════════════════════════════════════════════════
 OIL (FILE EXPLORER)
───────────────────────────────────────────────────────────────
  • Open parent directory  			 		[-]
  • Open parent (alt)      			 [<Leader>pv]
  • Open in floating win   			  [<Leader>e]
  In Oil buffer:
  • Select / Enter         			      [<CR>]
  • Open in vsplit         			     [<C-s>]
  • Open in hsplit         			     [<C-h>]
  • Preview                			     [<C-p>]
  • Close                  			     [<C-c>]
  • Refresh                			     [<C-r>]
  • Parent dir             			 		[-]
  • CD to dir              			 		[`]
  • Toggle hidden          			       [g.]
  • Help                   			       [g?]

═══════════════════════════════════════════════════════════════
 TROUBLE (DIAGNOSTICS)
───────────────────────────────────────────────────────────────
  • Workspace diagnostics  			 [<Leader>xx]
  • Buffer diagnostics     			 [<Leader>xX]
  • Document symbols       			 [<Leader>xs]
  • LSP defs/refs          			 [<Leader>xl]
  • Location list          			 [<Leader>xL]
  • Quickfix list          			 [<Leader>xQ]

═══════════════════════════════════════════════════════════════
 AI TOOLS
───────────────────────────────────────────────────────────────
  Codeium (AI Autocomplete):
  • Accept suggestion      			   	 [Tab]
  • Next suggestion        			   [Ctrl+n]
  • Prev suggestion        			   [Ctrl+p]
  • Dismiss                			   [Ctrl+e]

  Claude Code (AI Assistant):
  • Open Claude Code       			 [<Leader>co]
  • Open with Opus Model   			[<Leader>cop]
  • Open with Haiku Model  			[<Leader>coh]

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
