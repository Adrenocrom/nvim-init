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

vim.cmd([[
	vnoremap < <gv
	vnoremap > >gv
]])

vim.cmd.colorscheme("vim")
vim.cmd.hi 'Comment gui=none'
vim.cmd.hi 'Normal guibg=NONE ctermbg=NONE'
vim.cmd.hi 'SignColumn guibg=NONE ctermbg=NONE'

vim.cmd.hi 'Pmenu guibg=NONE ctermbg=NONE'
vim.cmd.hi 'FoldColumn guibg=NONE ctermbg=NONE'

local hooks = function(ev)
	local name, kind = ev.data.spec.name, ev.data.kind
	print(name)
	if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
		vim.system({ 'make' }, { cwd = ev.data.path })
	end
	if name == 'LuaSnip' and (kind == 'install' or kind == 'update') then
		vim.system({ 'make install_jsregexp' }, { cwd = ev.data.path })
	end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })
vim.pack.add({
	{ src = "https://github.com/Raimondi/delimitMate" },
	{ src = "https://github.com/mattn/emmet-vim" },
	{ src = "https://github.com/tpope/vim-surround" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
	{ src = "https://github.com/echasnovski/mini.icons" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/tpope/vim-dadbod" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-ui" },
	{ src = "https://github.com/majutsushi/tagbar" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/hrsh7th/cmp-buffer" },
	{ src = "https://github.com/sudo-tee/opencode.nvim" },
	{ src = "https://github.com/David-Kunz/gen.nvim" },
	{ src = "https://github.com/milanglacier/minuet-ai.nvim" },
	{ src = "https://github.com/mbbill/undotree" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/mfussenegger/nvim-jdtls" },
})

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


vim.api.nvim_set_keymap("n", "<leader>gb", ":Git blame<CR>", { desc = "[G] Git [B]lame"})
vim.api.nvim_set_keymap("n", "<F8>", ":Tagbar<CR>", {})

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

local cmp = require("cmp")
local luasnip = require 'luasnip'
luasnip.config.setup {}

cmp.setup {
	nippet = {
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

require("opencode").setup({
	ui = {
		position = "left",
	},
	context = {
		enabled = true,
		cursor_data = {
			enabled = true,
			context_lines = 5,
		},
		diagnostics = {
			info = false,
			warn = true,
			error = true,
			only_closest = false,
		},
		current_file = {
			enabled = true,
			show_full_path = true,
		},
		files = {
			enabled = true,
			show_full_path = true,
		},
		selection = {
			enabled = true,
		},
		buffer = {
			enabled = true,
		},
		git_diff = {
			enabled = true,
		},
	},
})

require('gen').setup({
	model = "gpt-oss:20b",
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

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "UndotreeToggle" })

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

require("trouble").setup({})
vim.keymap.set('n', '<leader>xx', "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set('n', "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set('n', "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set('n', "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set('n', "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set('n', "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
