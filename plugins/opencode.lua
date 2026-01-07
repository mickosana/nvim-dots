return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { "folke/snacks.nvim", lazy = false, priority = 1000, opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      contexts = {
        -- Override default contexts to only include files within CWD
        ["@this"] = function(context) return context:this() end,
        ["@buffer"] = function(context) 
          local buf_path = vim.api.nvim_buf_get_name(context.buf)
          local cwd = vim.fn.getcwd()
          -- Only return buffer if it's within CWD
          if buf_path:sub(1, #cwd) == cwd then
            return context:buffer()
          end
          return nil
        end,
        ["@buffers"] = function(context)
          local file_list = {}
          local cwd = vim.fn.getcwd()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) 
               and vim.api.nvim_get_option_value("buftype", { buf = buf }) == ""
               and vim.api.nvim_buf_get_name(buf) ~= "" then
              local buf_path = vim.api.nvim_buf_get_name(buf)
              -- Only include buffers within CWD
              if buf_path:sub(1, #cwd) == cwd then
                local Context = require("opencode.context")
                local path = Context.format({ buf = buf })
                if path then
                  table.insert(file_list, path)
                end
              end
            end
          end
          if #file_list == 0 then
            return nil
          end
          return table.concat(file_list, " ")
        end,
        ["@visible"] = function(context)
          local visible = {}
          local cwd = vim.fn.getcwd()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_is_loaded(buf)
               and vim.api.nvim_get_option_value("buftype", { buf = buf }) == ""
               and vim.api.nvim_buf_get_name(buf) ~= "" then
              local buf_path = vim.api.nvim_buf_get_name(buf)
              -- Only include visible windows within CWD
              if buf_path:sub(1, #cwd) == cwd then
                local Context = require("opencode.context")
                local start_line = vim.fn.line("w0", win)
                local end_line = vim.fn.line("w$", win)
                table.insert(
                  visible,
                  Context.format({
                    buf = buf,
                    start_line = start_line,
                    end_line = end_line,
                  })
                )
              end
            end
          end
          if #visible == 0 then
            return nil
          end
          return table.concat(visible, " ")
        end,
        ["@diagnostics"] = function(context) return context:diagnostics() end,
        ["@quickfix"] = function(context) return context:quickfix() end,
        ["@diff"] = function(context) 
          -- Get git diff only for current directory
          local cwd = vim.fn.getcwd()
          local handle = io.popen("cd " .. vim.fn.shellescape(cwd) .. " && git --no-pager diff")
          if not handle then
            return nil
          end
          local result = handle:read("*a")
          handle:close()
          if result and result ~= "" then
            return result
          end
          return nil
        end,
        ["@grapple"] = function(context) return context:grapple_tags() end,
        -- Add a new context for CWD
        ["@cwd"] = function(context)
          return "Current working directory: " .. vim.fn.getcwd()
        end,
      },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    -- OpenCode keymaps using leader key
    vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end, { desc = "Execute opencode action" })
    vim.keymap.set({ "n", "t" }, "<leader>oo", function() require("opencode").toggle() end, { desc = "Toggle opencode" })

    -- Add range/line to opencode
    vim.keymap.set({ "n", "x" }, "<leader>or", function() return require("opencode").operator("@this ") end, { expr = true, desc = "Add range to opencode" })
    vim.keymap.set("n", "<leader>ol", function() return require("opencode").operator("@this ") .. "_" end, { expr = true, desc = "Add line to opencode" })

    -- OpenCode session navigation
    vim.keymap.set("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end, { desc = "OpenCode half page up" })
    vim.keymap.set("n", "<leader>od", function() require("opencode").command("session.half.page.down") end, { desc = "OpenCode half page down" })
  end,
}
