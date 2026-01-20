# Neovim Plugins, Commands, Options, and Shortcuts

This document summarizes the plugins configured in your Neovim setup, how to use them, and the important options and shortcuts wired in your config.

## Notes
- Leader-based mappings below use your current `<leader>` (as configured in your options).
- This is a minimal configuration with most LazyVim default keybindings removed.
- Only window manager navigation and OpenCode keybindings are preserved.

## Plugins

### AI Assistant Integration

#### OpenCode: NickvanDyke/opencode.nvim
- Purpose: AI-powered coding assistant integrated directly into Neovim
- Dependencies: `snacks.nvim` (for input, picker, and terminal)
- Configuration:
  - Custom contexts that only include files within current working directory
  - Contexts available: `@this`, `@buffer`, `@buffers`, `@visible`, `@diagnostics`, `@quickfix`, `@diff`, `@grapple`, `@cwd`
  - Auto-read enabled for file reloading

##### Key Mappings

**Normal Mode:**
- `<leader>oa` - Ask OpenCode with `@this` context (auto-submit)
- `<leader>ox` - Execute OpenCode action (select from available actions)
- `<leader>oo` - Toggle OpenCode window
- `<leader>or` - Add range to OpenCode with `@this` context
- `<leader>ol` - Add current line to OpenCode with `@this` context
- `<leader>ou` - Scroll OpenCode session half page up
- `<leader>od` - Scroll OpenCode session half page down

**Visual Mode:**
- `<leader>or` - Add selected range to OpenCode with `@this` context

**Terminal Mode:**
- `<leader>oo` - Toggle OpenCode window

##### Context Types

OpenCode supports various context types to scope your requests:

- `@this` - Current selection or line
- `@buffer` - Current buffer (only if within CWD)
- `@buffers` - All loaded buffers (only those within CWD)
- `@visible` - All visible windows (only those within CWD)
- `@diagnostics` - Current diagnostics
- `@quickfix` - Quickfix list items
- `@diff` - Git diff for current directory
- `@grapple` - Grapple tags
- `@cwd` - Current working directory info

##### Usage Examples

1. **Quick Ask**: Press `<leader>oa` to quickly ask about current context
2. **Action Menu**: Press `<leader>ox` to see and execute available OpenCode actions
3. **Toggle Chat**: Press `<leader>oo` to open/close the OpenCode window
4. **Add Context**: Select code and press `<leader>or` to add it to OpenCode
5. **Line Context**: Press `<leader>ol` to add the current line to OpenCode

### Window Navigation

**Note**: Most LazyVim default keybindings have been removed. Only window manager navigation keybindings are preserved:

- `<C-h>` - Go to left window
- `<C-j>` - Go to lower window
- `<C-k>` - Go to upper window
- `<C-l>` - Go to right window

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

### OpenCode AI Assistant

1. **Quick Questions**: 
   - Place cursor on code you want to ask about
   - Press `<leader>oa` to ask OpenCode (uses @this context automatically)

2. **Add Code Context**:
   - Select code in visual mode
   - Press `<leader>or` to add it to OpenCode chat
   - Or press `<leader>ol` to add current line

3. **Toggle OpenCode**:
   - Press `<leader>oo` to open/close OpenCode window
   - Works in both normal and terminal mode

4. **Execute Actions**:
   - Press `<leader>ox` to see available OpenCode actions
   - Select from the menu to execute

### Window Navigation

- Use `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` to navigate between Neovim windows
- These keybindings work seamlessly with your window manager

### File Navigation

1. Use Neo-tree for file browser navigation
2. Use Telescope for fuzzy finding files and text search

### Code Quality

1. Treesitter provides automatic syntax highlighting
2. Rainbow delimiters help visualize nested code blocks
3. Linters run automatically on file save, showing errors and warnings
4. Tokyo Night theme provides a consistent, eye-friendly color palette

## Troubleshooting

### OpenCode Issues
- **OpenCode not responding**: Check that OpenCode is properly installed and running
- **Context not loading**: Ensure your files are within the current working directory
- **Commands not working**: Verify Snacks.nvim is properly loaded

### Plugin Problems
- **Neo-tree not showing files**: Check for permission issues or try refreshing
- **Telescope not finding files**: Ensure you're in a project directory with readable files
- **Treesitter highlighting issues**: Run `:TSUpdate` to update parsers
- **Linter not working**: Verify the linter is installed on your system (e.g., `eslint`, `flake8`)
