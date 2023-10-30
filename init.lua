-- General
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n",'L', ":bn<CR>")
vim.keymap.set("n",'H', ":bp<CR>")
vim.keymap.set("n", "<leader>q", ":bd<CR>")
vim.keymap.set("n", "<leader>n", ":tabnew<CR>")
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, {noremap=true, silent=true})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {noremap=true, silent=true})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {noremap=true, silent=true})
vim.cmd[[tnoremap <Esc> <c-\><c-n>]]
vim.cmd[[let &path = getcwd() . '/**']]
vim.cmd[[set grepprg=rg\ --vimgrep]]
vim.cmd[[set grepformat=%f:%l:%c:%m]]

-- Mini Plugins: Fuzzy Finder, Autocompletion, Autopairs
-- https://github.com/echasnovski/mini.nvim
local path = vim.fn.stdpath('data')..'/site/pack/mini.nvim/start/mini.nvim'
if vim.fn.empty(vim.fn.glob(path)) > 0 then
	vim.fn.system({'git', 'clone', 'https://github.com/echasnovski/mini.nvim', path})
end

require('mini.base16').setup({ 
	palette = {
		base00= "#282c34",
		base01= "#353b45",
		base02= "#3e4451",
		base03= "#545862",
		base04= "#565c64",
		base05= "#abb2bf",
		base06= "#b6bdca",
		base07= "#c8ccd4",
		base08= "#e06c75",
		base09= "#d19a66",
		base0A= "#e5c07b",
		base0B= "#98c379",
		base0C= "#56b6c2",
		base0D= "#61afef",
		base0E= "#c678dd",
		base0F= "#be5046",
    },
})
require('mini.pick').setup({})
require('mini.completion').setup({})
require('mini.pairs').setup({})
require('mini.comment').setup({})

-- Treesitter: Highlight & Folding
-- https://github.com/nvim-treesitter/nvim-treesitter
vim.wo.foldtext = "v:lua.vim.treesitter.foldtext()"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.cmd[[set foldmethod=expr]]
path = vim.fn.stdpath('data')..'/site/pack/nvim-treesitter/start/nvim-treesitter'
if vim.fn.empty(vim.fn.glob(path)) > 0 then
	vim.fn.system({'git', 'clone', 'https://github.com/nvim-treesitter/nvim-treesitter', path})
end
require('nvim-treesitter.configs').setup({
	highlight = {enable = true,},
	indent = { enable = true },
	ensure_installed = {"go"},
})
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
path = vim.fn.stdpath('data')..'/site/pack/nvim-treesitter-textobjects/start/nvim-treesitter-textobjects'
if vim.fn.empty(vim.fn.glob(path)) > 0 then
	vim.fn.system({'git', 'clone', 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', path})
end
require('nvim-treesitter.configs').setup({
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
      },
    },
  },
})
-- Lsp
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local opts = { noremap=true, silent=true, buffer= args.bufnr}
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<leader>rr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)
	end,
})

function start_lsp(args,command_name,root_list)
	vim.lsp.start({
		name = command_name,
		cmd = {command_name},
		root_dir = vim.fs.dirname(vim.fs.find(root_list, { upward = true })[1]),
    })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"c", "h"},
    callback = function(args) start_lsp(args, 'clangd', {'compile_commands.json', 'compile_flags.txt', '.git'}) end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function(args) 
		vim.cmd[[set formatprg=goimports]]
		start_lsp(args, 'gopls',{ 'go.mod', 'go.work', '.git' }) 
	end,
})

