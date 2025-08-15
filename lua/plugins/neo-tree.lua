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
          enabled = true, -- enable to follow the current file
        },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        bind_to_cwd = true, -- changed back to true to show only current working directory
        cwd_target = {
          sidebar = "tab", -- sidebar is the tree on the side
          current = "window" -- current is the content of the buffer
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
            ["cd"] = {
              command = function(state)
                local node = state.tree:get_node()
                if node.type == "directory" then
                  require("neo-tree.sources.filesystem").navigate(state, nil, node.path)
                end
              end,
              desc = "CD into directory",
            },
            ["<C-h>"] = {
              command = function(state)
                require("neo-tree.sources.filesystem").navigate(state, vim.fn.getcwd())
              end,
              desc = "Return to current working directory",
            },
          },
        },
        -- Only show the current directory, remove parent directories
        discovery = {
          max_depth = 10, -- Allow showing children to reasonable depth
        },
        -- Force the root directory to always be the CWD
        cwd_root = true, -- Critical setting to only show CWD
        no_parent_dir = true, -- Don't show parent directories
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
    end,
  },
}
