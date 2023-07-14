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
        'samueljoli/hurl.nvim',
        config = function()
            require('hurl').setup({})
        end
    },
})
