-- Treesitter.
--
-- On Neovim 0.12 we use nvim-treesitter's `main` branch. The old `master`
-- branch is frozen and incompatible with 0.12's treesitter internals (it
-- crashes in the highlighter while parsing injections). `main` has no
-- "modules": there is no `configs.setup{ highlight = ... }`. Instead we install
-- parsers ourselves and start highlighting/indentation per buffer from a
-- FileType autocmd.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      local languages = require "config.languages"
      local ts = require "nvim-treesitter"

      -- Install the configured parsers (async; a no-op for ones already built).
      ts.install(languages.treesitter)

      -- Set of languages that actually have a grammar in the registry. Used to
      -- avoid trying to install a parser for a filetype that has none (oil,
      -- fzf, ...), which would spam "skipping unsupported language" warnings.
      local installable = {}
      for _, l in ipairs(require("nvim-treesitter.config").get_available()) do
        installable[l] = true
      end

      -- Start treesitter highlighting + indentation for every buffer whose
      -- filetype maps to an available parser. Missing parsers are fetched on
      -- demand, preserving the old `auto_install = true` behaviour.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("kopy_treesitter", { clear = true }),
        callback = function(ev)
          local buf = ev.buf
          -- Resolve filetype -> parser language (honours registrations such as
          -- xaml -> xml done in lua/kopy/dotnet.lua).
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then return end

          local function enable()
            if not vim.api.nvim_buf_is_valid(buf) then return end
            if pcall(vim.treesitter.start, buf, lang) then
              vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end

          -- Parser already available -> just start it.
          local ok, available = pcall(vim.treesitter.language.add, lang)
          if ok and available then
            enable()
          elseif installable[lang] then
            -- Known grammar we don't have yet: install then start.
            ts.install({ lang }):await(vim.schedule_wrap(enable))
          end
          -- Otherwise the filetype has no grammar (oil, fzf, ...) -> do nothing.
        end,
      })
    end,
  },
}
