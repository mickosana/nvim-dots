-- Helper functions
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
      context = "buffer", -- Default context
      model = "gpt-4o", -- Default model
      window = { layout = "vertical", width = 0.5 },
      -- Auto include current buffer in context
      auto_insert_mode = false,
      clear_chat_on_new_prompt = false,
      -- Model options (use GitHub Copilot's internal model names)
      models = {
        { name = "gpt-4o", display_name = "GPT-4o (Default)" },
        { name = "claude-3.5-sonnet", display_name = "Claude 3.5 Sonnet" },
        { name = "claude-3.7-sonnet", display_name = "Claude 3.7 Sonnet" },
        { name = "claude-4-sonnet", display_name = "Claude 4 Sonnet" },
        { name = "gemini-2.5-pro", display_name = "Gemini 2.5 Pro" },
        { name = "o3-mini", display_name = "o3 Mini" },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      chat.setup(opts)

      -- Store current model selection
      local current_model = opts.model

      -- Function to get current buffer context with context info only (no content display)
      local function get_buffer_context_info()
        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local line_count = #lines

        local context = "Context: "
        if filename and filename ~= "" then
          local short_name = vim.fn.fnamemodify(filename, ":t")
          context = context .. short_name .. " "
        end
        if filetype and filetype ~= "" then
          context = context .. "(" .. filetype .. ") "
        end
        context = context .. "[" .. line_count .. " lines]\n\n"

        return context, table.concat(lines, "\n")
      end

      -- Function to select model
      local function select_model(callback)
        local model_choices = {}
        for _, model in ipairs(opts.models) do
          local display = model.display_name
          if model.name == current_model then
            display = display .. " ✓"
          end
          table.insert(model_choices, { name = model.name, display = display })
        end

        local display_list = {}
        for _, choice in ipairs(model_choices) do
          table.insert(display_list, choice.display)
        end

        vim.ui.select(display_list, {
          prompt = "🤖 Select AI Model:",
          format_item = function(item)
            return "  " .. item
          end,
        }, function(choice, idx)
          if choice and idx then
            current_model = model_choices[idx].name
            vim.notify("🎯 Model changed to: " .. choice:gsub(" ✓", ""), vim.log.levels.INFO)
            if callback then callback() end
          end
        end)
      end

      -- Ask mode chat function (read-only, no file manipulation, no model selection, no content display)
      local function start_ask_chat_with_context(initial_prompt)
        local context_info, buffer_content = get_buffer_context_info()

        if initial_prompt and initial_prompt ~= "" then
          -- Include full buffer context for better suggestions
          local full_prompt = context_info .. "READ-ONLY ASK MODE: I can see the entire content of your current buffer. Provide suggestions, analysis, and recommendations based on the code.\n\nBuffer content:\n```\n" .. buffer_content .. "\n```\n\nUser request: " .. initial_prompt
          chat.ask(full_prompt, {
            selection = select.buffer,
          })
        else
          -- Open chat window with buffer context pre-loaded
          chat.open()
          vim.schedule(function()
            local chat_buf = vim.api.nvim_get_current_buf()
            if vim.api.nvim_buf_get_option(chat_buf, "filetype") == "copilot-chat" then
              local current_content = vim.api.nvim_buf_get_lines(chat_buf, 0, -1, false)
              local context_with_buffer = context_info .. "READ-ONLY ASK MODE: I can see your entire buffer content and will provide suggestions based on it.\n\nCurrent buffer:\n```\n" .. buffer_content .. "\n```\n\nAsk me anything about your code:\n\n"
              local context_lines = vim.split(context_with_buffer, "\n")

              -- Insert context at the beginning
              for i = #context_lines, 1, -1 do
                table.insert(current_content, 1, context_lines[i])
              end

              vim.api.nvim_buf_set_lines(chat_buf, 0, -1, false, current_content)
              -- Position cursor after context
              vim.api.nvim_win_set_cursor(0, { #context_lines + 1, 0 })
            end
          end)
        end
      end

      -- Agent mode chat function with model selection and file manipulation capabilities
      local function start_agent_chat_with_context(initial_prompt, mode)
        local function do_agent_chat()
          local context = get_buffer_context()
          local agent_context = context .. "AGENT MODE: You can analyze and provide file modification suggestions. Use the edit commands to apply changes.\nMode: " .. mode .. "\n\n"

          if initial_prompt and initial_prompt ~= "" then
            local full_prompt = agent_context .. initial_prompt
            chat.ask(full_prompt, {
              selection = select.buffer,
            })
          else
            -- Open chat window with agent context pre-loaded
            chat.open()
            vim.schedule(function()
              local chat_buf = vim.api.nvim_get_current_buf()
              if vim.api.nvim_buf_get_option(chat_buf, "filetype") == "copilot-chat" then
                local current_content = vim.api.nvim_buf_get_lines(chat_buf, 0, -1, false)
                local context_lines = vim.split(agent_context, "\n")

                -- Insert agent context at the beginning
                for i = #context_lines, 1, -1 do
                  table.insert(current_content, 1, context_lines[i])
                end

                vim.api.nvim_buf_set_lines(chat_buf, 0, -1, false, current_content)
                -- Position cursor after context
                vim.api.nvim_win_set_cursor(0, { #context_lines + 1, 0 })
              end
            end)
          end
        end

        -- Show model selection for agent mode
        select_model(do_agent_chat)
      end

      -- Function to get full buffer context (for agents that need to see code)
      local function get_buffer_context()
        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local content = table.concat(lines, "\n")

        local context = ""
        if filename and filename ~= "" then
          local short_name = vim.fn.fnamemodify(filename, ":t")
          context = context .. "Current file: " .. short_name .. "\n"
        end
        if filetype and filetype ~= "" then
          context = context .. "File type: " .. filetype .. "\n"
        end
        context = context .. "Content:\n```" .. (filetype or "") .. "\n" .. content .. "\n```\n\n"

        return context
      end

      -- Function to get diagnostics for the current buffer
      local function get_buffer_diagnostics(bufnr)
        local diagnostics = vim.diagnostic.get(bufnr)
        local formatted_diagnostics = {}

        for _, diagnostic in ipairs(diagnostics) do
          table.insert(formatted_diagnostics, {
            line = diagnostic.lnum + 1,  -- Convert to 1-based line numbers
            message = diagnostic.message,
            severity = diagnostic.severity
          })
        end

        return formatted_diagnostics
      end

      -- Function to format diagnostics for the prompt
      local function format_diagnostics_prompt(diagnostics)
        if #diagnostics == 0 then
          return ""
        end

        local lines = {"\nCurrent diagnostic issues to fix:"}
        for _, diag in ipairs(diagnostics) do
          local severity = vim.diagnostic.severity[diag.severity] or "INFO"
          table.insert(lines, string.format("Line %d [%s]: %s", diag.line, severity, diag.message))
        end
        return table.concat(lines, "\n")
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
              "╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════",
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

            -- Set up keymaps for closing diff
            vim.keymap.set("n", "q", function()
              if vim.api.nvim_win_is_valid(diff_win) then
                vim.api.nvim_win_close(diff_win, true)
              end
              vim.schedule(function()
                show_action_menu(current_content, new_content, bufnr, original_prompt)
              end)
            end, { buffer = diff_buf, nowait = true, silent = true })

            vim.keymap.set("n", "<Esc>", function()
              if vim.api.nvim_win_is_valid(diff_win) then
                vim.api.nvim_win_close(diff_win, true)
              end
              vim.schedule(function()
                show_action_menu(current_content, new_content, bufnr, original_prompt)
              end)
            end, { buffer = diff_buf, nowait = true, silent = true })

          elseif choice:match("Edit prompt and retry") then
            local new_prompt = vim.fn.input("✏️  Edit prompt: ", original_prompt)
            if new_prompt and vim.trim(new_prompt) ~= "" then
              -- Directly call the edit function instead of using vim.cmd
              local function retry_edit()
                local current_buffer_content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
                local buffer_context = get_buffer_context()

                -- Enhanced agent prompt with context
                local edit_prompt = string.format([[%s

AGENT MODE: You can modify files directly. Apply the following changes to the code:
%s

Return ONLY the complete modified code, no metadata or file paths.]], buffer_context, new_prompt)

                vim.notify("🤖 Agent processing changes with " .. current_model .. "...", vim.log.levels.INFO)

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

                      local cleaned_content = clean_response_content(response_text)

                      if vim.trim(cleaned_content) == "" then
                        vim.notify("No valid content after cleaning", vim.log.levels.ERROR)
                        return
                      end

                      show_action_menu(current_buffer_content, cleaned_content, bufnr, new_prompt)
                    end)
                  end,
                })
              end

              -- Use model selection for retry just like the original command
              select_model(retry_edit)
            else
              vim.notify("❌ Operation cancelled", vim.log.levels.WARN)
            end
          end
        end)
      end

      -- Agent mode buffer editing command with model selection
      vim.api.nvim_create_user_command("CopilotEditBuffer", function(cmd_opts)
        local function do_edit()
          local bufnr = vim.api.nvim_get_current_buf()
          if not vim.api.nvim_buf_is_valid(bufnr) then
            vim.notify("Invalid buffer", vim.log.levels.ERROR)
            return
          end

          local current_content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
          local buffer_context = get_buffer_context()
          local diagnostics = get_buffer_diagnostics(bufnr)
          local diagnostics_prompt = format_diagnostics_prompt(diagnostics)

          local prompt = vim.trim(cmd_opts.args or "")
          if prompt == "" then
            prompt = vim.fn.input("Describe changes: ")
            if prompt == "" then
              vim.notify("No changes requested", vim.log.levels.WARN)
              return
            end
          end

          -- Enhanced agent prompt with context and diagnostics
          local edit_prompt = string.format([[%s

AGENT MODE: You can modify files directly. Apply the following changes to the code and ensure to fix any linting/diagnostic issues.%s

User requested changes:
%s

Return ONLY the complete modified code, no metadata or file paths. Ensure the changes fix both the user's request and any diagnostic issues.]], buffer_context, diagnostics_prompt, prompt)

          vim.notify("🤖 Agent processing changes with " .. current_model .. "...", vim.log.levels.INFO)

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

                local cleaned_content = clean_response_content(response_text)

                if vim.trim(cleaned_content) == "" then
                  vim.notify("No valid content after cleaning", vim.log.levels.ERROR)
                  return
                end

                -- Modified action menu to include diagnostic validation
                local function check_remaining_diagnostics(new_content, bufnr)
                  -- Apply changes temporarily to a new buffer to check diagnostics
                  local temp_bufnr = vim.api.nvim_create_buf(false, true)
                  local new_lines = vim.split(new_content, "\n", { plain = true })
                  vim.api.nvim_buf_set_lines(temp_bufnr, 0, -1, false, new_lines)

                  -- Copy over file type and other relevant settings
                  vim.api.nvim_buf_set_option(temp_bufnr, "filetype",
                    vim.api.nvim_buf_get_option(bufnr, "filetype"))

                  -- Wait briefly for diagnostics to be generated
                  vim.defer_fn(function()
                    local new_diagnostics = get_buffer_diagnostics(temp_bufnr)
                    vim.api.nvim_buf_delete(temp_bufnr, { force = true })

                    if #new_diagnostics > 0 then
                      return new_diagnostics
                    end
                    return nil
                  end, 100)
                end

                show_action_menu(current_content, cleaned_content, bufnr, prompt)
              end)
            end,
          })
        end

        select_model(do_edit)
      end, {
        nargs = "?",
        desc = "Agent mode - Edit current buffer with Copilot (includes diagnostic fixes)"
      })

      -- Agent mode ask command with model selection
      vim.api.nvim_create_user_command("CopilotAgentAsk", function(cmd_opts)
        local prompt = cmd_opts.args
        if not prompt or vim.trim(prompt) == "" then
          prompt = vim.fn.input("Agent Ask: ")
        end
        if prompt and vim.trim(prompt) ~= "" then
          start_agent_chat_with_context(prompt, "Agent Ask")
        end
      end, {
        nargs = "*",
        desc = "Agent mode - Ask Copilot with file manipulation capabilities"
      })

      -- Commands for different modes
      vim.api.nvim_create_user_command("CopilotChat", function()
        start_ask_chat_with_context()
      end, { desc = "READ-ONLY mode - Chat with file context, suggestions only (no model selection)" })

      vim.api.nvim_create_user_command("CopilotChatAsk", function(cmd_opts)
        local prompt = cmd_opts.args
        if not prompt or vim.trim(prompt) == "" then
          prompt = vim.fn.input("Ask Copilot (read-only): ")
        end
        if prompt and vim.trim(prompt) ~= "" then
          start_ask_chat_with_context(prompt)
        end
      end, {
        nargs = "*",
        desc = "READ-ONLY mode - Ask with file context, suggestions only (no model selection)"
      })

      vim.api.nvim_create_user_command("CopilotModel", function()
        select_model()
      end, { desc = "Select Copilot model" })

      -- Enhanced keymaps with distinct modes
      vim.keymap.set("n", "<leader>cc", "<Cmd>CopilotChat<CR>", {
        silent = true,
        desc = "Ask mode - Copilot chat"
      })

      vim.keymap.set("n", "<leader>cca", "<Cmd>CopilotAgentAsk<CR>", {
        silent = true,
        desc = "Agent mode - Ask with file manipulation"
      })

      vim.keymap.set("n", "<leader>cce", "<Cmd>CopilotEditBuffer<CR>", {
        silent = true,
        desc = "Agent mode - Edit buffer"
      })

      vim.keymap.set("n", "<leader>cm", "<Cmd>CopilotModel<CR>", {
        silent = true,
        desc = "Select Copilot model"
      })

      -- Visual mode keymap for agent asking about selection
      vim.keymap.set("v", "<leader>cca", function()
        local function do_ask()
          local prompt = vim.fn.input("Agent ask about selection: ")
          if prompt and vim.trim(prompt) ~= "" then
            local context = get_buffer_context()
            local agent_prompt = context .. "\nAGENT MODE: Can modify files\n\n" .. prompt
            chat.ask(agent_prompt, { selection = select.visual })
          end
        end
        select_model(do_ask)
      end, {
        desc = "Agent mode - Ask about selection"
      })

      -- Visual mode keymap for basic asking about selection (no model selection, no content display)
      vim.keymap.set("v", "<leader>cc", function()
        local prompt = vim.fn.input("Ask about selection: ")
        if prompt and vim.trim(prompt) ~= "" then
          local context_info, _ = get_buffer_context_info()
          local ask_prompt = context_info .. "READ-ONLY MODE: I can see your selected code.\n\n" .. prompt
          chat.ask(ask_prompt, { selection = select.visual })
        end
      end, {
        desc = "READ-ONLY mode - Ask about selection"
      })
    end,
  },
}
