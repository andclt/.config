---@diagnostic disable: undefined-global
return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		indent = { char = "│", tab_char = "│" },
		scope = { enabled = true, show_start = false, show_end = false },
		exclude = {
			filetypes = {
				"help",
				"lazy",
				"mason",
				"neo-tree",
				"Trouble",
				"alpha",
				"dashboard",
				"NvimTree",
				"undotree",
				"gitcommit",
				"markdown",
			},
			buftypes = { "terminal", "nofile", "prompt" },
		},
	},
	config = function(_, opts)
		local ibl = require("ibl")
		ibl.setup(opts)
	end,
}
