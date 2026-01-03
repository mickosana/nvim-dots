return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    -- Load colorscheme here to ensure it's loaded before any other plugins
    vim.cmd([[colorscheme tokyonight]])
  end,
  opts = {
    style = "night",
    light_style = "day",
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      sidebars = "dark",
      floats = "dark",
    },
    sidebars = { "qf", "help" },
    day_brightness = 0.3,
    hide_inactive_statusline = false,
    dim_inactive = false,
    lualine_bold = false,

    on_colors = function(colors)
      colors.bg = "#1a1b26"
      colors.bg_dark = "#16161e"
      colors.blue = "#7aa2f7"
      colors.cyan = "#7dcfff"
      colors.purple = "#bb9af7"
      colors.orange = "#ff9e64"
      colors.yellow = "#e0af68"
      colors.green = "#9ece6a"
      colors.red = "#f7768e"
      colors.comment = "#565f89"
    end,

    on_highlights = function(hl, c)
      local util = require("tokyonight.util")

      -- Core syntax elements
      hl.Keyword = { fg = c.purple, italic = true }
      hl.Function = { fg = c.blue }
      hl.String = { fg = c.green }
      hl.Number = { fg = c.orange }
      hl.Comment = { fg = c.comment, italic = true }

      -- Line numbers and gutter
      hl.LineNr = { fg = "#3b4261" }
      hl.CursorLineNr = { fg = c.orange, bold = true }

      -- Editor elements
      hl.Normal = { bg = c.bg }
      hl.NormalFloat = { bg = c.bg_dark }
      hl.FloatBorder = { bg = c.bg_dark, fg = c.blue }

      -- Status and tab lines
      hl.StatusLine = { bg = c.bg_dark, fg = c.fg }
      hl.StatusLineNC = { bg = c.bg_dark, fg = c.fg_dark }

      -- Search and selection
      hl.Search = { bg = util.darken(c.blue, 0.8), fg = c.fg }
      hl.IncSearch = { bg = c.orange, fg = c.bg }

      -- Diagnostic elements
      hl.DiagnosticError = { fg = c.red }
      hl.DiagnosticWarn = { fg = c.yellow }
      hl.DiagnosticInfo = { fg = c.blue }
      hl.DiagnosticHint = { fg = c.cyan }
    end,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    -- Enable true color support and cursor line highlighting
    vim.opt.termguicolors = true
    vim.opt.cursorline = true
  end,
}
