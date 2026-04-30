return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "mason-org/mason.nvim",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP: Continue / Start" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP: Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP: Step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP: Step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "DAP: Conditional breakpoint" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "DAP: REPL toggle" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP: UI toggle" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "DAP: Terminate" },
      { "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, desc = "DAP: Eval expression", mode = { "n", "v" } },
      { "<leader>da", function() _G.DapActionPicker() end, desc = "DAP: Action picker" },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- Install debug adapters via Mason.
      require("mason-nvim-dap").setup {
        ensure_installed = { "netcoredbg" },
        automatic_installation = true,
        handlers = {}, -- use default handlers; we override coreclr below
      }

      dapui.setup()
      require("nvim-dap-virtual-text").setup {}

      -- Auto-open/close the UI with sessions.
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- Breakpoint signs.
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual", numhl = "" })

      -- ─── C# (.NET) via netcoredbg ───────────────────────────────────────────
      -- Lazy adapter: look up the binary at launch time, not config-load
      -- time. Mason-installed netcoredbg may not be on PATH yet when this
      -- file first executes.
      dap.adapters.coreclr = function(callback, _)
        local exe = vim.fn.exepath "netcoredbg"
        if exe == "" then
          -- Mason installs to this path on Linux.
          local mason_path = vim.fn.stdpath "data" .. "/mason/bin/netcoredbg"
          if vim.fn.executable(mason_path) == 1 then
            exe = mason_path
          end
        end
        if exe == "" then
          vim.notify(
            "netcoredbg not found. Run :MasonInstall netcoredbg, then try again.",
            vim.log.levels.ERROR,
            { title = "DAP" }
          )
          return
        end
        callback {
          type = "executable",
          command = exe,
          args = { "--interpreter=vscode" },
        }
      end

      -- Find each .NET project's own entry-point DLL under the cwd.
      -- A "project DLL" is one whose basename matches its containing project
      -- folder (e.g. .../Foo/bin/Debug/net9.0/Foo.dll). Dependency copies
      -- (e.g. .../Foo/bin/Debug/.../DataLayer.dll) are filtered out.
      local function find_dotnet_dll()
        local cwd = vim.fn.getcwd()
        local cmd = string.format(
          "find %q -path '*/bin/Debug/*' -name '*.dll' -not -name '*.Tests.dll' 2>/dev/null",
          cwd
        )
        local handle = io.popen(cmd)
        if not handle then return nil end
        local results = {}
        for line in handle:lines() do
          local proj = line:match("/([^/]+)/bin/Debug/")
          local dll_name = line:match("/([^/]+)%.dll$")
          if proj and dll_name and proj == dll_name then
            table.insert(results, line)
          end
        end
        handle:close()
        return results
      end

      -- Run `dotnet build` on the current cwd and call back with success/failure.
      -- If mise is available, run dotnet through it so the project's pinned SDK
      -- (mise.toml) is resolved correctly even when nvim's PATH didn't pick up
      -- mise's shell hook (e.g. nvim launched from a non-shell context).
      local function dotnet_build(on_done)
        local cmd = vim.fn.executable("mise") == 1
          and { "mise", "exec", "--", "dotnet", "build" }
          or { "dotnet", "build" }
        vim.notify("dotnet build…", vim.log.levels.INFO, { title = "DAP" })
        vim.system(
          cmd,
          { cwd = vim.fn.getcwd(), text = true },
          function(result)
            vim.schedule(function()
              if result.code == 0 then
                vim.notify("dotnet build OK", vim.log.levels.INFO, { title = "DAP" })
                on_done(true)
              else
                local msg = (result.stderr ~= "" and result.stderr or result.stdout) or "(no output)"
                vim.notify("dotnet build FAILED:\n" .. msg, vim.log.levels.ERROR, { title = "DAP" })
                on_done(false)
              end
            end)
          end
        )
      end

      -- Track the most recently picked DLL so the launch's `cwd` can derive
      -- from it (.NET reads appsettings.json relative to cwd, and we usually
      -- want the project folder, not the solution folder).
      local last_picked_dll = nil

      -- Resolve the DLL list (re-scan after build so freshly produced DLLs show).
      local function resolve_dll(co)
        local dlls = find_dotnet_dll() or {}
        local function pick(p)
          last_picked_dll = p
          coroutine.resume(co, p or dap.ABORT)
        end
        if #dlls == 1 then
          pick(dlls[1])
        elseif #dlls > 1 then
          vim.ui.select(dlls, { prompt = "Select DLL to debug:" }, function(choice)
            pick(choice)
          end)
        else
          local input = vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/", "file")
          pick(input ~= "" and input or nil)
        end
      end

      -- cwd for launch: project folder (parent of bin/Debug) so appsettings.json
      -- is resolvable. Falls back to nvim's cwd if no DLL picked yet.
      local function dll_project_cwd()
        if last_picked_dll then
          local proj = last_picked_dll:match "(.*)/bin/Debug/"
          if proj then return proj end
        end
        return vim.fn.getcwd()
      end

      -- Build first, then pick a DLL. If build fails, abort the launch.
      local function build_and_pick_dll()
        return coroutine.create(function(co)
          dotnet_build(function(ok)
            if not ok then
              coroutine.resume(co, dap.ABORT)
              return
            end
            resolve_dll(co)
          end)
        end)
      end

      -- ─── Action picker (<leader>da) ─────────────────────────────────────────
      -- Single popup with every common DAP action. Uses fzf-lua's vim.ui.select.
      _G.DapActionPicker = function()
        local actions = {
          { label = "▶  Continue / Start",          fn = function() dap.continue() end },
          { label = "↻  Run Last Config",           fn = function() dap.run_last() end },
          { label = "⏸  Pause",                    fn = function() dap.pause() end },
          { label = "↺  Restart Session",           fn = function() dap.restart() end },
          { label = "■  Terminate Session",         fn = function() dap.terminate() end },
          { label = "⤼  Step Over",                fn = function() dap.step_over() end },
          { label = "↘  Step Into",                 fn = function() dap.step_into() end },
          { label = "↗  Step Out",                  fn = function() dap.step_out() end },
          { label = "→  Run to Cursor",             fn = function() dap.run_to_cursor() end },
          { label = "●  Toggle Breakpoint",         fn = function() dap.toggle_breakpoint() end },
          { label = "◆  Set Conditional Breakpoint",fn = function() dap.set_breakpoint(vim.fn.input("Condition: ")) end },
          { label = "#  Set Hit-count Breakpoint",  fn = function() dap.set_breakpoint(nil, vim.fn.input("Hit count: ")) end },
          { label = "◇  Set Logpoint",              fn = function() dap.set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end },
          { label = "✗  Clear All Breakpoints",     fn = function() dap.clear_breakpoints() end },
          { label = "!  Exception Breakpoints…",    fn = function() dap.set_exception_breakpoints() end },
          { label = "□  Toggle DAP UI",             fn = function() dapui.toggle() end },
          { label = ">_ Toggle REPL",               fn = function() dap.repl.toggle() end },
          { label = "?  Eval Expression",           fn = function() dapui.eval(nil, { enter = true }) end },
          { label = "↑  Up Frame",                  fn = function() dap.up() end },
          { label = "↓  Down Frame",                fn = function() dap.down() end },
        }

        local labels = {}
        for _, a in ipairs(actions) do table.insert(labels, a.label) end

        vim.ui.select(labels, { prompt = "DAP Action:" }, function(_, idx)
          if not idx then return end
          actions[idx].fn()
        end)
      end

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = build_and_pick_dll,
          cwd = dll_project_cwd,
          env = {
            ASPNETCORE_ENVIRONMENT = "Development",
            ASPNETCORE_URLS = "http://localhost:5158",
          },
          stopAtEntry = false,
        },
        {
          type = "coreclr",
          name = "attach - netcoredbg",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }
    end,
  },
}
