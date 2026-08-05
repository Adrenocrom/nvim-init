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
vim.o.swapfile = false

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
vim.keymap.set("n", "<leader>xx", function ()
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end, { silent = true})

vim.cmd([[
	vnoremap < <gv
	vnoremap > >gv
]])

--vim.cmd.colorscheme("vim")
vim.cmd.colorscheme("catppuccin")
vim.cmd.hi 'Comment gui=none'
vim.cmd.hi 'Normal guibg=NONE ctermbg=NONE'
vim.cmd.hi 'SignColumn guibg=NONE ctermbg=NONE'

vim.cmd.hi 'Pmenu guibg=NONE ctermbg=NONE'
vim.cmd.hi 'FoldColumn guibg=NONE ctermbg=NONE'

vim.pack.add({
	{ src = "https://github.com/Raimondi/delimitMate" },
	{ src = "https://github.com/mattn/emmet-vim" },
	{ src = "https://github.com/tpope/vim-surround" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/majutsushi/tagbar" },
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
	{ src = "https://github.com/Adrenocrom/sven.nvim" },
})

--- BEGINOFNEEDONPLUGIN ---
vim.keymap.set('n', '<leader>sf', function()
	local fzf_cmd = 'find . -type f -not -path "*/.git/*" -not -path "*/target/*" 2>/dev/null | fzf --style=full'
	local width  = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines   * 0.8)
	local win_cfg = {
		relative = 'editor',
		width    = width,
		height   = height,
		col      = math.floor((vim.o.columns - width)  / 2),
		row      = math.floor((vim.o.lines   - height) / 2),
		style    = 'minimal',
		border   = 'shadow',
	}

	local temp_buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(temp_buf, true, win_cfg)
	vim.cmd('terminal ' .. fzf_cmd)

	local function on_fzf_exit()
		local lines = vim.api.nvim_buf_get_lines(temp_buf, 0, -1, false)
		vim.api.nvim_buf_delete(temp_buf, { force = true })

		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end

		for i = #lines, 1, -1 do
			local line = lines[i]:gsub("^%s+", ""):gsub("%s+$", "")
			if line ~= "" and vim.fn.filereadable(line) == 1 then
				vim.schedule(function()
					vim.cmd('edit ' .. vim.fn.fnameescape(line))
				end)
				break
			end
		end
	end

	vim.api.nvim_create_autocmd('TermClose', {
		buffer = temp_buf,
		callback = function()
			vim.schedule(on_fzf_exit)
		end
	})

	vim.cmd('startinsert')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader><leader>', function()
	local width  = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines   * 0.8)
	local win_cfg = {
		relative = 'editor',
		width    = width,
		height   = height,
		col      = math.floor((vim.o.columns - width)  / 2),
		row      = math.floor((vim.o.lines   - height) / 2),
		style    = 'minimal',
		border   = 'shadow',
	}

	local bufnrs = vim.api.nvim_list_bufs()
	local buffer_lines = {}
	for _, bufnr in ipairs(bufnrs) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			local name = vim.api.nvim_buf_get_name(bufnr)
			if name ~= '' and vim.fn.filereadable(name) == 1 then
				--local display_name = #name > 100 and "…" .. name:sub(-99) or name
				--table.insert(buffer_lines, string.format("%d %s", bufnr, display_name))
				table.insert(buffer_lines, string.format("%d %s", bufnr, name))
			end
		end
	end

	-- Create a named pipe (FIFO) instead of a temp file.
	local fifo = vim.fn.tempname()
	vim.fn.system({ 'mkfifo', fifo })

	local temp_buf = vim.api.nvim_create_buf(false, true)
	vim.bo[temp_buf].bufhidden = 'wipe'

	local win = vim.api.nvim_open_win(temp_buf, true, win_cfg)

	local job_id = vim.fn.termopen(string.format('fzf --style=full < %s', vim.fn.fnameescape(fifo)), {
		on_exit = function(_, _, _)
			vim.schedule(function()
				local lines = vim.api.nvim_buf_get_lines(temp_buf, 0, -1, false)

				if vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_close(win, true)
				end

				-- Clean up FIFO.
				vim.fn.delete(fifo)

				for i = #lines, 1, -1 do
					local line = lines[i]:gsub("^%s+", ""):gsub("%s+$", "")
					local buf_num = line:match("(%d+)")
					if buf_num then
						vim.cmd('buffer ' .. buf_num)
						break
					end
				end
			end)
		end,
	})

	-- Defer writing so fzf has time to open the FIFO for reading.
	vim.defer_fn(function()
		local f = io.open(fifo, "w")
		if f then
			f:write(table.concat(buffer_lines, "\n") .. "\n")
			f:close()
		end
	end, 50)

	vim.cmd('startinsert')
end, { noremap = true, silent = true })
--- ENDOFNEEDONPLUGIN ---

require('sven').setup()
vim.keymap.set('n', '<leader>a', vim.cmd.Sven, { desc = ' Ai agent' })
vim.keymap.set('v', '<leader>a', ":'<,'>Sven<cr>", { desc = ' Ai agent' })

vim.api.nvim_set_keymap("n", "<leader>gb", ":Git blame<CR>", { desc = "[G] Git [B]lame"})
vim.api.nvim_set_keymap("n", "<F8>", ":Tagbar<CR>", {})

vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 10
vim.g.netrw_browse_split = 0
vim.g.netrw_altfile = 1
vim.keymap.set("n", "<leader>t", ":Lexplore<CR>", { desc = "[t]oggle nvimtree" })

require('minuet').setup {
	cmp = {
		enable_auto_complete = false,
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
				--top_p = 0.1,
				top_k = 1,
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
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client ~= nil and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
		end
		vim.cmd("set completeopt+=noselect")

		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = event.buf, desc = 'LSP: [G]oto [D]efinition' })
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = event.buf, desc = 'LSP: [G]oto [R]eferences' })
		vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = event.buf, desc = 'LSP: [G]oto [I]mplementation' })
		vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = event.buf, desc = 'LSP: Type [D]efinition' })
		vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, { buffer = event.buf, desc = 'LSP: [D]ocument [S]ymbols' })
		vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, { buffer = event.buf, desc = 'LSP: [W]orkspace [S]ymbols' })
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = event.buf, desc = 'LSP: [R]e[n]ame' })
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = event.buf, desc = 'LSP: [C]ode [A]ction' })
		vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, { buffer = event.buf, desc = 'LSP: Hover Documentation' })
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = event.buf, desc = 'LSP: [G]oto [D]eclaration' })
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
