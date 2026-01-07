# Neovim Configuration Setup Guide

A modern Neovim configuration with AI assistance, comprehensive linting, and beautiful UI. This setup uses `lazy.nvim` for plugin management and focuses on providing a fast, productive development environment.

## Features

- **AI Code Assistance**: OpenCode AI integration
- **Fuzzy Finding**: Telescope for quick file navigation and content search
- **File Explorer**: Neo-tree with git integration
- **Syntax Highlighting**: Tree-sitter with 40+ language parsers
- **Code Linting**: Comprehensive linter support for 30+ file types
- **Beautiful UI**: Tokyo Night color scheme with rainbow brackets and indent guides
- **Git Integration**: Built-in git status and diff viewing

---

## Prerequisites

### Required

1. **Neovim >= 0.9.0**
   ```bash
   # Check your version
   nvim --version
   ```

2. **Git**
   ```bash
   # Check if installed
   git --version
   ```

3. **C Compiler** (for Tree-sitter parser compilation)
   ```bash
   sudo pacman -S base-devel
   ```

### Highly Recommended

4. **Ripgrep** (for faster Telescope searching)
   ```bash
   sudo pacman -S ripgrep
   ```

5. **fd** (for faster file finding)
   ```bash
   sudo pacman -S fd
   ```

6. **Node.js** (for JavaScript-based linters)
   ```bash
   sudo pacman -S nodejs npm
   ```

7. **Nerd Font** (for icons)
   
   Download and install [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads) or any Nerd Font of your choice.
   
   ```bash
   # Quick install on Linux
   mkdir -p ~/.local/share/fonts
   cd ~/.local/share/fonts
   wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
   unzip JetBrainsMono.zip
   fc-cache -fv
   ```
   
   Set your terminal to use the Nerd Font you installed.

---

## Installation

### Step 1: Backup Existing Configuration

If you have an existing Neovim configuration, back it up first:

```bash
# Backup config directory
mv ~/.config/nvim ~/.config/nvim.backup

# Backup data directory (plugins, cached data)
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# Backup state directory (logs, undo history)
mv ~/.local/state/nvim ~/.local/state/nvim.backup

# Backup cache directory
mv ~/.cache/nvim ~/.cache/nvim.backup
```

### Step 2: Clone This Repository

```bash
git clone <your-repo-url> ~/.config/nvim
```

Replace `<your-repo-url>` with the actual repository URL.

### Step 3: Start Neovim

```bash
nvim
```

On first launch:
1. `lazy.nvim` will automatically install itself
2. All plugins will be downloaded and installed
3. Tree-sitter parsers will be compiled (this takes a few minutes)

You may see some errors on the first launch - this is normal. Close and reopen Neovim after the initial setup completes.

---

## Installing Linters (Optional but Recommended)

This configuration includes linting support for many languages. Install the linters for the languages you work with.

### Web Development

```bash
# HTML
sudo pacman -S tidy

# CSS/SCSS
npm install -g stylelint stylelint-config-standard

# JavaScript/TypeScript
npm install -g eslint_d

# JSON
npm install -g jsonlint
```

### Python

```bash
pip install flake8

# or with pipx (recommended)
pipx install flake8
```

### Lua

```bash
sudo pacman -S luacheck
```

### Go

```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

### Rust

```bash
# clippy is included with rustup
rustup component add clippy
```

### Shell Scripts

```bash
sudo pacman -S shellcheck
```

### Docker

```bash
sudo pacman -S hadolint
```

### YAML

```bash
pip install yamllint

# or with pipx
pipx install yamllint
```

### Markdown

```bash
npm install -g markdownlint-cli
```

### Other Languages

See the full linter list below for your specific languages.

---

## Configuration

### Leader Key

The leader key is set to `<Space>`. The local leader is set to `\`.

### Key Bindings

#### File Navigation

| Key | Action |
|-----|--------|
| `<C-n>` | Toggle Neo-tree file explorer |
| `<leader>ff` | Find files in buffer's directory |
| `<leader>fg` | Live grep in buffer's directory |
| `<leader>fs` | Grep current word |
| `<leader>fF` | Find files globally |
| `<Space>fb` | List open buffers |
| `<Space>fh` | Search help tags |
| `<Space>fo` | Recent files |
| `<Space>fd` | Workspace diagnostics |

#### OpenCode AI Assistant

| Key | Action |
|-----|--------|
| `<leader>oa` | Ask OpenCode |
| `<leader>ox` | Execute OpenCode action |
| `<leader>oo` | Toggle OpenCode panel |
| `<leader>or` | Add range to OpenCode |
| `<leader>ol` | Add line to OpenCode |
| `<leader>ou` | OpenCode half page up |
| `<leader>od` | OpenCode half page down |

#### Window Management

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle terminal |
| `<A-h/j/k/l>` | Navigate between windows |
| `<leader>w` | Cycle to next window |
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |

#### Diagnostics

| Key | Action |
|-----|--------|
| `<leader>e` | Show diagnostic error |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>q` | Open diagnostics list |

### Customization

- **Color scheme**: Edit `lua/config/colorscheme.lua` to change themes
- **Options**: Edit `lua/config/options.lua` for Vim settings and keybindings
- **Plugins**: Add/remove plugins in `lua/plugins/` directory

---

## Complete Linter Reference

The configuration includes linting support for these languages:

| Language | Linter | Install Command |
|----------|--------|-----------------|
| HTML | tidy | `sudo pacman -S tidy` |
| CSS/SCSS | stylelint | `npm install -g stylelint` |
| JavaScript/TypeScript | eslint_d | `npm install -g eslint_d` |
| JSON | jsonlint | `npm install -g jsonlint` |
| Python | flake8 | `pip install flake8` |
| Lua | luacheck | `sudo pacman -S luacheck` |
| Go | golangci_lint | `go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest` |
| Rust | clippy | `rustup component add clippy` |
| Java | checkstyle | Download from [checkstyle.org](https://checkstyle.org/) |
| C/C++ | clangtidy | `sudo pacman -S clang-tools-extra` |
| C# | csharpier | `dotnet tool install -g csharpier` |
| PHP | phpcs | `composer global require squizlabs/php_codesniffer` |
| Ruby | rubocop | `gem install rubocop` |
| Perl | perlcritic | `cpan Perl::Critic` |
| Bash | shellcheck | `sudo pacman -S shellcheck` |
| Dockerfile | hadolint | `sudo pacman -S hadolint` |
| SQL | sqlfluff | `pip install sqlfluff` |
| YAML | yamllint | `pip install yamllint` |
| TOML | taplo | `cargo install taplo-cli` |
| Makefile | checkmake | `go install github.com/mrtazz/checkmake/cmd/checkmake@latest` |
| Terraform | tflint | `curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash` |
| Markdown | markdownlint | `npm install -g markdownlint-cli` |
| LaTeX | chktex | `sudo pacman -S chktex` |
| Vim script | vint | `pip install vim-vint` |
| Vue.js | eslint_d | `npm install -g eslint_d` |
| GraphQL | eslint_d | `npm install -g eslint_d` |

**Note**: You only need to install linters for languages you actively use.

---

## Troubleshooting

### Plugins won't install

```bash
# Remove lazy.nvim cache and reinstall
rm -rf ~/.local/share/nvim/lazy
nvim
```

### Tree-sitter parsers fail to compile

Make sure you have a C compiler installed:
```bash
gcc --version
# or
clang --version
```

### Icons don't display correctly

1. Make sure you installed a Nerd Font
2. Set your terminal to use the Nerd Font
3. Verify font in terminal settings

### Linters not working

1. Check if the linter is installed:
   ```bash
   which eslint_d
   which flake8
   ```

2. Check Neovim logs:
   ```bash
   nvim
   :messages
   ```

3. View linter output:
   ```bash
   :lua print(vim.inspect(require('lint').linters))
   ```

### Commands

- `:Lazy` - Open plugin manager
- `:Lazy update` - Update all plugins
- `:Lazy sync` - Install missing plugins and update
- `:TSUpdate` - Update Tree-sitter parsers
- `:checkhealth` - Check Neovim health
- `:messages` - View error messages

---

## Plugin List

This configuration includes the following plugins:

### Core
- **lazy.nvim** - Plugin manager
- **plenary.nvim** - Lua utility library
- **nui.nvim** - UI component library
- **nvim-web-devicons** - File icons

### AI Assistance
- **opencode.nvim** - AI code assistant
- **snacks.nvim** - UI components for OpenCode

### File Navigation
- **neo-tree.nvim** - File explorer with git integration
- **telescope.nvim** - Fuzzy finder for files and content

### Code Enhancement
- **nvim-treesitter** - Syntax highlighting and parsing
- **nvim-lint** - Linting integration
- **rainbow-delimiters.nvim** - Rainbow brackets

### UI/Appearance
- **tokyonight.nvim** - Color scheme
- **lualine.nvim** - Status line
- **indent-blankline.nvim** - Indent guides

---

## Updates

To update plugins:

```bash
nvim
# Press <Space> to trigger leader key, then type:
:Lazy update
```

To update Tree-sitter parsers:

```bash
:TSUpdate
```

---

## Uninstallation

To completely remove this configuration:

```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Restore your backup if you made one
mv ~/.config/nvim.backup ~/.config/nvim
```

---

## Support & Resources

- **Neovim Docs**: `:help` or [neovim.io](https://neovim.io)
- **Lazy.nvim**: [github.com/folke/lazy.nvim](https://github.com/folke/lazy.nvim)
- **OpenCode**: [github.com/NickvanDyke/opencode.nvim](https://github.com/NickvanDyke/opencode.nvim)
- **Telescope**: [github.com/nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

---

## Contributing

Feel free to open issues or submit pull requests to improve this configuration.

---

## Health Check & Diagnostics

### Running Health Check

To check the status of your Neovim configuration, run:

```bash
nvim +checkhealth
```

This will run diagnostics for all installed plugins and Neovim core functionality.

### Known Issues & Fixes

This section documents issues from the last health check and their resolutions.

#### 1. **snacks.nvim Lazy-Loading & Priority** ✅ FIXED

**Issue**: `snacks.nvim` should not be lazy-loaded and should have a priority of 1000 or higher.

**Status**: Fixed in `lua/plugins/opencode.lua`

**Solution**:
- Updated snacks.nvim dependency to include `lazy = false` and `priority = 1000`
- This ensures snacks.nvim loads early and is not deferred
- **Note**: There is a remaining error in snacks' healthcheck itself (not related to our config). This is a bug in snacks.nvim and doesn't affect functionality.

#### 2. **Missing Node.js neovim Module** ✅ FIXED

**Issue**: Python 3 provider couldn't find the `neovim` npm package.

**Status**: Fixed

**Solution**:
- Installed `neovim` npm package locally: `npm install --no-save neovim --prefix ~/.local`
- This provides Python-to-Neovim integration if needed

#### 3. **Clipboard Support** ⚠️ REQUIRES MANUAL INSTALLATION

**Issue**: No clipboard tool found. Clipboard registers (`"+` and `"*`) will not work.

**Status**: Needs installation

**Solution** (choose one based on your display server):

For X11:
```bash
sudo pacman -S xclip
# or
sudo pacman -S xsel
```

For Wayland:
```bash
sudo pacman -S wl-clipboard
```

#### 4. **lsof Executable Missing** ⚠️ REQUIRES MANUAL INSTALLATION

**Issue**: `lsof` executable not found in `$PATH`, needed by opencode.nvim for better port detection.

**Status**: Needs installation

**Solution**:
```bash
sudo pacman -S lsof
```

**Alternative**: You can set `vim.g.opencode_opts.port` in your config to avoid this requirement.

#### 5. **Lua 5.1 for luarocks** ⚠️ OPTIONAL

**Issue**: luarocks expects Lua 5.1 but found Lua 5.4.8.

**Status**: Not critical (no plugins currently require luarocks)

**Solution** (if needed):
```bash
sudo pacman -S lua51
```

#### 6. **opencode Version** ⚠️ NOTE

**Issue**: opencode CLI version (1.1.2) patch version differs from latest tested (1.0.60).

**Status**: Informational

**Note**: You may want to update opencode CLI:
```bash
opencode update
# or reinstall from https://github.com/anomalyco/opencode
```

#### 7. **Optional Providers** ℹ️ INFORMATIONAL

These are not critical but can enhance functionality:

- **Kitty Terminal**: Set `KITTY_LISTEN_ON` environment variable to enable kitty integration
- **Wezterm Terminal**: Install wezterm: `sudo pacman -S wezterm`
- **Tmux**: Install tmux: `sudo pacman -S tmux`

#### 8. **Optional Providers - Ruby & Perl** ℹ️ INFORMATIONAL

These are optional providers:

**Ruby provider**: `ruby` and `gem` must be in `$PATH`
**Perl provider**: `Neovim::Ext` cpan module is not installed

These are entirely optional and only needed if you work with Ruby or Perl.

### Resolving Issues

To automatically fix most critical issues, run:

```bash
# Install clipboard support (choose based on your environment)
sudo pacman -S wl-clipboard  # For Wayland
# or
sudo pacman -S xclip         # For X11

# Install lsof for opencode
sudo pacman -S lsof
```

After installing packages, restart Neovim and run `:checkhealth` again to verify.

---

## License

This configuration is provided as-is. Feel free to use and modify it as needed.
