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
-- https://github.com/LunarVim/Neovim-from-scratch

local fn = vim.fn
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

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
set signcolumn=number
set breakindent 
set path+=** 
set hidden
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set termguicolors
set background=dark
]])

g.netrw_banner = 0

function map(mode, shortcut, command)
    vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
    map('n', shortcut, command)
end

function imap(shortcut, command)
    map('i', shortcut, command)
end

function vmap(shortcut, command)
    map('v', shortcut, command)
end

function omap(shortcut, command)
    map('o', shortcut, command)
end

-- Keymaps
nmap("<leader>ve", ":edit $MYVIMRC<cr>")
nmap("<leader>vr", ':source $MYVIMRC<cr>:echo "init.lua reloaded"<cr>')

nmap("<leader>n", ":set relativenumber!<cr>")
nmap("<leader>s", ":setlocal spell! spelllang=en_us<cr>")

nmap("<leader>y", '"+y')
nmap("<leader>p", '"+p')
vmap("<leader>y", '"+y')
vmap("<leader>p", '"+p')

nmap("<leader>d", '^D')
nmap("<leader>v", 'viw')
nmap("<leader>\\", ':vsp<cr>')
nmap("<leader>-", ':sp<cr>')
nmap("<leader>/", ':nohlsearch<cr> :echo "Search cleared."<cr>')
nmap("<leader>*", ':%s/\\<<c-r><c-w>\\>//g<left><left>')

omap("fun", ':<c-u>normal! 0f(hviw<cr>') -- change function name


-- " Abbreviation to insert current date
vim.cmd([[iabbrev @@d <C-r>=strftime("%Y-%m-%d")<cr>]])


-- " Add fzf to runtimepath
vim.cmd([[set runtimepath+=/usr/bin/fzf]])

-- Packages
-- References
-- https://alpha2phi.medium.com/neovim-for-beginners-plugin-management-59a8253a655f
-- https://alpha2phi.medium.com/learn-neovim-the-practical-way-8818fcf4830f

local plugin_install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(plugin_install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', plugin_install_path})
end

return require('packer').startup(function(use)
    use {
        'wbthomason/packer.nvim',
        config = function ()
            nmap("<leader>vps", ":PackerSync<cr>")
            nmap("<leader>vpc", ':PackerCompile<cr>:echo "Packages Compiled"<cr>')
        end,
    }

    use {
        'Mofiqul/vscode.nvim', 
        config = function ()
            vim.g.vscode_style = "dark"
            vim.g.vscode_transparent = 1
            vim.g.vscode_italic_comment = 1
            vim.cmd([[colorscheme vscode]])
        end
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function ()
            require('lualine').setup {
                options = {
                    icons_enabled = false,
                    theme = 'vscode',
                },
            }
        end,
    }

    use 'tpope/vim-commentary'

    use 'tpope/vim-surround'

    use {
        'junegunn/fzf.vim',
        config = function ()
            nmap("<leader>b", ":Buffers<cr>")
            nmap("<leader><Space>", ':Files<cr>')
            nmap("<leader>rr", ':BLines <c-r><c-w><cr>')
            nmap("<leader>rg", ':Rg ')
            nmap("<leader>gf", ':GFiles<cr>')
            nmap("<leader>gr", ':GFiles?<cr>')
        end,
    }

    use {
        'neovim/nvim-lspconfig',
        config = function ()
            -- Mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            local opts = { noremap=true, silent=true }
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
            
            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
            local on_attach = function(client, bufnr)
              -- Enable completion triggered by <c-x><c-o>
              vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
            
              -- Mappings.
              -- See `:help vim.lsp.*` for documentation on any of the below functions
              local bufopts = { noremap=true, silent=true, buffer=bufnr }
              vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
              vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
              vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
              vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
              vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, bufopts)
              vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
              vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
              vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
              vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
            end

            require('lspconfig').clangd.setup {
                on_attach = on_attach,
            }
            require'lspconfig'.sumneko_lua.setup {
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = {'vim'},
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }
        end,
    }

    if packer_bootstrap then
        require('packer').sync()
    end
end)
