-- ====================================
--    _       _ _     _
--   (_)_ __ (_) |_  | |_   _  __ _
--   | | '_ \| | __| | | | | |/ _` |
--   | | | | | | |_ _| | |_| | (_| |
--   |_|_| |_|_|\__(_)_|\__,_|\__,_|
--
-- ====================================
-- Inspired by https://github.com/nvim-lua/kickstart.nvim
-------------------------------------------------------------------------------
-- General Settings -----------------------------------------------------------
-------------------------------------------------------------------------------
local set = vim.opt
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- vim.g.netrw_banner = 0

set.background = 'dark'
set.breakindent = true
set.completeopt:append({'menu', 'menuone', 'noselect'})
set.cursorline = true
set.diffopt:append('vertical')
set.expandtab = true
set.hidden = true
set.ignorecase = true
set.inccommand = 'nosplit'
set.incsearch = true
set.linebreak = true
set.mouse = 'a'
set.number = true
set.path:append('**')
set.relativenumber = true
set.scrolloff = 8
set.shiftwidth = 4
set.shortmess:append('c')
set.sidescrolloff = 8
set.signcolumn = 'yes'
set.smartcase = true
set.softtabstop = 4
set.tabstop = 4
set.termguicolors = true
set.wrap = false


-------------------------------------------------------------------------------
-- Keymaps --------------------------------------------------------------------
-------------------------------------------------------------------------------
local mapkey = vim.keymap.set
mapkey('n', '<leader>ce', ':edit $MYVIMRC<cr>', { desc = 'Edit init.lua' })
mapkey('n', '<leader>c/', ':nohlsearch<cr>', { desc = 'Clear search highlight' })
mapkey('n', '<leader>cn', ':set relativenumber!<cr>', { desc = 'Toggle relative line numbers' })
mapkey('n', '<leader>cs', ':setlocal spell! spelllang=en_us<cr>', { desc = 'Toggle spellcheck' })
mapkey('v', '<leader>cs', ':sort<cr>', { desc = 'Sort selection', silent = true })
mapkey('n', '<leader>cp', ':Lazy<cr>', { desc = 'Open Lazy' })
-- mapkey('n', '<leader>cf', vim.cmd.Ex, { desc = 'Open netrw' })
mapkey('x', '<leader>cv', '"_dP', { desc = 'Paste over selection without replacing buffer' })
mapkey('n', '<leader>cx', '<cmd>!chmod +x %<CR>', { desc = 'Set exec flag on file' })
mapkey('n', '<leader>c\\', ':vsp<cr>')
mapkey('n', '<leader>c-', ':sp<cr>')
mapkey('n', '<leader>r', ':!<up><cr>', { desc = 'Run last external program' })
mapkey('n', '<leader>y', '"+y')
mapkey('n', '<leader>p', '"+p')
mapkey('v', '<leader>y', '"+y')
mapkey('v', '<leader>p', '"+p')
mapkey('n', '<leader>dd', '^D')
mapkey('n', '<leader>*', ':%s/\\<<c-r><c-w>\\>//g<left><left>', { desc = 'Search & replace word under cursor' })
mapkey('o', 'fun', ':<c-u>normal! 0f(hviw<cr>', { desc = 'Change function name' })
mapkey('v', "J", ":m '>+1<CR>gv=gv")
mapkey('v', "K", ":m '<-2<CR>gv=gv")
mapkey('n', 'Y', 'yg$')
mapkey('n', 'J', 'mzJ`z')
mapkey('n', '<C-d>', '<C-d>zz')
mapkey('n', '<C-u>', '<C-u>zz')
mapkey('n', 'n', 'nzzzv')
mapkey('n', 'N', 'nzzzv')
mapkey('n', 'Q', '<nop>')


-------------------------------------------------------------------------------
-- Abbreviations --------------------------------------------------------------
-------------------------------------------------------------------------------
vim.cmd('iabbrev @@d <C-r>=strftime("%Y-%m-%d")<cr>') -- insert current date

-------------------------------------------------------------------------------
-- Auto-commands --------------------------------------------------------------
-------------------------------------------------------------------------------
local global_group = vim.api.nvim_create_augroup("GlobalAuCmds", { clear = true })

-- Trim trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function()
        local winpos = vim.fn.winsaveview()
        vim.cmd([[%substitute/\m\s\+$//e]])
        vim.fn.winrestview(winpos)
    end,
    group = global_group,
})


-------------------------------------------------------------------------------
-- Packages -------------------------------------------------------------------
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
set.rtp:prepend(lazypath)

require("lazy").setup({
    'tpope/vim-commentary',
    'tpope/vim-surround',
    'justinmk/vim-sneak',
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        priority = 100,
        config = function()
            require('catppuccin').setup({
                no_italic = true,
            })
            vim.cmd.colorscheme('catppuccin-frappe')
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        priority = 90,
        opts = {
            options = {
                icons_enabled = false,
                theme = 'auto',
                component_separators = '|',
                section_separators = '',
            },
        },
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "c",
                    "help",
                    "javascript",
                    "json",
                    "lua",
                    "markdown",
                    "python",
                    "rust",
                    "toml",
                    "vim",
                    "yaml",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
    'nvim-treesitter/playground',
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('telescope').setup({
                defaults = {
                    layout_strategy = 'vertical'
                }
            })
            local builtin = require('telescope.builtin')
            mapkey('n', '<leader><space>', builtin.find_files, { desc = 'Find files' })
            mapkey('n', '<leader>b', builtin.buffers, { desc = '[ ] Find existing buffers' })
            mapkey('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            mapkey('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            mapkey('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        end,
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        cond = vim.fn.executable('make') == 1,
        build = 'make',
        config = function()
            require('telescope').load_extension('fzf')
        end,
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        keys = {
            { "<leader>cf", "<cmd>Neotree filesystem left<cr>", desc = "Toggle NeoTree" },
        },
        config = function()
            vim.cmd('let g:neo_tree_remove_legacy_commands = 1')
            require('neo-tree').setup({
                close_if_last_window = true,
            })
        end,
    },
    {
        'ThePrimeagen/harpoon',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function()
            require('telescope').load_extension('harpoon')
            local mark = require('harpoon.mark')
            local ui = require('harpoon.ui')
            mapkey('n', "<leader>hm", mark.add_file, { desc = "Harpoon current file" })
            mapkey('n', "<leader>hh", ui.toggle_quick_menu, { desc = "Toggle harpoon quick menu" })
            mapkey('n', "<leader>j", function() ui.nav_file(1) end)
            mapkey('n', "<leader>k", function() ui.nav_file(2) end)
            mapkey('n', "<leader>l", function() ui.nav_file(3) end)
            mapkey('n', "<leader>;", function() ui.nav_file(4) end)
        end,
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            'neovim/nvim-lspconfig',
            'williamboman/mason-lspconfig.nvim',
            'williamboman/mason.nvim',
            -- Autocompletion
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
            'hrsh7th/nvim-cmp',
            'saadparwaiz1/cmp_luasnip',
            -- Snippets
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        },
        config = function()
            local lsp = require('lsp-zero')
            lsp.preset('recommended')
            lsp.nvim_workspace()
            lsp.setup()
            mapkey('n', '<leader>f', function()
                vim.lsp.buf.format()
            end)
        end,
    }
})
