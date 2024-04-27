local set = vim.opt
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- vim.g.netrw_banner = 0

set.background = 'dark'
set.breakindent = true
set.completeopt:append({ 'menu', 'menuone', 'noselect' })
set.cursorline = true
set.diffopt:append('vertical')
set.expandtab = true
set.hidden = true
set.hlsearch = true
set.ignorecase = true
set.inccommand = 'split'
set.incsearch = true
set.linebreak = true
set.list = true
set.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
set.mouse = 'a'
set.number = true
set.path:append('**')
set.relativenumber = true
set.scrolloff = 8
set.shiftwidth = 4
set.shortmess:append('c')
set.showmode = false
set.sidescrolloff = 8
set.signcolumn = 'yes'
set.smartcase = true
set.softtabstop = 4
set.splitbelow = true
set.splitright = true
set.tabstop = 4
set.termguicolors = true
set.timeoutlen = 300
set.undofile = true
set.updatetime = 250
set.wrap = false
