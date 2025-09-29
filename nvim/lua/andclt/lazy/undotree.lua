---@diagnostic disable: undefined-global
local vim = vim

return {
	"mbbill/undotree",

	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
	end,
}
