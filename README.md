# NeoVIM config
This is my personal NeoVIM configuration. It is a work in progress and will be updated as I learn more about NeoVIM and Vimscript.

## Prerequisites
- [NeoVIM](https://neovim.io/)
- [Golang](https://golang.org/dl/) (for gopls)
- [Node.js](https://nodejs.org/en/download/) (for tsserver)
- [NPM](https://www.npmjs.com/get-npm) (for tsserver)
- [Bun](https://bun.sh/) (for bun)
- [Lazygit](https://github.com/jesseduffield/lazygit) (for git integration)

## Plugins
all packages are listed and configured inn `lua/kopy/plugins.lua` file.
- [lazy.lua](#/lua/kopy/lazy.lua) - Plugin manager.

### exepction
- [Mason](#/after/plugin/mason.lua) - Deafult configuration for Mason.
- [CMP](#/after/plugin/cmp.lua) - Deafult configuration for CMP.

## Not nvim tools
- [Lazygit](https://github.com/jesseduffield/lazygit)

## Installation
1. Clone this repository to your `~/.config/nvim` directory.
2. Open NeoVIM and wait for lazy + mason to do its things.


## Keybindings
all keybindings are listed in build in help menu under `<F1>` key.
