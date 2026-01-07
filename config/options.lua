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

-- Toggle Neo-tree on the left, always rooted at current working directory
vim.keymap.set('n', '<C-n>', function()
  vim.cmd('Neotree toggle left reveal=false dir=' .. vim.fn.getcwd())
end, { noremap = true, silent = true, desc = "Toggle Neo-tree at CWD" })

-- Terminal toggle with Ctrl+\
vim.keymap.set("n", "<C-\\>", function()
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

-- Window navigation - move between splits easily with Alt+hjkl
vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Move to left window", noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Move to bottom window", noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Move to top window", noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Move to right window", noremap = true, silent = true })

-- Window navigation from terminal mode with Alt+hjkl
vim.keymap.set("t", "<A-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left window from terminal", noremap = true, silent = true })
vim.keymap.set("t", "<A-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom window from terminal", noremap = true, silent = true })
vim.keymap.set("t", "<A-k>", "<C-\\><C-n><C-w>k", { desc = "Move to top window from terminal", noremap = true, silent = true })
vim.keymap.set("t", "<A-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right window from terminal", noremap = true, silent = true })

-- Cycle through windows with Tab in normal mode
vim.keymap.set("n", "<leader>w", "<C-w>w", { desc = "Cycle to next window", noremap = true, silent = true })
vim.keymap.set("t", "<leader>w", "<C-\\><C-n><C-w>w", { desc = "Cycle to next window from terminal", noremap = true, silent = true })

-- Buffer navigation - move between tabs/buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer", noremap = true, silent = true })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer", noremap = true, silent = true })

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

--Set default font
vim.opt.guifont = { "JetBrainsMonoNL Nerd Font Prop", ":h13" }

