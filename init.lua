-- =======================================================
--    _       _ _     _
--   (_)_ __ (_) |_  | |_   _  __ _
--   | | '_ \| | __| | | | | |/ _` |
--   | | | | | | |_ _| | |_| | (_| |
--   |_|_| |_|_|\__(_)_|\__,_|\__,_|
--
-- =======================================================
-- Inspired by https://github.com/nvim-lua/kickstart.nvim
-- za to toggle folding

--{{{ Lazy Plugin Manager Setup
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
--}}}

require('options')
require('keymaps')
require('autocommands')
require('abbreviations')
require('lazy').setup('plugins')

-- vim: fdm=marker ts=2 sts=2 sw=2 et
