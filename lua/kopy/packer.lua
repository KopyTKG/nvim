-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Auto-install packer.nvim if it's not already installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope for fuzzy finding, etc.
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',  -- Use a specific version to avoid breaking changes
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Catppuccin theme
    use {
        "catppuccin/nvim",
        as = "catppuccin",
        config = function()
            vim.cmd('colorscheme catppuccin')
        end
    }

    -- Treesitter for enhanced syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
    }

    -- Plenary, required by many plugins
    use "nvim-lua/plenary.nvim"

    -- Harpoon, a mark manager to quickly navigate files
    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { {"nvim-lua/plenary.nvim"} }
    }

    -- nvim-dap for debugging
    use 'mfussenegger/nvim-dap'

    -- Mason for managing LSP, DAP, linters, and formatters
    use {
        "williamboman/mason.nvim",
        config = function()
            require('mason').setup()
        end
    }

    -- Mason LSP configurations
    use {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require('mason-lspconfig').setup({
                -- Automatically setup servers that are installed through Mason
                automatic_installation = true,
            })
        end
    }

    -- Neovim LSP configurations
    use {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require('lspconfig')

            -- Setup servers here with lspconfig.SERVER.setup{}
            -- Example: lspconfig.pyright.setup{}
            -- More configurations can be added as needed
        end
    }

    -- Discord Rich Presence just for flex
    use 'andweeb/presence.nvim'

    -- LSP for web development
    use('jose-elias-alvarez/null-ls.nvim')
    use('MunifTanjim/prettier.nvim')

end)

