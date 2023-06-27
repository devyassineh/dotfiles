vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


if vim.g.neovide then
	vim.o.guifont = "Go Mono:h14" 
	vim.g.neovide_cursor_vfx_mode = ""
	vim.g.neovide_cursor_animation_length = 0
end

local os = require("os")
local path_to_desktop = os.getenv("HOME") .. "\\github.com\\yassinehaddoudi"
local vim_enter_group = vim.api.nvim_create_augroup("vim_enter_group", { clear = true })
vim.api.nvim_create_autocmd(
    {"VimEnter"},
    { pattern = "*", command = "cd " .. path_to_desktop, group = vim_enter_group }
)


local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  "mbbill/undotree",
  "tpope/vim-fugitive",
  
  {
    'navarasu/onedark.nvim',
    priority = 250,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },
  
  "rktjmp/lush.nvim",
  

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  'nvim-treesitter/nvim-treesitter-context',
  'nvim-treesitter/playground',
   "Dkendal/nvim-treeclimber",
 
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {                                      -- Optional
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     -- Required
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'L3MON4D3/LuaSnip'},     -- Required
	   -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    }
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  
  {
    "windwp/nvim-autopairs",
	-- Optional dependency
	dependencies = { 'hrsh7th/nvim-cmp' },
	config = function()
	require("nvim-autopairs").setup {}
	-- If you want to automatically add `(` after selecting a function or method
	local cmp_autopairs = require('nvim-autopairs.completion.cmp')
	local cmp = require('cmp')
	cmp.event:on(
	  'confirm_done',
	  cmp_autopairs.on_confirm_done()
	)
	end,
  },

  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  'harrisoncramer/jump-tag',

}, {})

vim.o.hlsearch = false
vim.o.nu = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeout = true
--vim.o.timeoutlen = 1000
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>p", [["+p]])
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)


local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>ps', 
  function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end)

local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gc', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
end

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>el', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'gopls',
  'rust_analyzer',
})


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<Tab>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<S-Tab>'] = cmp.mapping.select_next_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ip"] = "@parameter.inner",
		["ap"] = "@parameter.outer",
	  },
	  include_surrounding_whitespace = true,
    },
	move = {
      enable = true,
	  set_jumps = true, -- whether to set jumps in the jumplist
	  goto_next_start  = {
	  },
	  goto_previous_start = {
	  },
	},
  },  
}

require('nvim-treeclimber').setup()