# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using Lazy.nvim as the plugin manager. The configuration is modular, with plugins defined in `lua/plugins/` and custom keybindings/functionality in `lua/kopy/`.

## Prerequisites

- NeoVIM
- Golang (for gopls)
- Node.js and NPM (for tsserver)
- Bun
- Lazygit (for git integration)

## Architecture

### Entry Point

- `init.lua` - Main configuration file that sets up vim options, loads lazy.nvim, and requires the kopy module
- Leader key is set to `<Space>`

### Module Structure

**Plugin Management:**
- `lua/lazy/init.lua` - Bootstraps and configures Lazy.nvim, imports all plugins from `lua/plugins/`
- `lua/plugins/` - Each file defines one or more plugins with their configurations
  - Plugins are automatically loaded by Lazy.nvim's `{ import = "plugins" }` spec

**Custom Functionality:**
- `lua/kopy/init.lua` - Central module loader that requires all custom modules
- `lua/kopy/` - Custom keybindings and functionality:
  - `help.lua` - Built-in help menu (F1)
  - `lsp.lua` - LSP-related keybindings
  - `git.lua` - Git integration keybindings
  - `telescope.lua` - Telescope fuzzy finder keybindings
  - `harpoon.lua` - Harpoon file navigation keybindings
  - `splitscreen.lua` - Split window navigation keybindings
  - `netrw.lua` - Netrw file explorer keybindings
  - `common.lua` - Common editor keybindings

**Special Configuration:**
- `after/plugin/mason.lua` - Mason LSP/formatter installer configuration (loaded after plugins)
- `after/plugin/completions.lua` - nvim-cmp completion setup (loaded after plugins)

### LSP and Tooling

**Language Servers (auto-installed via Mason):**
- lua_ls, clangd, gopls, cmake, ts_ls, html, texlab, eslint, tailwindcss, jsonls, vimls, pyright, zk, docker_language_server, copilot, prismals, csharp_ls, tombi

**Formatters (auto-installed via Mason):**
- clang-format, prettier, stylua, goimports, csharpier, black

**Formatting:**
- Uses `conform.nvim` for automatic formatting on save
- Formatter configs in `formatter/` directory:
  - `.prettierrc` - Prettier configuration
  - `stylua.toml` - Stylua configuration
- Format on save enabled with 500ms timeout

### Key Plugin Configurations

**Telescope** (`lua/plugins/telescope.lua`):
- Fuzzy finder for files, git files, and grep

**Harpoon2** (`lua/plugins/harpoon2.lua`):
- Quick file navigation system for frequently accessed files

**nvim-lspconfig** (`lua/plugins/nvim-lspconfig.lua`):
- LSP client configurations

**conform.nvim** (`lua/plugins/conform.lua`):
- Code formatting with language-specific formatter configurations

**Treesitter** (`lua/plugins/treesitter.lua`):
- Syntax highlighting and code parsing

## Common Operations

### Plugin Management

Mason (LSP/formatter installer):
```vim
:Mason
```
Inside Mason:
- `i` to install
- `u` to update
- `X` to uninstall
- `U` to update all

Lazy (plugin manager):
```vim
:Lazy
```

### Formatting

Code is automatically formatted on save. To manually format:
```
<Leader>f
```

### Help System

Press `F1` to open the built-in help menu, which displays all keybindings organized by category.

## Development Guidelines

When modifying this configuration:

1. **Adding new plugins**: Create a new file in `lua/plugins/` that returns a table with the plugin spec
2. **Adding new keybindings**: Add them to the appropriate module in `lua/kopy/` and update the help menu in `lua/kopy/help.lua`
3. **LSP configuration**: Modify `lua/plugins/nvim-lspconfig.lua` and ensure the language server is in the `ensure_installed` list in `lua/plugins/mason.lua`
4. **Formatter configuration**: Add to `formatters_by_ft` in `lua/plugins/conform.lua` and ensure the formatter is in the `ensure_installed` list in `lua/plugins/mason.lua`
5. **After-plugin configs**: Only use `after/plugin/` for configurations that must load after all plugins are initialized (like completions and mason setup)

## Important Notes

- The configuration automatically installs missing plugins on first launch
- Mason will automatically install LSP servers and formatters on first launch
- Format on save is enabled globally with a 500ms timeout
- Treesitter highlighting is enforced across all buffers including Telescope previews
- Lazygit integration is available via F12
