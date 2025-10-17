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
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true
vim.o.relativenumber = true;
vim.o.mouse = 'a'
vim.o.incsearch = true
vim.o.hlsearch = true
vim.wo.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true

vim.keymap.set('n', '<leader>lar', 'aLOG.info("\\033[31m" +  + "\\033[0m");' .. string.rep('<left>', 14), { desc = "Insert LOG red"})
vim.keymap.set('n', '<leader>lag', 'aLOG.info("\\033[32m" +  + "\\033[0m");' .. string.rep('<left>', 14), { desc = "Insert LOG green"})
vim.keymap.set('n', '<leader>lay', 'aLOG.info("\\033[33m" +  + "\\033[0m");' .. string.rep('<left>', 14), { desc = "Insert LOG yellow"})
vim.keymap.set('n', '<leader>lir', 'iLOG.info("\\033[31m" +  + "\\033[0m");' .. string.rep('<left>', 14), { desc = "Insert LOG red"})
vim.keymap.set('n', '<leader>lig', 'iLOG.info("\\033[32m" +  + "\\033[0m");' .. string.rep('<left>', 14), { desc = "Insert LOG green"})
vim.keymap.set('n', '<leader>liy', 'iLOG.info("\\033[33m" +  + "\\033[0m");' .. string.rep('<left>', 14), { desc = "Insert LOG yellow"})

vim.keymap.set('n', '<leader>n', ':cnext<CR>', { desc = "Quickfix next"});
vim.keymap.set('n', '<leader>p', ':cprevious<CR>', { desc = "Quickfix previous"});

--learn vim motions
vim.api.nvim_set_keymap('', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<Right>', '<Nop>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i', '<Up>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Down>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Left>', '<Nop>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Right>', '<Nop>', { noremap = true, silent = true })

vim.diagnostic.config({ virtual_text = true })

local sessionpath = vim.fn.getcwd() .. '/Session.vim'
local function storeSession()
	vim.cmd.DapTerminate()
	require("dapui").close();
	vim.cmd.NvimTreeClose()
	vim.cmd.mksession { args = { sessionpath }, bang = true }
	vim.cmd.qa()
end

vim.keymap.set('n', '<leader>qa', storeSession, { noremap = true, silent = true, desc = "[Q] Quit [A] All and store Session" })

vim.cmd([[
	vnoremap < <gv
	vnoremap > >gv
]])

vim.cmd.colorscheme("vim")
vim.cmd.hi 'Comment gui=none'
vim.cmd.hi 'Normal guibg=NONE ctermbg=NONE'
vim.cmd.hi 'SignColumn guibg=NONE ctermbg=NONE'

vim.cmd.hi 'Pmenu guibg=NONE ctermbg=NONE'
--vim.cmd.hi 'Folded guibg=NONE ctermbg=NONE'
vim.cmd.hi 'FoldColumn guibg=NONE ctermbg=NONE'
--vim.cmd.hi 'Identifier guifg=#ff88ff'
--vim.cmd.hi 'Directory guifg=#ff88ff'

require("lazy").setup({
	ui = {
		border = "single"
	},
	spec = {
		"Raimondi/delimitMate",
		"mattn/emmet-vim",
		"tpope/vim-surround", {
			"nvim-telescope/telescope.nvim",
			event = 'VimEnter',
			version = "*",
			dependencies = {
				'nvim-lua/plenary.nvim',
				{
					'nvim-telescope/telescope-fzf-native.nvim',
					build = 'make',

					cond = function()
						return vim.fn.executable 'make' == 1
					end,
				},
				{ 'nvim-telescope/telescope-ui-select.nvim' },
			},
			config = function()
				require('telescope').setup {
					defaults = {
						--prompt_prefix = " ",
						--selection_caret = " ",
						path_display = { "smart" },
						dynamic_preview_title = true,
						sorting_strategy = "ascending",
						layout_strategy = "vertical",
						layout_config = {
							prompt_position = "bottom",
							height = 0.95,
						},
					},
					extensions = {
						require("telescope.themes").get_dropdown()
					}
				}

				pcall(require('telescope').load_extension, 'fzf')
				pcall(require('telescope').load_extension, 'ui-select')

				local builtin = require('telescope.builtin')
				vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S] Find [H]elp' })
				vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S] Find [K]eymaps' })
				vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S] Find [F]iles' })
				vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S] Find [S]elect Telescope' })
				vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S] Find current [W]ord' })
				vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S] Find by [G]rep' })
				vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S] Find [D]iagnostics' })
				vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S] Find [R]esume' })
				vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S] Find Recent Files ("." for repeat)' })
				vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
			end
		},
		{
			"folke/which-key.nvim",
			dependencies = {
				'echasnovski/mini.icons',
			},
			event = "VeryLazy",
			keys = {{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)"
			}}
		},
		{
			"tpope/vim-fugitive",
			config = function()
				vim.api.nvim_set_keymap("n", "<leader>gb", ":Git blame<CR>", { desc = "[G] Git [B]lame"})
			end
		},
		"tpope/vim-dadbod",
		"kristijanhusak/vim-dadbod-ui", {
			"majutsushi/tagbar",
			config = function()
				vim.api.nvim_set_keymap("n", "<F8>", ":Tagbar<CR>", {})
			end
		},
		"nvim-tree/nvim-web-devicons", {
			"nvim-tree/nvim-tree.lua",
			config = function()
				require("nvim-tree").setup({
					update_focused_file = {
						enable = true
					},
					renderer = {
						group_empty = true
					}
				})

				vim.keymap.set("n", "<leader>t", vim.cmd.NvimTreeToggle, { desc = "[t]oggle nvimtree" })
				vim.keymap.set("n", "<leader>tr", vim.cmd.NvimTreeRefresh, { desc = "[t]ree [r]refresn nvimtree" })
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
			"David-Kunz/gen.nvim",
			config = function ()
				local model_name = "gpt-oss:20b";
				require('gen').setup({
					model = model_name,
					display_mode = "vertical-split",
					show_prompt = true,
					show_model = true,
					no_auto_close = true
				})

				require('gen').prompts['Fix_Code'] = {
					prompt = "Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
					replace = true,
					extract = "```$filetype\n(.-)```"
				}

				require('gen').prompts['Shorter_Code'] = {
					prompt = "Rewrite the code as short as possible. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
					replace = true,
					extract = "```$filetype\n(.-)```"
				}

				vim.keymap.set('n', '<leader>a', vim.cmd.Gen, { desc = ' Ai agent' })
				vim.keymap.set('v', '<leader>a', ":'<,'>Gen<cr>", { desc = ' Ai agent' })
				vim.keymap.set('n', '<leader>cm', require('gen').select_model, { desc = ' Ai change model' })
			end
		},
		{
			"milanglacier/minuet-ai.nvim",
			config = function()
				require('minuet').setup {
					cmp = {
						enable_auto_complete = true,
					},
					blink = {
						enable_auto_complete = false,
					},
					provider = 'openai_fim_compatible',
					n_completions = 1,
					context_window = 512,
					provider_options = {
						openai_fim_compatible = {
							api_key = 'TERM',
							name = 'Ollama',
							end_point = 'http://localhost:11434/v1/completions',
							model = 'qwen2.5-coder:1.5b',
							keep_alive = -1,
							optional = {
								max_tokens = 2048,
								top_p = 0.1,
								top_k = 100,
							},
						},
					},
					virtualtext = {
						auto_trigger_ft = { "*" },
						keymap = {
							accept = '<A-A>',
							accept_line = '<A-a>',
							accept_n_lines = '<A-z>',
							prev = '<A-[>',
							next = '<A-]>',
							dismiss = '<A-e>',
						},
						show_on_completion_menu = false,
					},
				}
			end,
			dependencies = {
				"nvim-lua/plenary.nvim"
			}
		},
		{
			"mbbill/undotree",
			config = function ()
				vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "UndotreeToggle" })
			end
		},
		{
			"lewis6991/gitsigns.nvim",
			config = function ()
				vim.cmd.hi "GitSignsAdd guifg='#00ff00'"
				vim.cmd.hi "GitSignsDelete guifg='#ff0000'"
				require("gitsigns").setup({
					signs = {
						add = { text = '+' },
						change = { text = '~' },
						delete = { text = '-' },
						topdelete = { text = '‾' },
						changedelete = { text = '~' },
					}
				})

			end
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"mason-org/mason.nvim",
				"mason-org/mason-lspconfig.nvim",
				"mfussenegger/nvim-jdtls"
			},

			config = function()
				vim.diagnostic.config({
					signs = {
						text = {
							[vim.diagnostic.severity.ERROR] = '',
							[vim.diagnostic.severity.WARN] = '',
							[vim.diagnostic.severity.INFO] = '',
							[vim.diagnostic.severity.HINT] = '',
						}
					}
				})

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
						map('<leader>k', vim.lsp.buf.hover, 'Hover Documentation')
						map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

					end
				})

				require('mason').setup({
					ui = {
						border = "single",
					}
				})

				require('mason-lspconfig').setup()
			end
		},
		{
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
			"folke/trouble.nvim",
			opts = {},
			cmd = "Trouble",
			keys = {
				{
					"<leader>xx",
					"<cmd>Trouble diagnostics toggle<cr>",
					desc = "Diagnostics (Trouble)",
				},
				{
					"<leader>xX",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "Buffer Diagnostics (Trouble)",
				},
				{
					"<leader>cs",
					"<cmd>Trouble symbols toggle focus=false<cr>",
					desc = "Symbols (Trouble)",
				},
				{
					"<leader>cl",
					"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
					desc = "LSP Definitions / references / ... (Trouble)",
				},
				{
					"<leader>xL",
					"<cmd>Trouble loclist toggle<cr>",
					desc = "Location List (Trouble)",
				},
				{
					"<leader>xQ",
					"<cmd>Trouble qflist toggle<cr>",
					desc = "Quickfix List (Trouble)",
				},
			},
		},
		{
			'mfussenegger/nvim-dap',
			dependencies = {
				'rcarriga/nvim-dap-ui',
				'nvim-neotest/nvim-nio',
			},
			config = function()
				local dap = require 'dap'
				local dapui = require 'dapui'

				vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
				vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
				vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
				vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
				vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
				vim.keymap.set('n', '<leader>B', function()
					dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
				end, { desc = 'Debug: Set Breakpoint' })

				dapui.setup({
					controls = {
						element = "repl",
						enabled = true,
						icons = {
							pause = '⏸',
							play = '▶',
							terminate = '⏹',
							disconnect = '⏏',
							run_last = "",
							step_back = "",
							step_into = "",
							step_out = "",
							step_over = "",
						}
					},
					element_mappings = {},
					expand_lines = true,
					floating = {
						border = "single",
						mappings = {
							close = { "q", "<Esc>" }
						}
					},
					force_buffers = true,
					icons = {
						collapsed = "",
						current_frame = "",
						expanded = "",
					},
					layouts = { {
						elements = { {
							id = "stacks",
							size = 0.2
						}, {
								id = "breakpoints",
								size = 0.1
							}, {
								id = "scopes",
								size = 0.6
							}, {
								id = "watches",
								size = 0.1
							} },
						position = "right",
						size = 40
					}, {
							elements = { {
								id = "console",
								size = 0.5
							}, {
									id = "repl",
									size = 0.5
								} },
							position = "bottom",
							size = 2
						} },
					mappings = {
						edit = "e",
						expand = { "<CR>", "<2-LeftMouse>" },
						open = "o",
						remove = "d",
						repl = "r",
						toggle = "t"
					},
					render = {
						indent = 1,
						max_value_lines = 100
					}
				})

				vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#ff0000' })
				vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })
				vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#00ff00', bg = '#31353f' })

				vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
				vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
				vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='', numhl= 'DapBreakpoint' })
				vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='', numhl= 'DapLogPoint' })
				vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

				dap.listeners.after.event_initialized['dapui_config'] = dapui.open
				dap.listeners.before.event_terminated['dapui_config'] = dapui.close
				dap.listeners.before.event_exited['dapui_config'] = dapui.close
			end,
		},
	}
})
