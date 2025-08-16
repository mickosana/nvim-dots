-- Configuration for the colorscheme
local M = {}

function M.init()
  -- Set up any color-related vim options
  vim.opt.termguicolors = true

  -- Protected call to load the colorscheme
  local status_ok = pcall(function()
    vim.opt.background = 'dark'
    vim.cmd.colorscheme('tokyonight')
  end)

  if not status_ok then
    -- Fallback to a basic colorscheme if tokyonight fails to load
    vim.cmd.colorscheme('habamax')
    vim.notify("Failed to load tokyonight theme, using fallback", vim.log.levels.WARN)
  end
end

return M
