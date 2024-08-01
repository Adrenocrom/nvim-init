local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.mouse = 'a'
vim.o.incsearch = true
vim.o.hlsearch = true
vim.wo.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true

vim.keymap.set('i', '<C-l>', 'LOG.info("\\033[32m" + "" + "\\033[0m");' .. string.rep('<left>', 15), {})

local function insertFullPath()
  local filepath = vim.fn.expand('%')
  vim.fn.setreg('+', filepath) -- write to clippoard
end

vim.keymap.set('n', '<C-p>', insertFullPath, { noremap = true, silent = true })

vim.cmd([[
	vnoremap < <gv
	vnoremap > >gv
]])

vim.cmd.colorscheme("vim")
vim.cmd.hi 'Comment gui=none'
vim.cmd.hi 'Normal guibg=NONE ctermbg=NONE'
vim.cmd.hi 'SignColumn guibg=NONE ctermbg=NONE'

vim.cmd.hi 'Pmenu guibg=NONE ctermbg=NONE'

require("lazy").setup({
	"Raimondi/delimitMate",
	"mattn/emmet-vim",
	"tpope/vim-surround", {
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<C-f>', builtin.find_files, {})
			vim.keymap.set('n', '<C-g>', builtin.live_grep, {})
		end
	}, {
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end
	}, {
		"tpope/vim-fugitive",
		config = function()
			vim.api.nvim_set_keymap("n", "<C-b>", ":Git blame<CR>", {})
		end
	},
	"tpope/vim-dadbod",
	"kristijanhusak/vim-dadbod-ui", {
		"majutsushi/tagbar",
		config = function()
			vim.api.nvim_set_keymap("n", "<F8>", ":Tagbar<CR>", {})
		end
	},
	"preservim/nerdtree",
	"nvim-tree/nvim-web-devicons", {
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				renderer = {
					group_empty = true
				}
			})

			vim.cmd.NvimTreeOpen()
		end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function ()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "java" },
				sync_install = false,
				auto_install = true,
				ignore_install = { },
				highlight = {
					enable = true,
					disable = { "xml", "cld" }
				},
				indent = { enable = true },
				modules = {}
			})
		end
	},
	{
		"mbbill/undotree",
		config = function ()
			vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
		end
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},
	{ -- LSP Configuration & Plugins
    	'neovim/nvim-lspconfig',
    	dependencies = {
      		-- Automatically install LSPs and related tools to stdpath for Neovim
      		{ 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      		'williamboman/mason-lspconfig.nvim',
      		'WhoIsSethDaniel/mason-tool-installer.nvim',
      		'nvim-java/nvim-java',

      		-- Useful status updates for LSP.
      		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      		{ 'j-hui/fidget.nvim', opts = {} },

      		-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      		-- used for completion, annotations and signatures of Neovim apis
      		{ 'folke/neodev.nvim', opts = {} },
    	},
    	config = function()
			vim.api.nvim_create_autocmd('LspAttach', {

				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
					end

					map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
					map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
					map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
					map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
					map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
					map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
					map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
					map('K', vim.lsp.buf.hover, 'Hover Documentation')
					map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

				end
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = 'Replace',
							},
						},
					},
				},
			}

      		require('mason').setup()
			local ensure_installed = vim.tbl_keys(servers or { })
      		require('mason-tool-installer').setup { ensure_installed = ensure_installed }

			require('mason-lspconfig').setup {
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}

						server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
						require('lspconfig')[server_name].setup(server)
					end,
					jdtls = function()
						require('java').setup { }
						require('lspconfig').jdtls.setup({
							settings = {
								java = {
									configuration = {
										runtimes = {
											{
												name = "current",
												path = "~/.sdkman/candidates/java/current",
												default = true
											}
										}
									}
								}
							}
						})
					end,
				},
			}
		end
	},
	{ -- Autocompletion
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{
				'L3MON4D3/LuaSnip',
				build = (function()
					if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
						return
					end
					return 'make install_jsregexp'
				end)(),
				dependencies = { },
			},
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-buffer'
		},
		config = function()
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			luasnip.config.setup {}

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered()
				},
				completion = { completeopt = 'menu,menuone,noinsert' },
				mapping = cmp.mapping.preset.insert {
					-- If you prefer more traditional completion keymaps,
					-- you can uncomment the following lines
					['<CR>'] = cmp.mapping.confirm { select = true },
					['<Tab>'] = cmp.mapping.select_next_item(),
					['<S-Tab>'] = cmp.mapping.select_prev_item(),
					['<C-Space>'] = cmp.mapping.complete {},
					['<C-L>'] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { 'i', 's' }),
					['<C-h>'] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { 'i', 's' }),
				},
				sources = {
					{
						name = 'nvim_lsp',
						group_index = 1
					},
					{
						name = 'luasnip',
						group_index = 1
					},
					{
						name = 'buffer',
						group_index = 2,
						option = {
							get_bufnrs = function ()
								return vim.api.nvim_list_bufs()
							end
						}
					},
					{
						name = 'path',
						group_index = 2
					}
				},
			}
		end,
	},
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			'rcarriga/nvim-dap-ui',
			'nvim-neotest/nvim-nio',
			'williamboman/mason.nvim',
			'jay-babu/mason-nvim-dap.nvim',
  		},
		config = function()
			local dap = require 'dap'
			local dapui = require 'dapui'
			require('mason-nvim-dap').setup {
				automatic_installation = true,
				handlers = {},
				ensure_installed = {
					'delve',
				},
			}

			vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
			vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
			vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
			vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
			vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
			vim.keymap.set('n', '<leader>B', function()
				dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
			end, { desc = 'Debug: Set Breakpoint' })

			dapui.setup {
				icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
				controls = {
					icons = {
						pause = '⏸',
						play = '▶',
						terminate = '⏹',
						disconnect = '⏏',
					},
				},
			}

			vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
			vim.fn.sign_define('DapBreakpoint', { text = '⬤', texthl = '', linehl = '', numhl = '' })
			vim.fn.sign_define('DapStopped', { text = '->', texthl = '', linehl = '', numhl = '' })
			dap.listeners.after.event_initialized['dapui_config'] = dapui.open
			dap.listeners.before.event_terminated['dapui_config'] = dapui.close
			dap.listeners.before.event_exited['dapui_config'] = dapui.close
		end,
	}
})
