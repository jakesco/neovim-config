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
set.timeoutlen = 300
set.undofile = true
set.updatetime = 250
set.wrap = false


-------------------------------------------------------------------------------
-- Keymaps --------------------------------------------------------------------
-------------------------------------------------------------------------------
local mapkey = vim.keymap.set
mapkey({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
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
mapkey('n', '<leader>cr', ':!<up><cr>', { desc = 'Run last external program' })
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

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
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
  'tpope/vim-sleuth',
  'github/copilot.vim',
  {
    'Mofiqul/adwaita.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('adwaita')
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
  { 'folke/which-key.nvim', opts = {} },
  {
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
        mapkey('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        mapkey('n', '<leader>gn', require('gitsigns').next_hunk,
          { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        mapkey('n', '<leader>ph', require('gitsigns').preview_hunk,
          { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
          file_ignore_patterns = {
            ".git",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
      local builtin = require('telescope.builtin')
      -- See `:help telescope.builtin`
      mapkey('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
      mapkey('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      mapkey('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })
      mapkey('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
      mapkey('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      mapkey('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      mapkey('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      mapkey('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      mapkey('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    end
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      pcall(require('telescope').load_extension, 'fzf')
    end,
  },
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
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
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },
})

-- Stuff copied from kickstart
-- TODO: clean this up

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp','lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'zig' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- gopls = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  clangd = {},
  pyright = {},
  rust_analyzer = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  zls = {},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- vim: ts=2 sts=2 sw=2 et
