-- Bootstrap and initialize lazy.nvim first
require("config.lazy")

-- Set basic vim options
require("config.options")

-- Initialize colorscheme last, after plugins are loaded
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    require("config.colorscheme").init()
  end,
})
