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
      dap.adapters.coreclr = {
        type = "executable",
        command = vim.fn.exepath "netcoredbg",
        args = { "--interpreter=vscode" },
      }

      -- Find the most likely DLL in the current project.
      local function find_dotnet_dll()
        local cwd = vim.fn.getcwd()
        local cmd = string.format(
          "find %q -path '*/bin/Debug/*' -name '*.dll' -not -name '*.Tests.dll' 2>/dev/null | head -20",
          cwd
        )
        local handle = io.popen(cmd)
        if not handle then return nil end
        local results = {}
        for line in handle:lines() do table.insert(results, line) end
        handle:close()
        return results
      end

      -- Pick a DLL: single match auto-selects, multiple prompts, none prompts free-form.
      local function dll_picker()
        return coroutine.create(function(co)
          local dlls = find_dotnet_dll() or {}
          if #dlls == 1 then
            coroutine.resume(co, dlls[1])
          elseif #dlls > 1 then
            vim.schedule(function()
              vim.ui.select(dlls, { prompt = "Select DLL to debug:" }, function(choice)
                coroutine.resume(co, choice or dap.ABORT)
              end)
            end)
          else
            vim.schedule(function()
              local input = vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/", "file")
              coroutine.resume(co, input ~= "" and input or dap.ABORT)
            end)
          end
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
          program = dll_picker,
          cwd = function() return vim.fn.getcwd() end,
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
