---@diagnostic disable: undefined-global
local vim = vim

return {
    {
        "leoluz/nvim-dap-go",
        ft = "go",
        dependencies = "mfussenegger/nvim-dap",
        config = function(_, opts)
            require("dap-go").setup(opts)
        end
    },
    {
        "olexsmir/gopher.nvim",
        ft = "go",
        dependencies = "nvim-lua/plenary.nvim",
        config = function(_, opts)
            require("gopher").setup(opts)
        end,
        build = function()
            vim.cmd.GoInstallDeps()
        end,
    },
} 