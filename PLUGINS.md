# Neovim Plugins, Commands, Options, and Shortcuts

This document summarizes the plugins configured in your Neovim setup, how to use them, and the important options and shortcuts wired in your config.

## Notes
- Leader-based mappings below use your current `\<leader>` (as configured in your options). Some mappings also use `\<Space>` prefixes for Telescope.
- Some tools (linters, external binaries) must be installed on your system to work (e.g., `flake8`, `shellcheck`, `clang-tidy`, etc.).

## Plugins

### Colorscheme: folke/tokyonight.nvim
- Loads on startup with high priority.
- Options (set via setup):
  - `style`: `"storm"` (also: `moon`, `night`, `day`)
  - `transparent`: `false`
  - `dim_inactive`: `false`
  - `lualine_bold`: `true`
  - `plugins.all`: `true` (enable integrations)
- Commands:
  - `:colorscheme tokyonight` (applied automatically)

### File Explorer: nvim-neo-tree/neo-tree.nvim (v3.x)
- Purpose: Sidebar tree showing ONLY the current working directory and its children.
- Key shortcuts:
  - `\<C-n>`: toggle Neo-tree on the left (`reveal=true`)
  - Inside Neo-tree:
    - `cd`: change root to selected directory
    - `\<C-h>`: jump back to the current working directory
- Behavior/options:
  - `filesystem.bind_to_cwd = true`
  - `filesystem.cwd_root = true`, `filesystem.no_parent_dir = true`
  - `follow_current_file.enabled = true`
  - `hijack_netrw_behavior = "open_current"`
  - File watcher enabled (libuv)
- Migrations:
  - Runs `:Neotree migrations` automatically on `VimEnter` to avoid prompts.

### Fuzzy Finder: nvim-telescope/telescope.nvim
- Purpose: File search, live grep, buffers, help, etc., limited to current working directory (cwd).
- Key shortcuts:
  - `\<Space>ff`: Find files in cwd
  - `\<Space>fg`: Live grep in cwd
  - `\<Space>fb`: Buffers
  - `\<Space>fh`: Help tags
  - `\<Space>fo`: Recent files in cwd
  - `\<Space>fs`: Grep word under cursor in cwd
  - `\<Space>fd`: Workspace diagnostics
- Defaults:
  - `sorting_strategy = "ascending"`, prompt on top
  - Respects `.gitignore` and ignores `node_modules`/`.git` by default
  - `find_files` and `live_grep` pickers restricted to cwd

### Statusline: nvim-lualine/lualine.nvim
- Theme: `tokyonight`
- Sections:
  - `lualine_a`: `mode`
  - `lualine_b`: `branch`, `diff`
  - `lualine_c`: `filename`
  - `lualine_x`: diagnostics (`nvim_diagnostic`), `encoding`, `fileformat`, `filetype`
  - `lualine_y`: `progress`
  - `lualine_z`: `location` + custom character info (`line:col [char]`)
- Global status enabled; simple separators.

### Markdown Preview: iamcco/markdown-preview.nvim
- Filetype: `markdown` (lazy-load)
- Build: `cd app && npm install`
- Quick commands:
  - `:MarkdownPreview` to open
  - `:MarkdownPreviewStop` to close
  - `:MarkdownPreviewToggle` to toggle
- Behavior options (high-level): auto-close on buffer close, echo preview URL, etc.

### Treesitter: nvim-treesitter/nvim-treesitter
- Purpose: Better syntax highlighting and indentation.
- Build: `:TSUpdate`
- Enabled modules: `highlight`, `indent`
- `ensure_installed` includes common languages for web, backend, databases, config, docs, and misc (`html`, `css`, `js`/`ts`/`tsx`/`vue`/`json`, `python`, `lua`, `go`, `rust`, `java`, `c`/`cpp`/`c_sharp`, `php`, `ruby`, `perl`, `bash`, `dockerfile`, `sql`, `graphql`, `yaml`, `toml`, `ini`, `make`, `terraform`, `markdown`/`markdown_inline`, `latex`, `gitignore`, `vim`, `regex`).
- Useful commands:
  - `:TSInstall <lang>`
  - `:TSUninstall <lang>`
  - `:TSUpdate`

### Linting: mfussenegger/nvim-lint
- Purpose: Run external linters and show diagnostics.
- Trigger: Automatically runs on `BufWritePost`; you can also run manually:
  - `:lua require("lint").try_lint()`
- Diagnostics display:
  - Virtual text, signs, underline, float configured in your options (inline feedback near issues).
- Configured linters by filetype (install these tools system-wide):
  - `html`: `tidy`
  - `css`/`scss`: `stylelint`
  - `javascript`/`typescript`/`tsx`/`vue`/`graphql`: `eslint_d`
  - `json`: `jsonlint`
  - `python`: `flake8`
  - `lua`: `luacheck`
  - `go`: `golangci_lint`
  - `rust`: `clippy`
  - `java`: `checkstyle`
  - `c`/`cpp`: `clangtidy`
  - `c_sharp`: `csharpier`
  - `php`: `phpcs`
  - `ruby`: `rubocop`
  - `perl`: `perlcritic`
  - `bash`: `shellcheck`
  - `dockerfile`: `hadolint`
  - `sql`: `sqlfluff`
  - `yaml`: `yamllint`
  - `toml`: `taplo`
  - `ini`: `ini_lint`
  - `make`: `checkmake`
  - `terraform`: `tflint`
  - `markdown`: `markdownlint`
  - `latex`: `chktex`
  - `vim`: `vint`

### GitHub Copilot: github/copilot.vim
- Status: Enabled for all filetypes; Tab mappings disabled (custom accept keys can be added in `options.lua`).
- Useful commands:
  - `:Copilot setup` to authenticate
  - `:Copilot status` to check connection/user

### Copilot Chat: CopilotC-Nvim/CopilotChat.nvim
- Purpose: Right-side chat panel with coding assistant; supports agent personas and model label in UI.
- Chat placement: Opens on the right; toggle/close mappings available.
- Mappings (normal mode):
  - `\<leader>cc`: Open chat
  - `\<leader>cct`: Toggle chat
  - `\<leader>ccr`: Reset chat
  - `\<leader>ccs`: Stop chat
  - `\<leader>ccq`: Quick chat (prompt)
  - `\<leader>ccA`: Choose agent; opens/replaces chat on the right
  - `\<leader>ccM`: Choose model label (UI only); updates title and answer header
- Visual mode mappings:
  - `\<leader>cce`: Explain selection
  - `\<leader>ccf`: Fix selection
  - `\<leader>cco`: Optimize selection
  - `\<leader>ccd`: Document selection
- Agent & model selection (custom wiring):
  - Agents (letter shortcuts): `g=General`, `r=Refactor`, `b=BugFix`, `d=Docs`, `t=Tests`
  - Models (letter shortcuts, UI labels): `g=GPT-5`, `s=Claude 3.7 Sonnet`, `c=Claude 4`
  - Window title winbar shows: `Copilot Chat | Agent: <name> | Model: <label>`
  - Copilot answer header shows: `## Copilot (<label>)`
  - Note: CopilotChat.nvim doesn’t expose provider model switching in this config; the model chooser updates UI labels/context.
- User label:
  - The `question_header` displays your local system username.

## Global/editor shortcuts and behavior

### Terminal toggle
- ``\<C-`>``: Toggle a terminal in a bottom horizontal split; automatically enters insert mode; `\<Esc>` exits terminal mode.

### Diagnostics (LSP and nvim-lint)
- `\<leader>e`: Show error popup at cursor
- `[d` / `]d`: Previous/next diagnostic
- `\<leader>q`: Open diagnostics list
- Inline diagnostics are enabled (`virtual_text`, `signs`, `underline`).

### Split navigation and resizing (built-in Vim controls)
- Move focus: `\<C-w> h/j/k/l`
- Cycle: `\<C-w> w`; previous: `\<C-w> p`
- Resize: `\<C-w> >` / `\<C-w> <` (width), `\<C-w> +` / `\<C-w> -` (height)
- Maximize: `\<C-w> |` (width), `\<C-w> _` (height)
- Equalize: `\<C-w> =`

## Troubleshooting
- Linters not running: Ensure the external linters are installed and in `PATH`. Run `:lua require("lint").try_lint()` and check `:messages`.
- Copilot not authenticated: Run `:Copilot setup`, then `:Copilot status`. The chat title and headers will reflect your configured agent/model and your local username.
- Neo-tree shows wrong root: Press `\<C-h>` inside Neo-tree to return to cwd. The tree is configured to bind to cwd and hide parents.
- Telescope scope: All file/grep pickers are restricted to the current working directory by default in this setup.
