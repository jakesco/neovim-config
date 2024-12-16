local global_group = vim.api.nvim_create_augroup('GlobalAuCmds', { clear = true })

-- Trim trailing whitespace
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = '*',
  group = global_group,
  callback = function()
    local winpos = vim.fn.winsaveview()
    vim.cmd([[%substitute/\m\s\+$//e]])
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.fn.winrestview(winpos) -- Lua LSP typing error for winpos for some reason
  end,
})

-- Stop auto commenting newlines with o
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = '*',
  group = global_group,
  callback = function()
    vim.opt.formatoptions:remove('o')
  end,
})

-- Highlight text yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  group = highlight_group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Terminal options
vim.api.nvim_create_autocmd('TermOpen', {
  group = global_group,
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})
