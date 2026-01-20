-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- This config keeps only window manager navigation and OpenCode keybindings
-- All other LazyVim default keybindings are disabled

-- Delete all LazyVim default keymaps except window navigation
local function delete_default_keymaps()
  local keymaps_to_delete = {
    -- Movement
    { "n", "j" }, { "x", "j" }, { "n", "<Down>" }, { "x", "<Down>" },
    { "n", "k" }, { "x", "k" }, { "n", "<Up>" }, { "x", "<Up>" },
    
    -- Resize windows (conflicts with Ctrl+Arrow)
    { "n", "<C-Up>" }, { "n", "<C-Down>" }, { "n", "<C-Left>" }, { "n", "<C-Right>" },
    
    -- Move lines
    { "n", "<A-j>" }, { "n", "<A-k>" }, { "i", "<A-j>" }, { "i", "<A-k>" },
    { "v", "<A-j>" }, { "v", "<A-k>" },
    
    -- Buffers
    { "n", "<S-h>" }, { "n", "<S-l>" }, { "n", "[b" }, { "n", "]b" },
    { "n", "<leader>bb" }, { "n", "<leader>`" }, { "n", "<leader>bd" },
    { "n", "<leader>bo" }, { "n", "<leader>bD" },
    
    -- Clear search
    { "i", "<esc>" }, { "n", "<esc>" }, { "s", "<esc>" },
    { "n", "<leader>ur" },
    
    -- Search navigation
    { "n", "n" }, { "x", "n" }, { "o", "n" },
    { "n", "N" }, { "x", "N" }, { "o", "N" },
    
    -- Undo breakpoints
    { "i", "," }, { "i", "." }, { "i", ";" },
    
    -- Save file
    { "i", "<C-s>" }, { "x", "<C-s>" }, { "n", "<C-s>" }, { "s", "<C-s>" },
    
    -- Keywordprg
    { "n", "<leader>K" },
    
    -- Indenting
    { "x", "<" }, { "x", ">" },
    
    -- Commenting
    { "n", "gco" }, { "n", "gcO" },
    
    -- Lazy
    { "n", "<leader>l" },
    
    -- New file
    { "n", "<leader>fn" },
    
    -- Location/Quickfix list
    { "n", "<leader>xl" }, { "n", "<leader>xq" },
    { "n", "[q" }, { "n", "]q" },
    
    -- Formatting
    { "n", "<leader>cf" }, { "x", "<leader>cf" },
    
    -- Diagnostics
    { "n", "<leader>cd" }, { "n", "]d" }, { "n", "[d" },
    { "n", "]e" }, { "n", "[e" }, { "n", "]w" }, { "n", "[w" },
    
    -- Toggle options
    { "n", "<leader>uf" }, { "n", "<leader>uF" }, { "n", "<leader>us" },
    { "n", "<leader>uw" }, { "n", "<leader>uL" }, { "n", "<leader>ud" },
    { "n", "<leader>ul" }, { "n", "<leader>uc" }, { "n", "<leader>uA" },
    { "n", "<leader>uT" }, { "n", "<leader>ub" }, { "n", "<leader>uD" },
    { "n", "<leader>ua" }, { "n", "<leader>ug" }, { "n", "<leader>uS" },
    { "n", "<leader>dpp" }, { "n", "<leader>dph" }, { "n", "<leader>uh" },
    
    -- Git
    { "n", "<leader>gg" }, { "n", "<leader>gG" }, { "n", "<leader>gL" },
    { "n", "<leader>gb" }, { "n", "<leader>gf" }, { "n", "<leader>gl" },
    { "n", "<leader>gB" }, { "x", "<leader>gB" },
    { "n", "<leader>gY" }, { "x", "<leader>gY" },
    
    -- Quit
    { "n", "<leader>qq" },
    
    -- Inspect
    { "n", "<leader>ui" }, { "n", "<leader>uI" },
    
    -- LazyVim Changelog
    { "n", "<leader>L" },
    
    -- Terminal
    { "n", "<leader>fT" }, { "n", "<leader>ft" },
    { "n", "<c-/>" }, { "t", "<c-/>" },
    { "n", "<c-_>" }, { "t", "<c-_>" },
    
    -- Windows
    { "n", "<leader>-" }, { "n", "<leader>|" }, { "n", "<leader>wd" },
    { "n", "<leader>wm" }, { "n", "<leader>uZ" }, { "n", "<leader>uz" },
    
    -- Tabs
    { "n", "<leader><tab>l" }, { "n", "<leader><tab>o" }, { "n", "<leader><tab>f" },
    { "n", "<leader><tab><tab>" }, { "n", "<leader><tab>]" }, { "n", "<leader><tab>d" },
    { "n", "<leader><tab>[" },
    
    -- Lua debugging
    { "n", "<localleader>r" }, { "x", "<localleader>r" },
  }
  
  for _, keymap in ipairs(keymaps_to_delete) do
    pcall(vim.keymap.del, keymap[1], keymap[2])
  end
end

-- Run after LazyVim loads its keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.schedule(function()
      delete_default_keymaps()
    end)
  end,
})

-- Keep only window navigation keybindings (these are the ones we want to preserve)
-- These will be set after deleting the defaults
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.schedule(function()
      -- Window navigation - these are the window manager keybindings we want to keep
      vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
      vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
      vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
      vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
    end)
  end,
})
