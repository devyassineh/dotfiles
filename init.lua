vim.g.mapleader = ' ' 
vim.g.maplocalleader = ' ' 
vim.o.timeoutlen = 1000
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	print('Installing lazy.nvim....')
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
	print('Done.')
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ 'rose-pine/neovim', name = 'rose-pine' },
	{
		'stevearc/oil.nvim',
		config = function(_, opts)
			require("oil").setup(opts)
			vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>")
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({})
			vim.keymap.set("n", "<leader>f", "<cmd>lua require('fzf-lua').files()<CR>")
			vim.keymap.set("n", "<leader>b", "<cmd>lua require('fzf-lua').buffers()<CR>")
		end
	},
	{ 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
	{'tpope/vim-sleuth' },
	{
		'williamboman/mason.nvim',
		dependencies = {
			'williamboman/mason-lspconfig.nvim',
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-lspconfig").setup_handlers {
				function (server_name)
					require("lspconfig")[server_name].setup {}
				end,
			}
		end
	},
	{
		'neovim/nvim-lspconfig',
		config = function()
			local lspconfig = require('lspconfig')
			local custom_attach = function(client, bufnr)
				print('Lsp Attached.')
				local opts = { buffer = bufnr }
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
				vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
				vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
				vim.keymap.set({ 'i', 's' }, '<C-s>', vim.lsp.buf.signature_help, opts)
				vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
				vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
				vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
			end
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
				auto_install = true,
				highlight = {enable = true,},
				fold = { enable = true },
			})
		end,
	},
})

-- General
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.cmd[[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]]

-- Design
vim.cmd[[colorscheme rose-pine]]
vim.o.background = dark
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.laststatus = 0
vim.o.wrap = true
vim.o.number = true
vim.o.relativenumber = true
vim.api.nvim_set_hl(0, "WinSeparator", {fg='NvimDarkGrey2'})
vim.o.splitright = true

-- Key mapping
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', 'gp', '`[v`]')        -- select last modification
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<leader>w', '<C-w>')

-- Debugging
vim.cmd [[ set errorformat ='']]
vim.cmd [[packadd termdebug]]
vim.cmd [[let g:termdebugger="gdb"]]
vim.cmd [[autocmd FileType rust let g:termdebugger="rust-gdb"]]

-- Folding
vim.o.foldmethod = 'expr'
vim.o.foldtext = 'v:lua.vim.treesitter.foldtext()'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldenable = false
vim.o.fdo = ''

-- Spellcheck
vim.o.spelllang = "en_us"
vim.o.spell = true
