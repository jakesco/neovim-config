-- ====================================
--    _       _ _     _
--   (_)_ __ (_) |_  | |_   _  __ _
--   | | '_ \| | __| | | | | |/ _` |
--   | | | | | | |_ _| | |_| | (_| |
--   |_|_| |_|_|\__(_)_|\__,_|\__,_|
--
-- ====================================
-- Inspired by https://github.com/nvim-lua/kickstart.nvim

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General Settings
-- vim.g.netrw_banner = 0
vim.cmd([[
set mouse=a
set number relativenumber
set completeopt=menu,menuone,noselect
set linebreak
set scrolloff=8
set sidescrolloff=8
set splitbelow splitright
set iskeyword+=-
set inccommand=nosplit
set incsearch
set ignorecase smartcase
set diffopt+=vertical
set shortmess+=c
set signcolumn=yes
set breakindent
set path+=**
set hidden
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set termguicolors
set background=dark
set cursorline
set nowrap
]])

-- Keymaps ---------------------------------------------------------------------------------------
keymap = vim.keymap.set
keymap('n', '<leader>ce', ':edit $MYVIMRC<cr>')
keymap('n', '<leader>cr', ':source $MYVIMRC<cr>:echo "init.lua reloaded"<cr>')
keymap('n', '<leader>c/', ':nohlsearch<cr> :echo "Search cleared."<cr>')
keymap('n', '<leader>cn', ':set relativenumber!<cr>')
keymap('n', '<leader>cs', ':setlocal spell! spelllang=en_us<cr>')
-- map('n', '<leader>cf', vim.cmd.Ex)
keymap('n', '<leader>r', ':!<up><cr>', { desc = 'Run last external program' })
keymap('n', '<leader>y', '"+y')
-- map('n', '<leader>p', '"+p')
keymap('v', '<leader>y', '"+y')
-- map('v', '<leader>p', '"+p')
keymap('n', '<leader>dd', '^D')
keymap('n', '<leader>\\', ':vsp<cr>')
keymap('n', '<leader>-', ':sp<cr>')
keymap('n', '<leader>*', ':%s/\\<<c-r><c-w>\\>//g<left><left>', { desc = 'Search & replace word under cursor' })
keymap('o', 'fun', ':<c-u>normal! 0f(hviw<cr>', { desc = 'Change function name' })


keymap('v', "J", ":m '>+1<CR>gv=gv")
keymap('v', "K", ":m '<-2<CR>gv=gv")

keymap('n', 'Y', 'yg$')
keymap('n', 'J', 'mzJ`z')
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'nzzzv')

keymap('x', '<leader>p', '"_dP')

keymap('n', 'Q', '<nop>')

-- vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

-- Abbreviations
vim.cmd('iabbrev @@d <C-r>=strftime("%Y-%m-%d")<cr>') -- insert current date

-- Trim trailing whitespace
local global_group = vim.api.nvim_create_augroup("GlobalAuCmds", { clear = true })
vim.cmd([[
function! TrimTrailingWhitespace() abort
  let l:view = winsaveview()
  keeppatterns %substitute/\m\s\+$//e
  call winrestview(l:view)
endfunction
]])

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = "TrimTrailingWhitespace",
    group = global_group,
})

-- Packages --------------------------------------------------------------------------------------
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.system({
        "git",
        "clone",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    vim.cmd('packadd packer.nvim')
end

-- stylua: ignore start
require('packer').startup(function(use)
    use {
        'wbthomason/packer.nvim',
        config = function()
            vim.keymap.set('n', '<leader>cpc', ':PackerCompile<cr>', { desc = 'Run [P]acker[C]ompile' })
            vim.keymap.set('n', '<leader>cps', ':PackerSync<cr>', { desc = 'Run [P]acker[S]ync' })
        end,
    }

    use 'tpope/vim-commentary'

    use 'tpope/vim-surround'

    use {
        'sainnhe/everforest',
        config = function()
            vim.g.everforest_background = 'medium'
            vim.g.everforest_better_performance = 1
            vim.cmd('colorscheme everforest')
        end,
    }

    use {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = false,
                    theme = 'auto',
                    component_separators = '|',
                    section_separators = '',
                },
            }
        end,
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "c", "lua", "rust", "vim", "help", "python", "javascript" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    }

    use 'nvim-treesitter/playground'

    use {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        },

        config = function()
            vim.cmd('let g:neo_tree_remove_legacy_commands = 1')
            vim.keymap.set('n', '<leader><space>', ':Neotree filesystem left<cr>')
            vim.keymap.set('n', '<leader>b', ':Neotree buffers float<cr>')
            vim.keymap.set('n', '<leader>gs', ':Neotree git_status float<cr>')
            require('neo-tree').setup({
                close_if_last_window = true,
            })
        end,
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            -- Snippet Collection (Optional)
            { 'rafamadriz/friendly-snippets' },
        },
        config = function()
            local lsp = require('lsp-zero')
            lsp.preset('recommended')
            lsp.setup()
            vim.keymap.set('n', '<leader>f', function()
                vim.lsp.buf.format()
            end)
        end,
    }

    if is_bootstrap then
        require('packer').sync()
    end
end)
-- stylua: ignore end

if is_bootstrap then
    print '=================================='
    print '    Plugins are being installed'
    print '    Wait until Packer completes,'
    print '       then restart nvim'
    print '=================================='
    return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | PackerCompile',
    group = packer_group,
    pattern = vim.fn.expand '$MYVIMRC',
})
