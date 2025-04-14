---@diagnostic disable: undefined-global
local vim = vim

return {
    {
        'mrcjkb/rustaceanvim',
        version = '^5',
        ft = "rust",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local mason_registry = require('mason-registry')
            local codelldb = mason_registry.get_package('codelldb')
            local extension_path = codelldb:get_install_path() .. "/extension"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path.. "lldb/lib/liblldb.dylib"
            local cfg = require('rustaceanvim.config')

            -- Setup Rustaceanvim with LSP and DAP
            vim.g.rustaceanvim = {
                dap = {
                    adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
                },
                -- LSP configuration
                server = {
                    on_attach = function(client, bufnr)
                        -- Enable completion triggered by <c-x><c-o>
                        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
                        
                        -- Buffer local mappings
                        local opts = { buffer = bufnr }
                        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    end,
                    settings = {
                        -- rust-analyzer settings
                        ['rust-analyzer'] = {
                            checkOnSave = {
                                command = "clippy",
                            },
                            inlayHints = {
                                bindingModeHints = { enable = true },
                                chainingHints = { enable = true },
                                parameterHints = { enable = true },
                                typeHints = { enable = true },
                            },
                        }
                    }
                },
            }
        end,
    },
    {
        'rust-lang/rust.vim',
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end,
    },
    {
        'saecki/crates.nvim',
        ft = {"toml"},
        config = function()
            require("crates").setup {
                completion = {
                    cmp = {
                        enabled = true
                    },
                },
            }
            require('cmp').setup.buffer({
                sources = { { name = "crates" }}
            })
        end,
    },
} 