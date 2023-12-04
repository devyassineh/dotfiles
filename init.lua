vim.g.mapleader = ' ' vim.g.maplocalleader = ' ' vim.o.timeoutlen = 1000
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
		'stevearc/oil.nvim',
		config = function(_,opts)
			require("oil").setup(opts)
			vim.keymap.set("n","<leader>e","<cmd>Oil<CR>")
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
		end,
	},
	{ 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
	{ 'tpope/vim-sleuth' },
	{
		'williamboman/mason.nvim',
		config = function()
			require('mason').setup()
		end
	},
	{
		'neovim/nvim-lspconfig', 
		config = function()
			local lspconfig = require('lspconfig')
			local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
			local custom_attach = function(client, bufnr)
				print('Lsp Attached.')
				local opts = { buffer = bufnr }
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
				vim.keymap.set('n', 'gR', '<cmd>Telescope lsp_references<cr>', opts) 
				vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
				vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
				vim.keymap.set("n","<leader>l","<cmd>Telescope lsp_document_symbols<CR>")
				vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
			end
			local servers = {'clangd','pyright','bashls','rust_analyzer','tsserver','gopls'}
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup {
					on_attach = custom_attach,
					capabilities = lsp_capabilities,
				}
			end
		end,
	},
	{	
	       'hrsh7th/nvim-cmp',
	       dependencies = {
	       	'hrsh7th/cmp-buffer',
	       	'hrsh7th/cmp-nvim-lsp',
	       	'hrsh7th/cmp-nvim-lsp-signature-help',
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
	       		view = {entries = "native",},
	       		sources = {
	       			{name = 'nvim_lsp'},
	       			{name = 'nvim_lsp_signature_help'},
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
				auto_install = true,
				highlight = {enable = true,},
				indent = { enable = true },
				fold = { enable = true },
			})
		end,
	},
})

vim.o.completeopt = 'menuone,noselect' 
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.cmd[[set foldmethod=expr]]
vim.cmd[[set foldexpr=nvim_treesitter#foldexpr()]]
vim.cmd[[set nofoldenable]]
vim.o.hlsearch = false
vim.o.wrap = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.termguicolors = true
vim.api.nvim_set_hl(0, "WinSeparator", {fg='NvimDarkGrey2'})
vim.keymap.set('n', '<leader>t', '<cmd>:term<CR>')
vim.keymap.set('t','<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<leader>w', '<C-W>') -- window movement: <leader>w instead of <C-w>
vim.keymap.set("n","<C-d>", "<C-d>zz") -- better scrolling
vim.keymap.set("n","<C-u>", "<C-u>zz")
vim.keymap.set('n','gp','`[v`]') -- select last modification
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
