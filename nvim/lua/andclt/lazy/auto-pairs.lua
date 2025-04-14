---@diagnostic disable: undefined-global
local vim = vim

return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        local npairs = require("nvim-autopairs")
        local Rule = require("nvim-autopairs.rule")
        
        npairs.setup({
            check_ts = true,  -- Use treesitter to check for pairs
            ts_config = {
                lua = {'string'},  -- don't add pairs in lua string treesitter nodes
                rust = {'string', 'comment'},  -- don't add pairs in rust string and comments
            },
            disable_filetype = { "TelescopePrompt" },
            enable_check_bracket_line = true,  -- check bracket in same line
            ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
            fast_wrap = {
                map = "<M-e>",  -- Alt+e to use fast wrap
                chars = { "{", "[", "(", '"', "'" },
                pattern = [=[[%'%"%>%]%)%}%,]]=],
                offset = 0, -- Offset from pattern match
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "Search",
                highlight_grey = "Comment"
            },
        })
        
        -- Add spaces between parentheses
        -- e.g. type `(|)` and it becomes `( | )`
        npairs.add_rules({
            Rule(' ', ' ')
                :with_pair(function (opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    return vim.tbl_contains({ '()', '[]', '{}' }, pair)
                end),
            Rule('( ', ' )')
                :with_pair(function() return false end)
                :with_move(function(opts)
                    return opts.prev_char:match('.%)') ~= nil
                end)
                :use_key(')'),
            Rule('{ ', ' }')
                :with_pair(function() return false end)
                :with_move(function(opts)
                    return opts.prev_char:match('.%}') ~= nil
                end)
                :use_key('}'),
            Rule('[ ', ' ]')
                :with_pair(function() return false end)
                :with_move(function(opts)
                    return opts.prev_char:match('.%]') ~= nil
                end)
                :use_key(']')
        })
        
        -- Integration with nvim-cmp
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
    end
} 