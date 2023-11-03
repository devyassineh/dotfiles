-- Leader key settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.timeoutlen = 1000

-- Plugin Manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- Auto-install lazy.nvim if not present
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

-- Plugins
require("lazy").setup({
	-- UI
	{
		'Mofiqul/vscode.nvim',
		priority = 1000,
		config = function()
		  vim.cmd.colorscheme 'vscode'
		  vim.o.background = 'dark'
		end,
	},
	{
		'nvim-lualine/lualine.nvim',
		opts = {
		  options = {
			icons_enabled = false,
			component_separators = '|',
			section_separators = '',
			theme = 'vscode',
		  },
		},
	},
	{ 
		--'folke/which-key.nvim',  
		-- config = function()
		-- 	require('which-key').register {
		-- 		['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
		-- 	}
		-- end
	},

	-- Editor
	{ 'numToStr/Comment.nvim', opts = {} },
	{ 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
	{ 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

	-- Fuzzy Find
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.3',
		dependencies = {'nvim-lua/plenary.nvim'},
		config = function()
		  require('telescope').setup({}) 
		end,
		keys = {
			{"<leader><leader>", "<cmd>Telescope buffers<CR>", "n", desc="Find Open Buffers"},
			{"<leader>?", "<cmd>Telescope oldfiles<CR>", "n", desc="Find Old Files"},
			{"<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", "n",desc = "Find Current Buffer" },
			{"<leader>f","<cmd>Telescope find_files<CR>","n",desc="Find Files"},
			{"<leader>m","<cmd>Telescope marks<CR>","n",desc="Marks"},
			{"<leader>p", "<cmd>Telescope registers<CR>", "n",desc="Paste from Register"},
		},
	},

	-- Lsp
	{
		'VonHeikemen/lsp-zero.nvim', 
		branch = 'v3.x',
		config = function()
			 local lsp_zero = require('lsp-zero')
			 lsp_zero.on_attach(function(client, bufnr)
				 local opts = {buffer = bufnr, remap = false}
				 lsp_zero.default_keymaps({
					 buffer = bufnr,
					 exclude = {'gs', 'gl', '<F2>', '<F4>'},
				 })
				 -- if client.server_capabilities.documentFormattingProvider then
				 -- end
				 vim.keymap.set('n', 'gR', '<cmd>Telescope lsp_references<cr>', {buffer = bufnr})
				 vim.keymap.set('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)		 
				 vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
				 vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
				 vim.api.nvim_create_autocmd("BufWritePre", {
					 group = augroup,
					 buffer = bufnr,
					 callback = function()
						 vim.lsp.buf.format()
					 end,
				 })
			 end)

			 require('mason').setup({})
			 require('mason-lspconfig').setup({
				 ensure_installed = {'clangd', 'gopls', 'tsserver', 'rust_analyzer','marksman'},
				 handlers = {
					 lsp_zero.default_setup,
					 lua_ls = function()
						 local lua_opts = lsp_zero.nvim_lua_ls()
						 require('lspconfig').lua_ls.setup(lua_opts)
					 end,
				 }
			 })
		end,
		dependencies = {
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},
			{'neovim/nvim-lspconfig'},	
			{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
		},
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = "InsertEnter",
		dependencies = {
		  'L3MON4D3/LuaSnip',
		  'saadparwaiz1/cmp_luasnip',
		  'hrsh7th/cmp-nvim-lsp',
		  "hrsh7th/cmp-buffer",
		  'rafamadriz/friendly-snippets',
		},
	},

	-- Treesitter: Highlight, Folding
	{'nvim-treesitter/nvim-treesitter'},
	{'nvim-treesitter/nvim-treesitter-textobjects'},

})

-- General Settings
vim.o.hlsearch = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.o.wrap = true
-- vim.o.nowrap = true
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('t', '<Esc><Esc>', '<c-\\><c-n>')
vim.keymap.set('n', '<M-h>', '<C-W>h')
vim.keymap.set("n",'<M-j>', "<C-W>j")
vim.keymap.set("n",'<M-k>', "<C-W>k")
vim.keymap.set("n",'<M-l>', "<C-W>l")
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

