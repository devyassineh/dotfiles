-- Leader key settings
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
	{
		'Mofiqul/vscode.nvim',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme 'vscode'
			vim.o.background = 'dark'
			vim.keymap.set("n", "<leader>v", function() 
				if vim.o.background == 'light' then
					vim.o.background = 'dark'
				else
					vim.o.background = 'light'
				end
			end)
		end,
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
		  options = {
			icons_enabled = false,
			component_separators = '|',
			section_separators = '',
			theme = 'vscode'
		  },
		},
	},
	{
		'stevearc/oil.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			keymaps = {
				["~"] = function()
					require("oil.actions").tcd.callback()
					require('harpoon.term').sendCommand(1,"cd ".. vim.fn.getcwd() .."\r")
					require('harpoon.term').sendCommand(1,"")
				end,
			},
		},
		config = function(_,opts)
			require("oil").setup(opts)
			vim.keymap.set("n","<leader>e","<cmd>Oil<CR>")
		end,
	},
	{
		'ThePrimeagen/harpoon',
		dependencies = {
			'nvim-lua/plenary.nvim'
		},
		config = function()
			vim.keymap.set("n","<leader>t", "<cmd>lua require('harpoon.term').gotoTerminal(1)<CR>")
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
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.3',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		config = function()
			require('telescope').setup({}) 
			vim.keymap.set("n","<leader>b", "<cmd>Telescope buffers<CR>")
			vim.keymap.set("n","<leader>?", "<cmd>Telescope oldfiles<CR>")
			vim.keymap.set("n","<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
			vim.keymap.set("n","<leader>f","<cmd>Telescope find_files<CR>")
			vim.keymap.set("n","<leader>l","<cmd>Telescope lsp_document_symbols<CR>")
		end,
	},
	{ 'numToStr/Comment.nvim', opts = {} },
	{ 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
	{
		'neovim/nvim-lspconfig', 
		config = function()
			local lspconfig = require('lspconfig')
			local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
			local default_setup = function(server)
				lspconfig[server].setup({
					capabilities = lsp_capabilities,
				})
			end
			require('mason').setup({})
			require('mason-lspconfig').setup({
				 ensure_installed = {'gopls', 'tsserver', 'rust_analyzer','marksman'},
				 handlers = {default_setup,}
			 })
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', 'gR', '<cmd>Telescope lsp_references<cr>', opts) 
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set({'i','s'}, '<C-s>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
					vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
					vim.keymap.set('n', 'gl', "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
					vim.keymap.set('n', '[d', "<cmd>lua vim.diagnostic.goto_next()<CR>",opts)
					vim.keymap.set('n', ']d', "<cmd>lua vim.diagnostic.goto_prev()<CR>",opts)
			end,
			})


		end,
		dependencies = {
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},
			{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
		},
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lsp',
		},
		config = function()
			local cmp = require('cmp')
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end
				},
				preselect = cmp.PreselectMode.None, -- for golang 
				completion = {
					completeopt = 'menuone,noselect',
				},
				view = {            
					entries = "native",
				},
				sources = {
					{name = 'nvim_lsp'},
					{name = 'buffer'},
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete {},
					['<CR>'] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif vim.snippet.jumpable(1) then
							vim.snippet.jump(1)
						else
							fallback()
						end
					end,{'i','s'}),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif vim.snippet.jumpable(1) then
							vim.snippet.jump(-1)
						else
							fallback()
						end
					end,{'i','s'}),
				})
			})
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function ()
			require('nvim-treesitter.configs').setup({
				ensure_installed = {'lua','go','rust','markdown','javascript','c'},
				auto_install = true,
				highlight = {enable = true,},
				indent = { enable = true },
			})
		end,
	},
})

vim.o.wrap = true
vim.o.hlsearch = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
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
