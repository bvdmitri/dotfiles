vim.pack.add({
    { src = gh('olimorris/codecompanion.nvim') }
})

local companion = require('codecompanion')
local default_adapter = { name = "openai", model = "gpt-4" }

companion.setup({
    display = {
        chat = {
            window = {
                layout = "float",
                width = 0.7,
                border = "rounded"
            }
        }
    },
    interactions = {
        chat = { adapter = "codex" },
        inline = {
            adapter = default_adapter,
        },
        cmd = { adapter = default_adapter },
    },
})

local keymap = require('keymap')

keymap.add_group('Coding Assistant', '<leader>a')

function toggle_companion(layout)
    return function()
        companion.toggle({ window_opts = { layout = layout, width = 0.6 } })
    end
end

keymap.nvmap('<leader>ac', '<CMD>CodeCompanionAction<CR>', 'Coding Assistant Actions')
keymap.nvmap('<leader>ai', '<CMD>CodeCompanion<CR>', 'Coding Assistant Inline')
keymap.nmap('<leader>aa', toggle_companion("float"), 'Toggle Coding Assistant Chat (floating)')
keymap.nmap('<leader>av', toggle_companion("vertical"), 'Toggle Coding Assistant Chat (vertical)')
keymap.vmap('<leader>ae', '<CMD>CodeCompanion /explain<CR>', 'Coding Assistant /explain')

-- Fidget <-> Companion integration

local progress = require("fidget.progress")
local CodeCompanionProgress = {}

CodeCompanionProgress.handles = {}

function CodeCompanionProgress:store_progress_handle(id, handle)
    CodeCompanionProgress.handles[id] = handle
end

function CodeCompanionProgress:pop_progress_handle(id)
    local handle = CodeCompanionProgress.handles[id]
    CodeCompanionProgress.handles[id] = nil
    return handle
end

function CodeCompanionProgress:create_progress_handle(request)
    return progress.handle.create({
        title = " Requesting assistance (" .. request.data.interaction .. ")",
        message = "In progress...",
        lsp_client = {
            name = CodeCompanionProgress:llm_role_title(request.data.adapter),
        },
    })
end

function CodeCompanionProgress:llm_role_title(adapter)
    local parts = {}
    table.insert(parts, adapter.formatted_name)
    if adapter.model and adapter.model ~= "" then
        table.insert(parts, "(" .. adapter.model .. ")")
    end
    return table.concat(parts, " ")
end

function CodeCompanionProgress:report_exit_status(handle, request)
    if request.data.status == "success" then
        handle.message = "Completed"
    elseif request.data.status == "error" then
        handle.message = " Error"
    else
        handle.message = "󰜺 Cancelled"
    end
end

local CodeCompanionFidgetHooks = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    group = CodeCompanionFidgetHooks,
    callback = function(request)
        local handle = CodeCompanionProgress:create_progress_handle(request)
        CodeCompanionProgress:store_progress_handle(request.data.id, handle)
    end,
})

vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    group = CodeCompanionFidgetHooks,
    callback = function(request)
        local handle = CodeCompanionProgress:pop_progress_handle(request.data.id)
        if handle then
            CodeCompanionProgress:report_exit_status(handle, request)
            handle:finish()
        end
    end,
})
