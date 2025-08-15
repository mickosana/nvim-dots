return {
  "folke/tokyonight.nvim",
  lazy = false,              -- load at startup since it's your main colorscheme
  priority = 1000,           -- high priority so it's applied early
  opts = {
    style = "storm",         -- choose from "storm", "moon", "night", "day"
    transparent = false,     -- set true if you prefer no background
    dim_inactive = false,    -- dims inactive windows
    lualine_bold = true,     -- bold headers for lualine
    on_colors = function(colors) end,
    on_highlights = function(highlights, colors) end,
    plugins = {
      all = true,            -- automatically enable highlight support for many plugins
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd([[colorscheme tokyonight]])
  end,
}
