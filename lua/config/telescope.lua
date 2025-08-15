local builtin = require("telescope.builtin")

-- Default Telescope setup
require("telescope").setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    sorting_strategy = "ascending",
    layout_config = { prompt_position = "top" },
    respect_gitignore = true,
    file_ignore_patterns = { "node_modules", ".git" },
  },
  pickers = {
    -- Configure find_files to only search in cwd
    find_files = {
      hidden = false,
      find_command = { "find", ".", "-type", "f" },
      cwd = vim.fn.getcwd(),
    },
    -- Configure live_grep to only search in cwd
    live_grep = {
      cwd = vim.fn.getcwd(),
      additional_args = function()
        return { "--hidden" }
      end
    },
    -- Configure other pickers to respect cwd
    buffers = {
      show_all_buffers = false,
      sort_lastused = true,
    },
    oldfiles = {
      cwd_only = true,
    },
  },
})

-- Keybindings
vim.keymap.set("n", "<Space>ff", function()
  builtin.find_files({ cwd = vim.fn.getcwd() })
end, { desc = "Find files in cwd" })

vim.keymap.set("n", "<Space>fg", function()
  builtin.live_grep({ cwd = vim.fn.getcwd() })
end, { desc = "Live grep in cwd" })

vim.keymap.set("n", "<Space>fb", builtin.buffers, { desc = "List buffers" })
vim.keymap.set("n", "<Space>fh", builtin.help_tags, { desc = "Help tags" })

vim.keymap.set("n", "<Space>fo", function()
  builtin.oldfiles({ cwd_only = true })
end, { desc = "Recent files in cwd" })

vim.keymap.set("n", "<Space>fs", function()
  builtin.grep_string({ cwd = vim.fn.getcwd() })
end, { desc = "Grep word under cursor in cwd" })

vim.keymap.set("n", "<Space>fd", builtin.diagnostics, { desc = "Workspace diagnostics" })
