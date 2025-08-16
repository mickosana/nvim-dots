return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    
    -- Helper function to get parent directory of current buffer
    local function get_current_buffer_dir()
      local current_file = vim.api.nvim_buf_get_name(0)
      if current_file == "" then
        return vim.fn.getcwd() -- fallback to current working directory
      end
      return vim.fn.fnamemodify(current_file, ":h")
    end
    
    -- Custom find_files function that searches in current buffer's directory
    local function find_files_in_buffer_dir()
      local dir = get_current_buffer_dir()
      builtin.find_files({
        cwd = dir,
        prompt_title = "Find Files in " .. vim.fn.fnamemodify(dir, ":t")
      })
    end
    
    -- Custom live_grep function that searches in current buffer's directory
    local function live_grep_in_buffer_dir()
      local dir = get_current_buffer_dir()
      builtin.live_grep({
        cwd = dir,
        prompt_title = "Live Grep in " .. vim.fn.fnamemodify(dir, ":t")
      })
    end
    
    -- Custom grep_string function that searches in current buffer's directory
    local function grep_string_in_buffer_dir()
      local dir = get_current_buffer_dir()
      builtin.grep_string({
        cwd = dir,
        prompt_title = "Grep String in " .. vim.fn.fnamemodify(dir, ":t")
      })
    end
    
    -- Set up keymaps for the directory-scoped functions
    vim.keymap.set('n', '<leader>ff', find_files_in_buffer_dir, { desc = 'Find files in buffer dir' })
    vim.keymap.set('n', '<leader>fg', live_grep_in_buffer_dir, { desc = 'Live grep in buffer dir' })
    vim.keymap.set('n', '<leader>fs', grep_string_in_buffer_dir, { desc = 'Grep string in buffer dir' })
    
    -- Keep original functions available with different keymaps if needed
    vim.keymap.set('n', '<leader>fF', builtin.find_files, { desc = 'Find files (global)' })
    vim.keymap.set('n', '<leader>fG', builtin.live_grep, { desc = 'Live grep (global)' })
    
    require("config.telescope") -- your separate config file
  end,
}
