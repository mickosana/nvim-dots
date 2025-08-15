return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      debug = false,
      context = "buffer",
      window = { layout = "vertical", width = 0.5 },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      chat.setup(opts)

      -- Aggressive metadata stripping function
      local function clean_response_content(text)
        if not text or text == "" then
          return ""
        end

        local content = text
        
        -- Remove code block wrappers
        content = content:gsub("```[%w%-_]*\n(.-)\n```", "%1")
        content = content:gsub("^%s*```[%w%-_]*%s*\n?", "")
        content = content:gsub("\n?```%s*$", "")
        
        local lines = vim.split(content, "\n", { plain = true })
        local clean_lines = {}
        local started = false
        
        for _, line in ipairs(lines) do
          local trimmed = vim.trim(line)
          
          -- Skip metadata patterns
          local is_metadata = (
            trimmed:match("^[Ff]ile%s*[:=]") or
            trimmed:match("^[Pp]ath%s*[:=]") or
            trimmed:match("^[Ff]ilepath%s*[:=]") or
            trimmed:match("^[Tt]ext%s*[:=]") or
            trimmed:match("^[Ss]ource%s*[:=]") or
            trimmed:match("^[Cc]ontent%s*[:=]") or
            trimmed:match("^%w+%s*[:=]%s*[%w/._%-]+$") or -- key=value pairs
            trimmed:match("^[%w/._%-]+%.[%w]+$") and not trimmed:match("%s") or -- standalone filenames
            trimmed:match("^%-%-%-+") or -- separator lines
            trimmed:match("^===+") or
            (trimmed == "" and not started) -- leading empty lines
          )
          
          if not is_metadata then
            started = true
            table.insert(clean_lines, line)
          elseif started and trimmed == "" then
            -- Keep empty lines after content starts
            table.insert(clean_lines, line)
          end
        end
        
        -- Remove trailing empty lines
        while #clean_lines > 0 and vim.trim(clean_lines[#clean_lines]) == "" do
          table.remove(clean_lines)
        end
        
        return table.concat(clean_lines, "\n")
      end

      -- Action menu for handling changes
      local function show_action_menu(current_content, new_content, bufnr, original_prompt)
        local choices = {
          "Apply changes",
          "Cancel",
          "Show diff preview",
          "Edit prompt and retry"
        }
        
        vim.ui.select(choices, {
          prompt = "Copilot changes ready:",
          format_item = function(item)
            return item
          end,
        }, function(choice)
          if not choice then
            vim.notify("❌ Changes cancelled", vim.log.levels.WARN)
            return
          end
          
          if choice == "Apply changes" then
            local new_lines = vim.split(new_content, "\n", { plain = true })
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
            vim.api.nvim_buf_set_option(bufnr, "modified", true)
            vim.notify("✅ Changes applied successfully", vim.log.levels.INFO)
            
          elseif choice == "Cancel" then
            vim.notify("❌ Changes cancelled", vim.log.levels.WARN)
            
          elseif choice == "Show diff preview" then
            -- Create simple diff buffer
            local diff_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_name(diff_buf, "Diff Preview")
            
            local current_lines = vim.split(current_content, "\n", { plain = true })
            local new_lines = vim.split(new_content, "\n", { plain = true })
            
            local diff_content = {
              "Diff Preview - Press 'q' to close",
              "=" .. string.rep("=", 40),
              "",
              "CURRENT (" .. #current_lines .. " lines):",
              "---"
            }
            
            -- Show first 10 lines of current
            for i = 1, math.min(10, #current_lines) do
              table.insert(diff_content, "  " .. (current_lines[i] or ""))
            end
            
            if #current_lines > 10 then
              table.insert(diff_content, "  ... (" .. (#current_lines - 10) .. " more lines)")
            end
            
            table.insert(diff_content, "")
            table.insert(diff_content, "NEW (" .. #new_lines .. " lines):")
            table.insert(diff_content, "---")
            
            -- Show first 10 lines of new
            for i = 1, math.min(10, #new_lines) do
              table.insert(diff_content, "  " .. (new_lines[i] or ""))
            end
            
            if #new_lines > 10 then
              table.insert(diff_content, "  ... (" .. (#new_lines - 10) .. " more lines)")
            end
            
            vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, diff_content)
            vim.api.nvim_buf_set_option(diff_buf, "buftype", "nofile")
            vim.api.nvim_buf_set_option(diff_buf, "bufhidden", "wipe")
            vim.api.nvim_buf_set_option(diff_buf, "modifiable", false)
            
            local width = math.min(vim.o.columns - 10, 80)
            local height = math.min(#diff_content + 4, math.floor(vim.o.lines * 0.7))
            local diff_win = vim.api.nvim_open_win(diff_buf, true, {
              relative = "editor",
              width = width,
              height = height,
              row = math.floor((vim.o.lines - height) / 2),
              col = math.floor((vim.o.columns - width) / 2),
              style = "minimal",
              border = "rounded",
              title = " Diff Preview ",
              title_pos = "center",
            })
            
            vim.keymap.set("n", "q", function()
              if vim.api.nvim_win_is_valid(diff_win) then
                vim.api.nvim_win_close(diff_win, true)
              end
              -- Show action menu again
              show_action_menu(current_content, new_content, bufnr, original_prompt)
            end, { buffer = diff_buf, nowait = true, silent = true })
            
          elseif choice == "Edit prompt and retry" then
            local new_prompt = vim.fn.input("Edit prompt: ", original_prompt)
            if new_prompt and new_prompt ~= "" then
              vim.cmd("CopilotEditBuffer " .. new_prompt)
            else
              vim.notify("❌ Changes cancelled", vim.log.levels.WARN)
            end
          end
        end)
      end

      -- Simple buffer editing command
      vim.api.nvim_create_user_command("CopilotEditBuffer", function(cmd_opts)
        local bufnr = vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          vim.notify("Invalid buffer", vim.log.levels.ERROR)
          return
        end

        local current_content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
        
        local prompt = vim.trim(cmd_opts.args or "")
        if prompt == "" then
          prompt = vim.fn.input("Describe changes: ")
          if prompt == "" then
            vim.notify("No changes requested", vim.log.levels.WARN)
            return
          end
        end

        -- Enhanced prompt that prevents file path inclusion
        local edit_prompt = string.format([[You are a code editor. Apply the requested changes and return ONLY the complete modified code.

STRICT RULES:
- Return ONLY code content, no file paths or metadata
- Do not include any headers, file names, or descriptions
- Do not add comments about the file location
- Start your response immediately with the actual code

Code to modify:
%s

Requested changes: %s

Modified code:]], current_content, prompt)

        vim.notify("🤖 Processing changes...", vim.log.levels.INFO)

        chat.ask(edit_prompt, {
          selection = select.none,
          callback = function(response)
            vim.schedule(function()
              local response_text = response
              if type(response) == "table" and response.content then
                response_text = response.content
              end

              if not response_text or vim.trim(response_text) == "" then
                vim.notify("Empty response from Copilot", vim.log.levels.ERROR)
                return
              end

              -- Clean the response aggressively
              local cleaned_content = clean_response_content(response_text)
              
              if vim.trim(cleaned_content) == "" then
                vim.notify("No valid content after cleaning", vim.log.levels.ERROR)
                return
              end

              -- Show action menu instead of preview
              show_action_menu(current_content, cleaned_content, bufnr, prompt)
            end)
          end,
        })
      end, { 
        nargs = "?", 
        desc = "Edit current buffer with Copilot" 
      })

      -- Single keymap for buffer editing
      vim.keymap.set("n", "<leader>ce", "<Cmd>CopilotEditBuffer<CR>", { 
        silent = true, 
        desc = "Copilot edit buffer" 
      })
    end,
  },
}
