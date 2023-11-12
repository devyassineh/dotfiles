-- Leader key settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.timeoutlen = 1000
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Plugin Manager
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

-- Plugins
require("lazy").setup({
	-- Appearance
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

	-- File Explorer: Works like a Buffer, ~=cwd, -= go up dir
	{
		'stevearc/oil.nvim',
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup()
			vim.keymap.set("n","<leader>e","<cmd>Oil<CR>")
		end,
	},

	-- Quick Navigation: per project-based Marks, Terminal, Commands
	{
		'ThePrimeagen/harpoon',
		dependencies = {
			'nvim-lua/plenary.nvim'
		},
		config = function()
			vim.keymap.set("n","<leader>ht", function() 
				require('harpoon.term').sendCommand(1,"cd ".. vim.fn.getcwd() .."\r")
				require('harpoon.term').gotoTerminal(1) 
			end)
			vim.keymap.set("n", "<leader>hc", "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>")
			vim.keymap.set("n", "<leader>hs", "<cmd>lua require('harpoon.term').sendCommand(1,1)<CR>")
			vim.keymap.set("n", "<leader>hd", "<cmd>lua require('harpoon.term').sendCommand(1,2)<CR>")
			vim.keymap.set("n", "<leader>hf", "<cmd>lua require('harpoon.term').sendCommand(1,3)<CR>")
			vim.keymap.set("n", "<leader>hg", "<cmd>lua require('harpoon.term').sendCommand(1,4)<CR>")
			vim.keymap.set("n","<leader>hm","<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>")
			vim.keymap.set("n","<leader>ha","<cmd>lua require('harpoon.mark').add_file()<CR>")
			vim.keymap.set("n","<leader>hh","<cmd>lua require('harpoon.ui').nav_file(1)<CR>")
			vim.keymap.set("n","<leader>hj","<cmd>lua require('harpoon.ui').nav_file(2)<CR>")
			vim.keymap.set("n","<leader>hk","<cmd>lua require('harpoon.ui').nav_file(3)<CR>")
			vim.keymap.set("n","<leader>hl","<cmd>lua require('harpoon.ui').nav_file(4)<CR>")
		end,
	},
	
	-- Editor: Comment/Uncomment, Autopairs: {}()[]""
	{ 'numToStr/Comment.nvim', opts = {} },
	{ 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },

	-- Fuzzy Find: Files, Old Files, Buffers, Current Buffer Search, Lsp Search
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.3',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{'nvim-telescope/telescope-fzf-native.nvim', build = 'make'}
		},
		config = function()
			require('telescope').setup({}) 
			vim.keymap.set("n","<leader><leader>", "<cmd>Telescope buffers<CR>")
			vim.keymap.set("n","<leader>?", "<cmd>Telescope oldfiles<CR>")
			vim.keymap.set("n","<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
			vim.keymap.set("n","<leader>f","<cmd>Telescope find_files<CR>")
			vim.keymap.set("n","<leader>l","<cmd>Telescope lsp_document_symbols<CR>")
		end,
	},

	-- Lsp: Code Format, Code Reference/Definition, Code Actions, Documentation, Diagnositcs
	{
		'VonHeikemen/lsp-zero.nvim', 
		branch = 'v3.x',
		config = function()
			 local lsp_zero = require('lsp-zero')
			 lsp_zero.on_attach(function(client, bufnr)
				 local opts = {buffer = bufnr, remap = false}
				 lsp_zero.default_keymaps({
					 buffer = bufnr,
					 exclude = {'gs', 'gl', '<F2>', '<F3>','<F4>'},
				 })
				 lsp_zero.buffer_autoformat() 
				 vim.keymap.set('n', 'gR', '<cmd>Telescope lsp_references<cr>', {buffer = bufnr})
				 vim.keymap.set('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)		 
			         vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
				 vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
				vim.keymap.set('n', '<leader>dd', vim.diagnostic.setloclist, {noremap=true, silent=true})
				 vim.keymap.set('n', '<leader>dn', "<cmd>lua vim.diagnostic.goto_next()<CR>",opts)
				 vim.keymap.set('n', '<leader>dp', "<cmd>lua vim.diagnostic.goto_prev()<CR>",opts)
			 end)

			 require('mason').setup({})
			 require('mason-lspconfig').setup({
				 ensure_installed = {'gopls', 'tsserver', 'rust_analyzer','marksman'},
				 handlers = {
					 lsp_zero.default_setup,
					 gopls = function()
						 local lspconfig = require('lspconfig')
						 lspconfig.gopls.setup {
							root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
						 }
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

	-- Autocompletion: Lsp, Snippets, Buffer
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
	          'hrsh7th/cmp-buffer',
		  'saadparwaiz1/cmp_luasnip',
		  'hrsh7th/cmp-nvim-lsp',
		  'L3MON4D3/LuaSnip',
		  'rafamadriz/friendly-snippets',
		},
		config = function()
			local cmp = require('cmp')
			local cmp_action = require('lsp-zero').cmp_action()
			require('luasnip.loaders.from_vscode').lazy_load()
			cmp.setup({
				preselect = cmp.PreselectMode.None,
				completion = {
					completeopt = 'menu,noselect',
				},
				view = {            
					entries = "wildmenu" -- can be "custom", "wildmenu" or "native"
				},
				sources = {
					{name = 'luasnip'},
					{name = 'nvim_lsp'},
					{name = 'buffer'},
				},
				mapping = cmp.mapping.preset.insert({
					['<Tab>'] = cmp_action.luasnip_jump_forward(),
					['<S-Tab>'] = cmp_action.luasnip_jump_backward(),
					['<CR>'] = cmp.mapping.confirm({select = true}),
				})
			})
		end,
	},

	-- Treesitter: Highlight, Indent, Textobjects
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		config = function ()
			require('nvim-treesitter.configs').setup({
				ensure_installed = {'lua','go','rust','markdown','javascript','c'},
				auto_install = false,
				highlight = {enable = true,},
				indent = { enable = true },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ap"] = "@parameter.outer",
							["ip"] = "@parameter.inner",
							["al"] = "@assignment.lhs",
							["ar"] = "@assignment.rhs",
							["aa"] = "@assignment.outer",
						},
					},
					lsp_interop = {
						enable = true,
						peek_definition_code = {
							["<leader>pk"] = "@function.outer",
							["<leader>pK"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>sp"] = "@parameter.inner",
							["<leader>sa"] = "@assignment.inner",
						},
						swap_previous = {
							["<leader>sP"] = "@parameter.inner",
							["<leader>sA"] = "@assignment.inner",
						},
					},
				},
			})
		end,
	},
})

-- General
vim.o.wrap = true
vim.o.hlsearch = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.mouse = 'a'
vim.o.termguicolors = true
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.keymap.set('n', '<leader>w', '<C-W>') -- window movement: <leader>w instead of <C-w>
vim.keymap.set("n","<C-d>", "<C-d>zz") -- better scrolling
vim.keymap.set("n","<C-u>", "<C-u>zz")
vim.keymap.set('n','gp','`[v`]') -- select last modification
vim.o.clipboard = 'unnamedplus'
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight yank/copy
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Terminal settings
vim.cmd [[tnoremap <Esc> <C-\><C-n>]]
if vim.loop.os_uname().sysname == 'Windows' then
  vim.cmd [[set shell=powershell]]
end

