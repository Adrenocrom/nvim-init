local config = {
	name = "jdtls",
	cmd = {
		vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls")
	},
	root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
	init_options = {
		bundles = {
			vim.fn.glob( vim.fn.expand("~/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-0.53.2.jar"), 1)
		}
	},
}

local dap = require('dap')
dap.configurations.java = {
	{
		type = 'java';
		request = 'attach';
		name = "Debug (Attach) - Remote localhost";
		hostName = "localhost";
		port = 9981;
	},
	{
		type = 'java';
		request = 'attach';
		name = "Debug (Attach) - Remote";
		hostName = "10.10.2.91";
		port = 9981;
	},
}

require('jdtls').start_or_attach(config)
