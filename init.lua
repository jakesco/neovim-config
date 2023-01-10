-- ====================================
--    _       _ _     _
--   (_)_ __ (_) |_  | |_   _  __ _
--   | | '_ \| | __| | | | | |/ _` |
--   | | | | | | |_ _| | |_| | (_| |
--   |_|_| |_|_|\__(_)_|\__,_|\__,_|
--
-- ====================================
-- Resources:
-- https://github.com/nanotee/nvim-lua-guide
-- https://github.com/nvim-lua/kickstart.nvim
-- https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ

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
vim.keymap.set('n', '<leader>ce', ':edit $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>cr', ':source $MYVIMRC<cr>:echo "init.lua reloaded"<cr>')
vim.keymap.set('n', '<leader>c/', ':nohlsearch<cr> :echo "Search cleared."<cr>')
vim.keymap.set('n', '<leader>cn', ':set relativenumber!<cr>')
vim.keymap.set('n', '<leader>cs', ':setlocal spell! spelllang=en_us<cr>')
-- vim.keymap.set('n', '<leader>cf', vim.cmd.Ex)
vim.keymap.set('n', '<leader>r', ':!<up><cr>', { desc = 'Run last external program' })
vim.keymap.set('n', '<leader>y', '"+y')
-- vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('v', '<leader>y', '"+y')
-- vim.keymap.set('v', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>dd', '^D')
vim.keymap.set('n', '<leader>\\', ':vsp<cr>')
vim.keymap.set('n', '<leader>-', ':sp<cr>')
vim.keymap.set('n', '<leader>*', ':%s/\\<<c-r><c-w>\\>//g<left><left>', { desc = 'Search & replace word under cursor' })
vim.keymap.set('o', 'fun', ':<c-u>normal! 0f(hviw<cr>', { desc = 'Change function name' })


vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv")
vim.keymap.set('v', "K", ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'Y', 'yg$')
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'nzzzv')

vim.keymap.set('x', '<leader>p', '"_dP')

vim.keymap.set('n', 'Q', '<nop>')

-- vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

-- Abbreviations
vim.cmd([[iabbrev @@d <C-r>=strftime("%Y-%m-%d")<cr>]]) -- insert current date

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
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    vim.cmd [[packadd packer.nvim]]
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
            vim.keymap.set('n', '<leader><space>', ':Neotree filesystem toggle left<cr>')
            vim.keymap.set('n', '<leader>b', ':Neotree buffers float<cr>')
            vim.keymap.set('n', '<leader>gs', ':Neotree git_status float<cr>')
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
