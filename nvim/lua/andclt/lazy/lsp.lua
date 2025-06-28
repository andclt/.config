---@diagnostic disable: undefined-global
local vim = vim

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},

	config = function()
		-- Add key mappings for LSP
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				local opts = { buffer = args.buf, silent = true }

				-- Go to definition
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				-- Go to declaration
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				-- Go to implementation
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				-- Go to type definition
				vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
				-- Show hover documentation
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				-- Show references
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				-- Show code actions
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				-- Rename symbol
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			end,
		})

		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})
		require("mason").setup()

		-- Ensure tools for debugging and development are installed
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- LSP servers
				"lua-language-server",
				"gopls",
				"rust-analyzer", -- Needed for rustaceanvim
				"ts_ls",
				"eslint_d",

				-- DAP tools
				"codelldb", -- For Rust debugging
				"delve", -- For Go debugging

				-- Formatters & linters
				"stylua",
				"rustfmt",
				"gofumpt",
				"goimports",
				"clang-format",
				"prettier",
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				-- "rust_analyzer", -- Removed as rustaceanvim handles Rust files
				"gopls",
				"ts_ls",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					-- Skip setting up rust_analyzer since rustaceanvim handles it
					if server_name ~= "rust_analyzer" then
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								format = {
									enable = true,
									-- Put format options here
									-- NOTE: the value should be STRING!!
									defaultConfig = {
										indent_style = "space",
										indent_size = "4",
									},
								},
							},
						},
					})
				end,

				["ts_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.ts_ls.setup({
						capabilities = capabilities,
						settings = {
							typescript = {
								format = {
									enable = true,
									defaultConfig = {
										indent_style = "space",
										indent_size = "4",
									},
								},
							},
							javascript = {
								format = {
									enable = true,
									defaultConfig = {
										indent_style = "space",
										indent_size = "4",
									},
								},
							},
						},
					})
				end,
			},
		})

		-- Configure sourcekit-lsp directly since it comes with Xcode
		require("lspconfig").sourcekit.setup({
			capabilities = capabilities,
			filetypes = { "swift" },
			cmd = { "sourcekit-lsp" },
			settings = {
				sourcekit = {
					diagnostics = {
						enabled = true,
					},
				},
			},
		})

		-- Set completeopt to have a better completion experience
		vim.o.completeopt = "menuone,noselect"

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = {
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.close(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Tab>"] = function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end,
				["<S-Tab>"] = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
				{ name = "path" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
