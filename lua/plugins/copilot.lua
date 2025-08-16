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
        local current_lines = vim.split(current_content, "\n", { plain = true })
        local new_lines = vim.split(new_content, "\n", { plain = true })
        
        local changes_summary = string.format("📝 %d → %d lines", #current_lines, #new_lines)
        
        local choices = {
          "✅ Apply changes",
          "❌ Cancel", 
          "🔍 Show diff preview",
          "✏️  Edit prompt and retry"
        }
        
        vim.ui.select(choices, {
          prompt = changes_summary .. " - Select action:",
          format_item = function(item)
            return item
          end,
        }, function(choice)
          if not choice then
            vim.notify("❌ Operation cancelled", vim.log.levels.WARN)
            return
          end
          
          if choice:match("Apply changes") then
            local new_lines = vim.split(new_content, "\n", { plain = true })
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
            vim.api.nvim_buf_set_option(bufnr, "modified", true)
            vim.notify("✅ Changes applied successfully", vim.log.levels.INFO)
            
          elseif choice:match("Cancel") then
            vim.notify("❌ Changes cancelled", vim.log.levels.WARN)
            
          elseif choice:match("Show diff preview") then
            -- Create professional git-style diff buffer
            local diff_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_name(diff_buf, "Diff Preview")
            
            local current_lines = vim.split(current_content, "\n", { plain = true })
            local new_lines = vim.split(new_content, "\n", { plain = true })
            
            -- Always show complete file comparison
            local diff_content = {
              "Git-style Diff Preview",
              "═══════════════════════════════════════════════════════════════════════════════",
              "",
              "Complete File with Changes:",
              ""
            }
            
            -- Create comprehensive diff showing ALL lines
            local max_lines = math.max(#current_lines, #new_lines)
            local line_num = 1
            
            -- Process all lines to show complete context
            while line_num <= max_lines do
              local current_line = current_lines[line_num]
              local new_line = new_lines[line_num]
              
              if current_line and new_line then
                if current_line == new_line then
                  -- Unchanged line - show with space prefix
                  table.insert(diff_content, " " .. current_line)
                else
                  -- Changed line - show both versions
                  table.insert(diff_content, "-" .. current_line)
                  table.insert(diff_content, "+" .. new_line)
                end
              elseif current_line and not new_line then
                -- Line exists in current but not in new (deleted)
                table.insert(diff_content, "-" .. current_line)
              elseif not current_line and new_line then
                -- Line exists in new but not in current (added)
                table.insert(diff_content, "+" .. new_line)
              end
              
              line_num = line_num + 1
            end
            
            -- If files are very different, also try vim.diff as backup info
            local vim_diff_ok, vim_hunks = pcall(vim.diff, current_content, new_content, {
              result_type = "unified",
              algorithm = "myers",
              context = 1000,  -- Show lots of context
            })
            
            if vim_diff_ok and vim_hunks and vim_hunks ~= "" and #current_lines > 10 then
              -- For larger files, prefer vim.diff output but ensure it's complete
              local vim_lines = vim.split(vim_hunks, "\n", { plain = true })
              local has_context = false
              
              -- Check if vim.diff is showing context lines
              for _, line in ipairs(vim_lines) do
                if line:match("^%s") and not line:match("^@@") then
                  has_context = true
                  break
                end
              end
              
              if has_context then
                -- Use vim.diff output since it has proper context
                diff_content = {
                  "Git-style Diff Preview", 
                  "═══════════════════════════════════════════════════════════════════════════════",
                  ""
                }
                
                for _, line in ipairs(vim_lines) do
                  if line ~= "" then
                    table.insert(diff_content, line)
                  end
                end
              end
            end
            
            vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, diff_content)
            vim.api.nvim_buf_set_option(diff_buf, "buftype", "nofile")
            vim.api.nvim_buf_set_option(diff_buf, "bufhidden", "wipe")
            vim.api.nvim_buf_set_option(diff_buf, "modifiable", false)
            vim.api.nvim_buf_set_option(diff_buf, "filetype", "diff")
            
            -- Create professional floating window
            local width = math.min(vim.o.columns - 6, 120)
            local height = math.min(#diff_content + 6, math.floor(vim.o.lines * 0.85))
            local diff_win = vim.api.nvim_open_win(diff_buf, true, {
              relative = "editor",
              width = width,
              height = height,
              row = math.floor((vim.o.lines - height) / 2),
              col = math.floor((vim.o.columns - width) / 2),
              style = "minimal",
              border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
              title = "  Changes Preview - All Lines  ",
              title_pos = "center",
            })
            
            -- Set up professional diff highlighting
            vim.api.nvim_win_set_option(diff_win, "winhl", "Normal:Normal,FloatBorder:FloatBorder")
            
            -- Create custom highlight groups for diff
            vim.api.nvim_set_hl(0, "DiffRemoved", { bg = "#3c1f1e", fg = "#f85149" })
            vim.api.nvim_set_hl(0, "DiffAdded", { bg = "#1f2f1f", fg = "#56d364" })
            vim.api.nvim_set_hl(0, "DiffContext", { bg = "NONE", fg = "#8b949e" })
            vim.api.nvim_set_hl(0, "DiffHeader", { bg = "#21262d", fg = "#58a6ff", bold = true })
            
            -- Apply highlighting to diff lines
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(diff_buf) then
                local ns_id = vim.api.nvim_create_namespace("copilot_diff")
                
                for i, line in ipairs(diff_content) do
                  local line_idx = i - 1  -- 0-based indexing
                  
                  if line:match("^@@") then
                    -- Hunk headers
                    vim.api.nvim_buf_add_highlight(diff_buf, ns_id, "DiffHeader", line_idx, 0, -1)
                  elseif line:match("^%-") then
                    -- Removed lines
                    vim.api.nvim_buf_add_highlight(diff_buf, ns_id, "DiffRemoved", line_idx, 0, -1)
                  elseif line:match("^%+") then
                    -- Added lines
                    vim.api.nvim_buf_add_highlight(diff_buf, ns_id, "DiffAdded", line_idx, 0, -1)
                  elseif line:match("^%s") and not line:match("^%s*$") and not line:match("^═") and not line:match("Complete File") then
                    -- Context lines (unchanged lines with space prefix, but not headers)
                    vim.api.nvim_buf_add_highlight(diff_buf, ns_id, "DiffContext", line_idx, 0, -1)
                  end
                end
              end
            end)
            
            -- Professional status line
            vim.api.nvim_buf_set_var(diff_buf, "current_syntax", "diff")
            
            -- Keymapping with better feedback
            vim.keymap.set("n", "q", function()
              if vim.api.nvim_win_is_valid(diff_win) then
                vim.api.nvim_win_close(diff_win, true)
              end
              -- Ensure we're in the correct window and buffer
              local current_win = vim.api.nvim_get_current_win()
              local target_win = nil
              
              -- Find window containing our target buffer
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == bufnr then
                  target_win = win
                  break
                end
              end
              
              if target_win then
                vim.api.nvim_set_current_win(target_win)
              else
                -- Create new window if none exists
                vim.cmd("buffer " .. bufnr)
              end
              
              -- Show action menu again
              vim.schedule(function()
                show_action_menu(current_content, new_content, bufnr, original_prompt)
              end)
            end, { buffer = diff_buf, nowait = true, silent = true, desc = "Close diff and return to menu" })
            
            vim.keymap.set("n", "<Esc>", function()
              if vim.api.nvim_win_is_valid(diff_win) then
                vim.api.nvim_win_close(diff_win, true)
              end
              -- Ensure we're in the correct window and buffer
              local current_win = vim.api.nvim_get_current_win()
              local target_win = nil
              
              -- Find window containing our target buffer
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == bufnr then
                  target_win = win
                  break
                end
              end
              
              if target_win then
                vim.api.nvim_set_current_win(target_win)
              else
                -- Create new window if none exists
                vim.cmd("buffer " .. bufnr)
              end
              
              vim.schedule(function()
                show_action_menu(current_content, new_content, bufnr, original_prompt)
              end)
            end, { buffer = diff_buf, nowait = true, silent = true, desc = "Close diff and return to menu" })
            
          elseif choice:match("Edit prompt and retry") then
            local new_prompt = vim.fn.input("✏️  Edit prompt: ", original_prompt)
            if new_prompt and vim.trim(new_prompt) ~= "" then
              vim.cmd("CopilotEditBuffer " .. vim.fn.escape(new_prompt, ' "\\'))
            else
              vim.notify("❌ Operation cancelled", vim.log.levels.WARN)
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
