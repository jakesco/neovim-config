return {
  'lewis6991/gitsigns.nvim',
  opts = {
    -- See `:help gitsigns.txt`
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')
      vim.keymap.set(
        'n',
        '<leader>cgp',
        gitsigns.prev_hunk,
        { buffer = bufnr, desc = '[G]it [P]revious Hunk' }
      )
      vim.keymap.set(
        'n',
        '<leader>cgn',
        gitsigns.next_hunk,
        { buffer = bufnr, desc = '[G]it [N]ext Hunk' }
      )
      vim.keymap.set(
        'n',
        '<leader>cgh',
        gitsigns.preview_hunk,
        { buffer = bufnr, desc = '[G]it preview [H]unk' }
      )
    end,
  },
}
