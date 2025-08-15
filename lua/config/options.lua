vim.opt.number =true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.updatetime = 250
vim.opt.splitright = true

-- Toggle Neo-tree on the left
vim.keymap.set('n', '<C-n>', ':Neotree toggle left reveal=true<CR>', { noremap = true, silent = true })

-- Terminal toggle with Ctrl+`
vim.keymap.set("n", "<C-`>", function()
    local term_bufs = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == "terminal" then
            table.insert(term_bufs, buf)
        end
    end

    if #term_bufs > 0 and vim.fn.win_findbuf(term_bufs[1])[1] then
        -- Terminal exists and is open in a window, close it
        vim.cmd("hide")
    else
        -- Open a terminal in a horizontal split
        vim.cmd("botright split | terminal")
        -- Enter insert mode automatically
        vim.cmd("startinsert")
    end
end, { desc = "Toggle terminal", noremap = true, silent = true })

-- Terminal keymaps - allow using Esc to exit terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Configure diagnostics to show inline
vim.diagnostic.config({
  virtual_text = true,      -- Show diagnostics as virtual text
  signs = true,             -- Show signs in the sign column
  underline = true,         -- Underline text with diagnostics
  update_in_insert = false, -- Don't update diagnostics in insert mode
  severity_sort = true,     -- Sort diagnostics by severity
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Automatically show diagnostics when cursor is on the line with an error
vim.cmd [[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
]]

-- Copilot Chat keymaps
vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChat<cr>', { desc = "Open Copilot Chat" })
vim.keymap.set('n', '<leader>ccq', function()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    vim.cmd("CopilotChat " .. input)
  end
end, { desc = "Quick Chat" })
vim.keymap.set('n', '<leader>cca', function()
  local input = vim.fn.input("Agent Mode - Describe changes: ")
  if input ~= "" then
    vim.cmd("CopilotChat " .. input .. " - Please provide complete corrected code for direct application")
  end
end, { desc = "Agent Mode - Direct Changes" })
vim.keymap.set('n', '<leader>ccA', '<cmd>CopilotChatAgent<cr>', { desc = "Choose Copilot agent (chat on right)" })
vim.keymap.set('n', '<leader>ccM', '<cmd>CopilotChatModel<cr>', { desc = "Choose Copilot model (shortcuts/menu)" })
vim.keymap.set('n', '<leader>cct', '<cmd>CopilotChatToggle<cr>', { desc = "Toggle Copilot Chat" })
vim.keymap.set('n', '<leader>ccr', '<cmd>CopilotChatReset<cr>', { desc = "Reset Copilot Chat" })
vim.keymap.set('n', '<leader>ccs', '<cmd>CopilotChatStop<cr>', { desc = "Stop Copilot Chat" })
vim.keymap.set('n', '<leader>cce', '<cmd>CopilotEditBuffer<cr>', { desc = "Explain selected code" })
vim.keymap.set('x', '<leader>ccf', '<cmd>CopilotChatFix<cr>', { desc = "Fix selected code" })
vim.keymap.set('x', '<leader>cco', '<cmd>CopilotChatOptimize<cr>', { desc = "Optimize selected code" })
vim.keymap.set('x', '<leader>ccd', '<cmd>CopilotChatDocs<cr>', { desc = "Document selected code" })
vim.keymap.set('n', '<leader>cceA','<cmd>CopilotEditBuffer<cr>',{desc ="edit a file directly from agent"})
--Set default font
vim.opt.guifont = { "JetBrainsMonoNL Nerd Font Prop", ":h13" }
