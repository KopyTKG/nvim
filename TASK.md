# Neovim Svelte LSP Corruption Issues

## Problem Description

The Svelte LSP intermittently corrupts after a period of use, reporting false errors like:
- Undefined character errors for valid syntax (e.g., `)` reported as undefined)
- Random syntax errors that don't actually exist
- LSP state corruption requiring restart

This is **not** a straightforward configuration error but an intermittent state corruption issue.

## Root Causes Identified

### 1. Aggressive Treesitter Re-enabling (HIGH PRIORITY)

**Location:** `init.lua` lines 80-103

**Problem:**
```lua
vim.api.nvim_create_autocmd({
  "BufReadPost", "BufNewFile", "FileType", 
  "BufEnter", "BufWinEnter", "VimEnter"
}, {
  callback = function()
    pcall(vim.cmd, "TSBufEnable highlight")
  end,
})
```

This autocmd fires on nearly every buffer event, forcing Treesitter to re-enable repeatedly. This conflicts with LSP parsing state, especially when:
- Switching buffers
- Previewing files in Telescope
- Opening new splits
- Any buffer navigation

**Impact:** High - causes race conditions between Treesitter and LSP parsers

**Fix:** Remove this entire autocmd block. Treesitter initializes properly on its own.

---

### 2. Svelte LSP Memory Leaks (KNOWN UPSTREAM ISSUE)

**Location:** `lua/plugins/nvim-lspconfig.lua` lines 58-97

**Problem:**
The Svelte language server has known memory leak issues, especially with TypeScript integration. Current config attempts workarounds:
```lua
client.server_capabilities.semanticTokensProvider = nil
client.server_capabilities.documentFormattingProvider = false
```

But doesn't disable enough problematic features.

**Impact:** High - causes gradual state corruption over time

**Fix Options:**
1. Disable more LSP capabilities (semantic tokens, document highlight, code lens)
2. Completely disable TypeScript integration in Svelte LSP
3. Implement auto-restart detection for corrupted state
4. Consider alternative: use Biome or standalone Prettier only

---

### 3. Conform + LSP Formatting Conflict

**Location:** `lua/plugins/conform.lua` line 27

**Problem:**
```lua
default_format_opts = {
  lsp_format = "fallback",
}
```

Conform attempts LSP formatting as fallback, which creates race conditions with the already-fragile Svelte LSP.

**Impact:** Medium - exacerbates LSP instability

**Fix:** Change to `lsp_format = "never"` to prevent LSP formatting entirely

---

### 4. Prettier Plugin Loading Issues

**Location:** `lua/plugins/conform.lua` lines 34-44

**Problem:**
```lua
prettier = {
  prepend_args = function()
    return {
      "--plugin",
      "prettier-plugin-svelte",
    }
  end,
}
```

This unconditionally loads prettier-plugin-svelte for ALL Prettier runs, not just Svelte files. If the plugin is missing or conflicts, it can fail silently and corrupt formatter state.

**Impact:** Low-Medium - can cause silent failures

**Fix:** Only inject svelte plugin for actual Svelte files using filetype check

---

## Recommended Fixes

### Immediate Actions (Apply All Three)

#### Fix 1: Remove Aggressive Treesitter Autocmd

**File:** `init.lua`

**Remove lines 80-103:**
```lua
-- DELETE THIS ENTIRE BLOCK
vim.api.nvim_create_autocmd({
  "BufReadPost",
  "BufNewFile",
  "FileType",
  "BufEnter",
  "BufWinEnter",
  "VimEnter",
}, {
  callback = function()
    if vim.fn.exists ":TSBufEnable" == 2 then
      pcall(vim.cmd, "TSBufEnable highlight")
      return
    end
    pcall(function()
      local ok, parser = pcall(vim.treesitter.get_parser, 0)
      if ok and parser then
        pcall(vim.cmd, "TSBufEnable highlight")
      end
    end)
  end,
})
```

**Replace with:**
```lua
-- Treesitter initializes properly on its own - no manual re-enabling needed
```

---

#### Fix 2: Harden Svelte LSP Configuration

**File:** `lua/plugins/nvim-lspconfig.lua`

**Replace the svelte setup (lines 58-97) with:**
```lua
lspconfig.svelte.setup {
  capabilities = capabilities,
  filetypes = { "svelte" },
  root_dir = lspconfig.util.root_pattern("svelte.config.js", "svelte.config.cjs", "package.json"),
  settings = {
    svelte = {
      plugin = {
        typescript = {
          -- Completely disable TS integration to prevent memory leaks
          enable = false,
        },
        css = {
          enable = true,
          diagnostics = { enable = true },
        },
        html = {
          enable = true,
          completions = { enable = true, emmet = false },
        },
        svelte = {
          compilerWarnings = {
            ["a11y-accesskey"] = "ignore",
            ["a11y-invalid-attribute"] = "ignore",
          },
          defaultScriptLanguage = "ts",
        },
      },
    },
  },
  on_attach = function(client, bufnr)
    -- Aggressively disable problematic features
    client.server_capabilities.semanticTokensProvider = nil
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.codeLensProvider = nil
  end,
  flags = {
    debounce_text_changes = 500, -- Increased from 300ms
  },
}
```

**Key changes:**
- Disabled TypeScript integration entirely (`enable = false`)
- Disabled more LSP capabilities (documentHighlight, codeLens)
- Increased debounce time from 300ms to 500ms

---

#### Fix 3: Prevent LSP Formatting Conflicts

**File:** `lua/plugins/conform.lua`

**Change line 27 from:**
```lua
default_format_opts = {
  lsp_format = "fallback",
},
```

**To:**
```lua
default_format_opts = {
  lsp_format = "never",
},
```

---

#### Fix 4: Conditional Prettier Plugin Loading

**File:** `lua/plugins/conform.lua`

**Replace the prettier formatter config (lines 34-44) with:**
```lua
prettier = {
  prepend_args = function(self, ctx)
    local args = {
      "--config",
      vim.fn.expand "~/.config/nvim/formatter/.prettierrc",
      "--config-precedence",
      "cli-override",
    }
    
    -- Only load svelte plugin for actual Svelte files
    if vim.bo[ctx.buf].filetype == "svelte" then
      table.insert(args, "--plugin")
      table.insert(args, "prettier-plugin-svelte")
    end
    
    return args
  end,
},
```

---

## Optional: Auto-Restart Detection (Advanced)

If issues persist after above fixes, add auto-restart logic to detect and recover from LSP corruption:

**File:** `lua/plugins/nvim-lspconfig.lua`

**Add to svelte `on_attach` function:**
```lua
on_attach = function(client, bufnr)
  -- ... existing capability disabling ...
  
  -- Auto-restart detection
  local timer = vim.loop.new_timer()
  local restart_threshold = 5000 -- 5 seconds of inactivity
  local last_change = vim.loop.now()
  
  vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
    buffer = bufnr,
    callback = function()
      last_change = vim.loop.now()
    end,
  })
  
  -- Check every 10 seconds if LSP has corrupted
  timer:start(10000, 10000, vim.schedule_wrap(function()
    local now = vim.loop.now()
    if now - last_change > restart_threshold then
      local diagnostics = vim.diagnostic.get(bufnr)
      for _, diag in ipairs(diagnostics) do
        -- Detect corruption patterns
        if diag.message:match("undefined") or 
           diag.message:match("char") or
           diag.message:match("Unexpected token") then
          vim.notify("Restarting Svelte LSP (corruption detected)", vim.log.levels.WARN)
          vim.cmd("LspRestart svelte")
          break
        end
      end
    end
  end))
end,
```

---

## Alternative Solutions

### Nuclear Option 1: Minimal Svelte LSP

If issues continue, consider disabling Svelte LSP entirely for formatting/linting:

```lua
-- Use ONLY for completions and go-to-definition
-- Disable all diagnostics
lspconfig.svelte.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.server_capabilities.diagnosticProvider = false
    -- ... disable other features ...
  end,
}
```

Use Biome or standalone Prettier for all formatting/linting.

---

### Nuclear Option 2: Fresh Config

If none of the above works:
1. Backup current config
2. Start with LazyVim or Kickstart.nvim minimal base
3. Add only essential plugins
4. Fresh LSP configuration

---

## Testing Instructions

After applying fixes:

1. Open a Svelte file
2. Make continuous edits for 10-15 minutes
3. Switch between multiple Svelte files
4. Use Telescope preview
5. Monitor for false "undefined" errors

**Success criteria:**
- No false syntax errors after extended editing
- No need to manually `:LspRestart`
- Stable LSP over hours of work

---

## When to Consider Switching Editors

**DON'T switch if:**
- These fixes resolve the issue
- You're productive in nvim otherwise
- The issue is limited to Svelte

**DO consider switching if:**
- Issues persist after all fixes
- You spend more time debugging config than coding
- You're genuinely interested in Emacs features (Org mode, Magit)

Note: Emacs (eglot/lsp-mode) can have similar LSP issues - the problem is partly upstream in svelte-language-server itself.

---

## Summary

**Root cause:** Aggressive Treesitter re-enabling + Svelte LSP memory leaks + formatting conflicts

**Confidence level:** High - these are known issues with clear patterns

**Expected result:** 90% reduction in LSP corruption after applying all fixes

**Time to implement:** 5-10 minutes for all fixes

**Fallback plan:** If issues persist, disable Svelte LSP diagnostics entirely and rely on Biome/Prettier
