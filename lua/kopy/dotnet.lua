-- .NET / MAUI workflow helpers.
--
-- C# language intelligence is handled by Roslyn (lua/plugins/roslyn.lua) and
-- debugging by netcoredbg (lua/plugins/nvim-dap.lua). This module adds the
-- glue MAUI needs on top of plain C#: XAML highlighting and build/run/deploy
-- commands that understand multi-targeted (net*-android/ios/...) projects.

local M = {}

-- ─── XAML ─────────────────────────────────────────────────────────────────
-- Give .xaml its own filetype but render it with the XML tree-sitter parser
-- (there is no dedicated MAUI XAML parser). Highlight-only: no language server
-- is attached, since generic XML servers emit noisy false positives on MAUI
-- markup (custom namespaces, x: directives, markup extensions).
vim.filetype.add { extension = { xaml = "xaml" } }
pcall(vim.treesitter.language.register, "xml", "xaml")

-- ─── dotnet plumbing ──────────────────────────────────────────────────────
-- Run dotnet through mise when available so the project's pinned SDK is used
-- even if nvim's PATH didn't pick up mise's shell hook. Mirrors nvim-dap.lua.
local function dotnet()
  if vim.fn.executable "mise" == 1 then
    return "mise exec -- dotnet"
  end
  return "dotnet"
end

-- Open a bottom split running `cmd` in a terminal so build/run output (and any
-- prompts) stay visible and interactive.
local function run_in_terminal(cmd)
  vim.cmd "botright split"
  vim.cmd "resize 18"
  vim.cmd("terminal " .. cmd)
  vim.cmd "startinsert"
end

-- Nearest .csproj walking upward from the current file (falls back to cwd).
local function find_csproj()
  local start = vim.fn.expand "%:p:h"
  if start == "" then start = vim.fn.getcwd() end
  local found = vim.fs.find(function(name)
    return name:match "%.csproj$"
  end, { upward = true, path = start, type = "file" })
  return found[1]
end

-- Target frameworks declared in a .csproj: <TargetFrameworks> (MAUI, multiple)
-- or <TargetFramework> (single). Conditional MSBuild fragments are skipped.
local function target_frameworks(csproj)
  local tfms = {}
  local content = table.concat(vim.fn.readfile(csproj), "\n")
  local multi = content:match "<TargetFrameworks>(.-)</TargetFrameworks>"
  if multi then
    for tfm in multi:gmatch "[^;%s]+" do
      if not tfm:match "^%$" then -- skip $(Variables)
        table.insert(tfms, tfm)
      end
    end
  else
    local single = content:match "<TargetFramework>(.-)</TargetFramework>"
    if single and not single:match "^%$" then
      table.insert(tfms, single)
    end
  end
  return tfms
end

-- Resolve a .csproj + target framework, then invoke cb(tfm, csproj). When more
-- than one TFM exists (typical MAUI project) the user picks one.
local function with_tfm(cb)
  local csproj = find_csproj()
  if not csproj then
    vim.notify("No .csproj found upward from current file.", vim.log.levels.ERROR, { title = ".NET" })
    return
  end
  local tfms = target_frameworks(csproj)
  if #tfms <= 1 then
    cb(tfms[1], csproj)
  else
    vim.ui.select(tfms, { prompt = "Target framework:" }, function(choice)
      if choice then cb(choice, csproj) end
    end)
  end
end

-- ─── commands ─────────────────────────────────────────────────────────────
-- Build for the chosen target framework.
function M.build()
  with_tfm(function(tfm, csproj)
    local f = tfm and (" -f " .. tfm) or ""
    run_in_terminal(dotnet() .. " build " .. vim.fn.shellescape(csproj) .. f)
  end)
end

-- Build and launch. For mobile TFMs `-t:Run` deploys to the running Android
-- emulator / connected device (start one first with :MauiEmulator).
function M.run()
  with_tfm(function(tfm, csproj)
    local f = tfm and (" -f " .. tfm) or ""
    run_in_terminal(dotnet() .. " build " .. vim.fn.shellescape(csproj) .. " -t:Run" .. f)
  end)
end

-- Pick and boot an Android emulator (AVD). Needs $ANDROID_HOME/emulator on PATH.
function M.emulator()
  if vim.fn.executable "emulator" ~= 1 then
    vim.notify(
      "`emulator` not on PATH. Add $ANDROID_HOME/emulator (or the Android SDK emulator dir) to PATH.",
      vim.log.levels.ERROR,
      { title = ".NET" }
    )
    return
  end
  local avds = vim.tbl_filter(function(l)
    return l ~= ""
  end, vim.fn.systemlist "emulator -list-avds")
  if #avds == 0 then
    vim.notify("No Android AVDs found. Create one in Android Studio's Device Manager.", vim.log.levels.WARN, { title = ".NET" })
    return
  end
  local function launch(avd)
    vim.fn.jobstart({ "emulator", "-avd", avd }, { detach = true })
    vim.notify("Booting emulator: " .. avd, vim.log.levels.INFO, { title = ".NET" })
  end
  if #avds == 1 then
    launch(avds[1])
  else
    vim.ui.select(avds, { prompt = "Android AVD:" }, function(choice)
      if choice then launch(choice) end
    end)
  end
end

-- Install the MAUI workload (one-time prerequisite before any MAUI build).
function M.install_workload()
  run_in_terminal(dotnet() .. " workload install maui")
end

vim.api.nvim_create_user_command("MauiRun", M.run, { desc = "Build & run for a chosen target framework" })
vim.api.nvim_create_user_command("MauiBuild", M.build, { desc = "Build for a chosen target framework" })
vim.api.nvim_create_user_command("MauiEmulator", M.emulator, { desc = "Boot an Android emulator (AVD)" })
vim.api.nvim_create_user_command("MauiWorkload", M.install_workload, { desc = "Install the .NET MAUI workload" })

vim.keymap.set("n", "<leader>nr", M.run, { desc = ".NET/MAUI: Run (build -t:Run)" })
vim.keymap.set("n", "<leader>nb", M.build, { desc = ".NET/MAUI: Build" })
vim.keymap.set("n", "<leader>ne", M.emulator, { desc = ".NET/MAUI: Launch Android emulator" })
vim.keymap.set("n", "<leader>nw", M.install_workload, { desc = ".NET/MAUI: Install maui workload" })

return M
