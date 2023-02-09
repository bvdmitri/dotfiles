
local other = require('other-nvim')

other.setup {
    mappings = {
        -- builtin mappings
        -- "livewire",
        "angular",
        -- "laravel",
        -- "rails",
        -- custom mapping for Julia tests
        {
            pattern = "/src/(.*).jl$",
            target = "/test/test_%1.jl",
            transformer = "lowercase",        -- I don't use it, but left for the future reference
            context = "test"
        },
        {
            pattern = "/src/(.*)/(.*).jl$",
            target = "/test/%1/test_%2.jl",
            transformer = "lowercase",        -- I don't use it, but left for the future reference
            context = "test"
        },
        {
            pattern = "/test/test_(.*).jl$",
            target = "/src/%1.jl",
            transformer = "lowercase",        -- I don't use it, but left for the future reference
            context = "implementation"
        },
        {
            pattern = "/test/(.*)/test_(.*).jl$",
            target = "/src/%1/%2.jl",
            transformer = "lowercase",        -- I don't use it, but left for the future reference
            context = "implementation"
        }
    },
    transformers = {
        -- defining a custom transformer
        lowercase = function (inputString)
            return inputString:lower()
        end
    },
    style = {
        -- How the plugin paints its window borders
        -- Allowed values are none, single, double, rounded, solid and shadow
        border = "solid",

        -- Column seperator for the window
        seperator = "|",

	-- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
	width = 0.7,

	-- min height in rows.
	-- when more columns are needed this value is extended automatically
	minHeight = 2
    },
}

vim.keymap.set('n', '<Leader>af', '<CMD>Other<CR>')
vim.keymap.set('n', '<Leader>av', '<CMD>OtherSplit<CR>')
vim.keymap.set('n', '<Leader>ax', '<CMD>OtherVSplit<CR>')

