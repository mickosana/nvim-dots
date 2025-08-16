return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "│",
      highlight = {
        "IBLIndent1",
        "IBLIndent2",
        "IBLIndent3",
        "IBLIndent4",
        "IBLIndent5",
        "IBLIndent6",
      },
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = false,
      injected_languages = true,
      highlight = { "Function", "Label" },
      priority = 500,
    },
  },
  config = function(_, opts)
    -- Set custom colors for indent lines to match Tokyo Night theme BEFORE ibl setup
    vim.cmd [[
      highlight default IBLIndent1 guifg=#7aa2f7 gui=nocombine
      highlight default IBLIndent2 guifg=#bb9af7 gui=nocombine
      highlight default IBLIndent3 guifg=#7dcfff gui=nocombine
      highlight default IBLIndent4 guifg=#e0af68 gui=nocombine
      highlight default IBLIndent5 guifg=#9ece6a gui=nocombine
      highlight default IBLIndent6 guifg=#f7768e gui=nocombine
    ]]
    require("ibl").setup(opts)
  end,
}
