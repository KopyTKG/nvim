# NeoVIM config
This is my personal NeoVIM configuration. It is a work in progress and will be updated as I learn more about NeoVIM and Vimscript.

## Prerequisites
- [NeoVIM](https://neovim.io/)
- [Packer.nvim](https://github.com/wbthomason/packer.nvim)
- [Copilot](https://github.com/github/copilot.vim)

## Plugins
- [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [catppuccin/nvim](https://github.com/catppuccin/nvim)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [ThePrimeagen/harpoon2](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)
- [mfussenegger/nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [andweeb/presence.nvim](https://github.com/andweeb/presence.nvim)

## Not nvim tools
- [Lazygit](https://github.com/jesseduffield/lazygit)

## Installation
1. Clone this repository to your `~/.config/nvim` directory.
2. Open NeoVIM and run `:PackerSync` to install the plugins.
3. Restart NeoVIM.

## Keybindings
### General
- `<leader>` is set to the space bar.
- `<leader>w` - Save the current buffer.
- `<leader>pv` - Open builtin file explorer.
- `<F12>` - Opens terminal with `lazygit`.

### Harpoon
- `<leader>a` - Add the current file to the Harpoon bookmarks.
- `<C-e>` - Toggle the Harpoon bookmarks.
- `<leader>1` - Open the first bookmark.
- `<leader>2` - Open the second bookmark.
- `<leader>3` - Open the third bookmark.
- `<leader>4` - Open the fourth bookmark.
- `<F2>` - Open previous bookmark.
- `<F3>` - Open next bookmark.

### Telescope
- `<leader>pf` - Find files.
- `<leader>pg` - Find git files.
- `<leader>ps` - Find with grep text in files.

*TBD comming soon*
