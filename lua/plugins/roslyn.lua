-- Roslyn language server for C# (replaces omnisharp).
--
-- The server binary is installed by Mason as the `roslyn` package from the
-- github:Crashdummyy/mason-registry registry (added in after/plugin/mason.lua
-- and requested via languages.mason_extra). roslyn.nvim finds the Mason
-- install automatically.
--
-- Requires Neovim >= 0.12 and .NET SDK >= 10 (both satisfied here).
return {
  "seblyng/roslyn.nvim",
  ft = { "cs" },
  ---@module "roslyn.config"
  ---@type RoslynNvimConfig
  opts = {
    -- Large multi-targeted solutions (MAUI targets net-android/ios/maccatalyst/
    -- windows at once) generate a lot of file events. Let Roslyn own file
    -- watching instead of Neovim to keep the editor responsive.
    filewatching = "roslyn",
    -- Look for .sln/.slnf in child directories too, so opening a file from the
    -- repo root still finds the solution.
    broad_search = true,
  },
}
