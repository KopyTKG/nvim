#!/usr/bin/env bash
# Bootstrap script for this nvim config on Arch.
# Idempotent — re-running is safe (uses pacman --needed).
# Run from anywhere: bash ~/.config/nvim/install.sh

set -euo pipefail

if ! command -v pacman >/dev/null 2>&1; then
  echo "This script targets Arch (pacman). Adapt for other distros." >&2
  exit 1
fi

# Required: things lazy.nvim, Mason, fzf-lua, and DAP rely on.
REQUIRED=(
  git              # lazy.nvim clones plugins
  curl             # Mason downloads
  unzip            # Mason extracts archives
  ripgrep          # fzf-lua live_grep, search-everywhere
  fd               # fzf-lua file finder
  npm              # Mason runs Node-based LSPs/tools
  python           # Mason runs Python-based tools (debugpy, etc.)
  python-pip       # ditto
  base-devel       # Mason occasionally compiles
  tree-sitter-cli  # treesitter parser builds
)

# Add `nodejs` only if no variant (nodejs / nodejs-lts-*) is already installed.
# Plain `nodejs` conflicts with LTS variants like `nodejs-lts-jod`.
if ! pacman -Q 2>/dev/null | grep -qE '^(nodejs|nodejs-lts-[a-z]+) '; then
  REQUIRED+=(nodejs)
fi

# Optional but commonly useful for this config style.
# Comment out anything you don't want.
EXTRAS=(
  bat              # syntax-highlighted previews (Telescope, lazygit)
  lazygit          # if you also add kdheepak/lazygit.nvim
  git-delta        # nicer git diffs (delta binary)
  glab             # GitLab CLI (replaces github-cli after migration)
  fzf              # not used by Telescope, but handy in the shell + fzf-lua plugin
  luarocks         # some plugins want it for extra modules
  wl-clipboard     # system clipboard on Wayland (X11: install xclip instead)
)

echo "==> Installing required packages..."
sudo pacman -S --needed --noconfirm "${REQUIRED[@]}"

echo "==> Installing optional extras..."
sudo pacman -S --needed --noconfirm "${EXTRAS[@]}"

# Note on .NET: we manage dotnet via mise (see project's mise.toml), so we
# deliberately do NOT install dotnet-sdk via pacman — that would conflict.
# If you want a system-wide dotnet anyway, run: sudo pacman -S --needed dotnet-sdk

# Note on netcoredbg: installed automatically by mason-nvim-dap on first
# DAP load (see lua/plugins/nvim-dap.lua). No action needed here.

echo
echo "==> Done."
echo "Next: open nvim, run :Lazy sync, then :Mason. Mason will install netcoredbg"
echo "and any LSPs listed in lua/config/languages.lua on first use."
