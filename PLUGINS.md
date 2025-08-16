# Neovim Plugins, Commands, Options, and Shortcuts

This document summarizes the plugins configured in your Neovim setup, how to use them, and the important options and shortcuts wired in your config.

## Notes
- Leader-based mappings below use your current `<leader>` (as configured in your options).
- Your configuration includes a comprehensive setup for both development workflows and AI assistance.

## Plugins

### GitHub Copilot Integration

#### GitHub Copilot: zbirenbaum/copilot.lua
- Purpose: GitHub Copilot integration for code completion.
- Status: Suggestions and panel disabled (handled by CopilotChat instead).
- Commands:
  - `:Copilot setup` to authenticate
  - `:Copilot status` to check connection/user
- Configuration:
  - `suggestion.enabled = false`
  - `panel.enabled = false`

#### Copilot Chat: CopilotC-Nvim/CopilotChat.nvim
- Purpose: Advanced AI chat interface with multiple modes and model selection.
- Dependencies: `zbirenbaum/copilot.lua`, `nvim-lua/plenary.nvim`
- Configuration:
  - Default model: `gpt-4o`
  - Window layout: vertical, 50% width
  - Context: buffer (automatically includes current buffer)

##### Available Models
- `gpt-4o` (Default)
- `claude-3.5-sonnet`
- `claude-3.7-sonnet` 
- `claude-4-sonnet`
- `gemini-2.5-pro`
- `o3-mini`

##### Key Mappings

**Normal Mode:**
- `<leader>cc`: **Ask Mode** - Read-only chat with full buffer context, provides suggestions and analysis
- `<leader>cca`: **Agent Mode** - Ask with file manipulation capabilities (includes model selection)
- `<leader>cce`: **Agent Mode** - Edit current buffer with AI assistance (includes model selection)
- `<leader>cm`: Select AI model

**Visual Mode:**
- `<leader>cc`: Ask about selected code (read-only mode)
- `<leader>cca`: Agent ask about selection (with file manipulation capabilities)

##### Chat Modes

**Ask Mode (`<leader>cc`)**
- **Purpose**: Read-only analysis and suggestions
- **Features**: 
  - Can see entire buffer content
  - Provides suggestions, analysis, and recommendations
  - No file modification capabilities
  - No model selection (uses default)
  - Contextual suggestions based on your code

**Agent Mode (`<leader>cca`, `<leader>cce`)**
- **Purpose**: Interactive file editing and manipulation
- **Features**:
  - Model selection dialog
  - Can modify files directly
  - Advanced action menu with options:
    - ✅ Apply changes
    - ❌ Cancel
    - 🔍 Show diff preview (git-style)
    - ✏️ Edit prompt and retry
  - Professional diff preview with complete file comparison
  - Aggressive metadata stripping for clean code output

##### Commands
- `:CopilotChat` - Open ask mode chat
- `:CopilotChatAsk [prompt]` - Ask mode with optional prompt
- `:CopilotEditBuffer [prompt]` - Agent mode buffer editing
- `:CopilotAgentAsk [prompt]` - Agent mode asking
- `:CopilotModel` - Select AI model

### File Navigation and Project Management

#### Neo-tree: nvim-neo-tree/neo-tree.nvim
- Purpose: File explorer and project management
- Dependencies: `plenary.nvim`, `nui.nvim`, `nvim-web-devicons`
- Key Features:
  - Position: Left side of the screen with 30 column width
  - Git status integration enabled
  - Diagnostics integration enabled
  - Case-sensitive file/directory sorting
  - Current file following enabled
  - Dotfiles and gitignored files visible
  - OS-level file watcher enabled for real-time updates
  - Binds to current working directory

#### Telescope: nvim-telescope/telescope.nvim
- Purpose: Fuzzy finder for files, buffers, and text patterns
- Dependencies: `plenary.nvim`
- Custom Functions:
  - Context-aware searches that use current buffer's directory
  - Directory-scoped file finding and text searches
- Key Mappings:
  - `<leader>ff`: Find files in current buffer's directory
  - `<leader>fg`: Live grep in current buffer's directory
  - `<leader>fs`: Grep current word in buffer's directory
  - `<leader>fF`: Find files globally (workspace-wide)

### Code Enhancement

#### Treesitter: nvim-treesitter/nvim-treesitter
- Purpose: Advanced syntax highlighting and code navigation
- Configuration:
  - Syntax highlighting and indentation enabled
  - Extensive language support (40+ languages) including:
    - Web: HTML, CSS, JavaScript, TypeScript, Vue, etc.
    - Backend: Python, Go, Rust, Java, C/C++, etc.
    - Database: SQL, GraphQL
    - Config/DevOps: YAML, TOML, Terraform, etc.
    - Documentation: Markdown, LaTeX

#### Rainbow Delimiters: HiPhish/rainbow-delimiters.nvim
- Purpose: Color-coded bracket and delimiter highlighting
- Configuration:
  - Global strategy for most file types
  - Local strategy for Vim files
  - Custom rainbow blocks for Lua
  - 7-color palette for different nesting levels

#### Linting: mfussenegger/nvim-lint
- Purpose: Integrated code linting
- Configuration:
  - Runs on file save
  - Language-specific linters configured:
    - Web: eslint_d, stylelint, jsonlint
    - Backend: flake8, luacheck, golangci_lint, clippy, etc.
    - DevOps: yamllint, hadolint, tflint
    - Documentation: markdownlint, chktex

### UI and Appearance

#### Tokyo Night Theme: folke/tokyonight.nvim
- Purpose: Modern, clean color scheme
- Configuration:
  - Style: "storm" variant (from options: storm, moon, night, day)
  - Non-transparent background
  - Bold headers in status line
  - Full plugin integration support

#### Lualine: nvim-lualine/lualine.nvim
- Purpose: Enhanced status line
- Dependencies: `nvim-web-devicons`
- Features:
  - Tokyo Night theme integration
  - Minimalist separators
  - Global status line
  - Git integration (branch, changes)
  - Diagnostics display with icons
  - File information (encoding, format, type)
  - Cursor position with character code display

## Usage Examples

### Copilot AI Assistant

#### Basic Ask Mode
1. Open any file with code
2. Press `<leader>cc`
3. Ask questions like:
   - "How can I improve this code?"
   - "Are there any bugs or issues?"
   - "Explain what this function does"
   - "Suggest optimizations"

#### Agent Mode for Editing
1. Open any file you want to modify
2. Press `<leader>cce`
3. Select your preferred AI model
4. Describe the changes you want
5. Review the diff preview
6. Apply or refine the changes

### File Navigation
1. Use Neo-tree (`<leader>e` or `:Neotree`) for file browser
2. Use Telescope:
   - `<leader>ff` to find files in current directory
   - `<leader>fg` to search text in current directory
   - `<leader>fs` to find occurrences of current word

### Code Quality
1. Treesitter provides automatic syntax highlighting
2. Rainbow delimiters help visualize nested code blocks
3. Linters run automatically on file save, showing errors and warnings
4. Tokyo Night theme provides a consistent, eye-friendly color palette

## Troubleshooting

### Copilot Issues
- **Copilot not authenticated**: Run `:Copilot setup`, then `:Copilot status`
- **Empty responses**: Check your internet connection and Copilot authentication
- **Model selection not working**: Ensure you're using agent mode (`<leader>cca` or `<leader>cce`)
- **Changes not applying**: Review the action menu options and ensure you select "Apply changes"

### Plugin Problems
- **Neo-tree not showing files**: Check for permission issues or try `:Neotree refresh`
- **Telescope not finding files**: Ensure you're in a project directory with readable files
- **Treesitter highlighting issues**: Run `:TSUpdate` to update parsers
- **Linter not working**: Verify the linter is installed on your system (e.g., `eslint`, `flake8`)
