---@diagnostic disable: undefined-global
local vim = vim

return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--glob", "!.git/*",
                },
                file_ignore_patterns = {
                    "node_modules",
                    ".git",
                },
                preview = {
                    treesitter = true,
                },
                layout_config = {
                    width = 0.9,
                    height = 0.9,
                    preview_width = 0.6,
                },
            },
            pickers = {
                live_grep = {
                    additional_args = function()
                        return {"--hidden"}
                    end,
                    preview = true,
                },
            },
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>ps', function()
            local ok, err = pcall(builtin.live_grep, {
                search_dirs = {vim.fn.getcwd()},
                prompt_title = "Live Grep",
                results_title = "Search Results",
                preview = true,
            })
            if not ok then
                vim.notify("Error in live_grep: " .. tostring(err), vim.log.levels.ERROR)
            end
        end, {})
    end
}

