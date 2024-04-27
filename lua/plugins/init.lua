local mapkey = vim.keymap.set
return {
  --{{{ Telescope
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('telescope').setup({
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require('telescope.builtin')
      -- See `:help telescope.builtin`
      mapkey('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      mapkey('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      mapkey('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      mapkey('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      mapkey('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      mapkey('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      mapkey('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      mapkey('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      mapkey(
        'n',
        '<leader>s.',
        builtin.oldfiles,
        { desc = '[S]earch Recent Files ("." for repeat)' }
      )
      mapkey('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      mapkey('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = '[/] Fuzzily search in current buffer' })
      mapkey('n', '<leader>s/', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end, { desc = '[S]earch [/] in Open Files' })
      mapkey('n', '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  --}}}
  --{{{ Todo Comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  --}}}
  --{{{ Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  --}}}
  --{{{ Comment.nvim
  { 'numToStr/Comment.nvim', opts = {} },
  --}}}
  --{{{ Vim Surround
  'tpope/vim-surround',
  --}}}
  --{{{ Vim Sleuth
  'tpope/vim-sleuth',
  --}}}
  --{{{ Which Key
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').register({
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      })
    end,
  },
  --}}}
  --{{{ Zen Mode
  {
    'folke/zen-mode.nvim',
    opts = {},
    keys = {
      { '<leader>vz', '<cmd>ZenMode<cr>', desc = 'Toggle Zen Mode' },
    },
  },
}
