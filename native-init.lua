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

-- Treesitter: Highlight & Folding
-- https://github.com/nvim-treesitter/nvim-treesitter
path = vim.fn.stdpath('data')..'/site/pack/nvim-treesitter/start/nvim-treesitter'
if vim.fn.empty(vim.fn.glob(path)) > 0 then
	vim.fn.system({'git', 'clone', 'https://github.com/nvim-treesitter/nvim-treesitter', path})
end
require('nvim-treesitter.configs').setup({
	highlight = {enable = true,},
	indent = { enable = true },
	ensure_installed = {"go"},
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

