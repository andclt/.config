---@diagnostic disable: undefined-global
local vim = vim

return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                json = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                markdown = { "prettier" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })

        -- Keybindings
        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            require("conform").format({ async = true, lsp_fallback = true })
        end, { desc = "Format file" })
    end
}