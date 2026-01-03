return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    opts = {
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      sort_case_insensitive = false, -- used when sorting files and directories in the tree
      window = {
        position = "left",
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = false, -- Disable to prevent Neo-tree from navigating away from CWD
        },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "..",  -- Hide parent directory entry
          },
        },
        bind_to_cwd = true, -- bind to current working directory
        cwd_target = {
          sidebar = "window", -- use window to bind to current working directory
          current = "window"
        },
        find_by_full_path_words = false,
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        never_show = { -- remains empty to not explicitly hide anything
          -- ".DS_Store",
          -- "thumbs.db"
        },
        never_show_by_pattern = { -- uses glob style patterns
          -- ".null-ls_*",
        },
        window = {
          mappings = {
            ["<bs>"] = "none", -- Disable navigate up to prevent going to parent directories
            ["."] = "none", -- Disable set_root to prevent changing root
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["D"] = "fuzzy_finder_directory",
            ["#"] = "fuzzy_sorter",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
          },
        },
      },
      default_component_configs = {
        container = {
          enable_character_fade = true
        },
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
          -- The next two settings are only a fallback
          default = "*",
          highlight = "NeoTreeFileIcon"
        },
        modified = {
          symbol = "[+]",
          highlight = "NeoTreeModified",
        },
        git_status = {
          symbols = {
            -- Change type
            added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted   = "✖",-- this can only be used in the git_status source
            renamed   = "󰁕",-- this can only be used in the git_status source
            -- Status type
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          }
        },
      },
      commands = {},
      -- no custom event handlers
    },
    config = function(_, opts)
      -- Run Neo-tree migrations before setup to avoid warnings
      require("neo-tree").setup(opts)
      
      -- Apply migrations automatically
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            vim.cmd("Neotree migrations")
          end, 100)
        end,
        once = true,
      })
      
      -- Override Neo-tree commands to always use CWD
      vim.api.nvim_create_user_command('NeotreeCWD', function()
        vim.cmd('Neotree reveal=false dir=' .. vim.fn.getcwd())
      end, {})
    end,
  },
}
