vim.g.mapleader = " "
vim.o.laststatus = 0
vim.o.number = true
vim.o.relativenumber = true
vim.api.nvim_set_hl(0, "WinSeparator", {fg='NvimDarkGrey2'})
vim.o.splitright = true
vim.cmd[[set grepprg=rg\ --vimgrep]]
vim.o.completeopt = 'menuone,noselect'
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"

vim.api.nvim_create_autocmd("TextChangedI", {
  group = vim.api.nvim_create_augroup("Completion while typing", {}),
  callback = function()
    local client = vim.lsp.buf_get_clients(0)[1]
    if not client or not client.server_capabilities then return end

    local col = vim.api.nvim_win_get_cursor(0)[2]
    local char = vim.api.nvim_get_current_line():sub(col, col)

    if vim.fn.pumvisible() and char:match("[a-zA-Z.]") then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true), 'm', true)
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
	pattern = "*",
	callback = function(args)
		print("Lsp is attached")
		local opts = { noremap=true, silent=true, buffer= args.bufnr}
		vim.keymap.set('n', 'gd', 'lua vim.lsp.buf.definition()<CR>', opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
		vim.keymap.set({'i','s'}, '<C-s>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
		vim.lsp.completion.enable(true, args.data.client_id, args.buf, { autotrigger = true })
	end,
})

function start_lsp(args,command_name,root_list)
	local caps = vim.lsp.protocol.make_client_capabilities()
	caps.textDocument.completion.completionItem.snippetSupport = true
	vim.lsp.start({
		name = command_name,
		cmd = {command_name},
		root_dir = vim.fs.dirname(vim.fs.find(root_list, { upward = true })[1]),
		capabilities = caps,
    })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function(args) start_lsp(args, 'gopls',{ 'go.mod', 'go.work', '.git' }) end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"c", "h"},
    callback = function(args) start_lsp(args, 'clangd', {'compile_commands.json', 'compile_flags.txt', '.git'}) end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"rust"},
    callback = function(args) start_lsp(args, 'rust-analyzer', {'Cargo.toml', '.git'}) end,
})
