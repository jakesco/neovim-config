local mapkey = vim.keymap.set

mapkey({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
mapkey('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })
mapkey('n', '<leader>ve', ':edit $MYVIMRC<cr>', { desc = 'Edit init.lua' })
mapkey('n', '<leader>vn', ':set relativenumber!<cr>', { desc = 'Toggle relative line numbers' })
mapkey('n', '<leader>vs', ':setlocal spell! spelllang=en_us<cr>', { desc = 'Toggle spellcheck' })
mapkey('v', '<leader>vs', ':sort<cr>', { desc = 'Sort selection', silent = true })
mapkey('n', '<leader>vp', ':Lazy<cr>', { desc = 'Open Lazy' })
-- mapkey('n', '<leader>cf', vim.cmd.Ex, { desc = 'Open netrw' })
mapkey('x', '<leader>vv', '"_dP', { desc = 'Paste over selection without replacing buffer' })
mapkey('n', '<leader>vx', '<cmd>!chmod +x %<CR>', { desc = 'Set exec flag on file' })
mapkey('n', '<leader>vr', ':!<up><cr>', { desc = 'Run last external program' })
mapkey('n', '<leader>y', '"+y')
mapkey('n', '<leader>p', '"+p')
mapkey('v', '<leader>y', '"+y')
mapkey('v', '<leader>p', '"+p')
mapkey('n', '<leader>dd', '^D')
mapkey(
  'n',
  '<leader>*',
  ':%s/\\<<c-r><c-w>\\>//g<left><left>',
  { desc = 'Search & replace word under cursor' }
)
mapkey('o', 'fun', ':<c-u>normal! 0f(hviw<cr>', { desc = 'Change function name' })
mapkey('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move highlighted lines down' })
mapkey('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move highlighted lines up' })
mapkey('n', 'J', 'mzJ`z')
mapkey('n', '<C-d>', '<C-d>zz')
mapkey('n', '<C-u>', '<C-u>zz')
mapkey('n', 'n', 'nzz')
mapkey('n', 'N', 'nzz')
mapkey('n', 'Q', '<nop>')

-- Diagnostic keymaps
mapkey('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
mapkey('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
mapkey('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
mapkey('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Terminal Keymaps
mapkey('n', '<space>vt', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd('J')
  vim.api.nvim_win_set_height(0, 15)
end, { desc = 'Split Terminal' })
