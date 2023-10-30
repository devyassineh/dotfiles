-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information


return {
	{
		'akinsho/bufferline.nvim', 
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require('bufferline').setup({})
			vim.keymap.set('n','H','<cmd>bp<CR>')
			vim.keymap.set('n','L','<cmd>bn<CR>')
		end,
	
	},
	--[[
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
		  "nvim-lua/plenary.nvim",
		  "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		  "MunifTanjim/nui.nvim",
		},
		
		config = function()
			require('neo-tree').setup({})
		end,
	},
--]]
}
