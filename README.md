# nvim-dots

A minimal LazyVim configuration with only window manager navigation and OpenCode keybindings preserved.

## Key Features

- **Minimal Keybindings**: All LazyVim default keybindings removed except:
  - Window navigation (`<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`)
  - OpenCode integration keybindings
- **No Copilot**: Copilot plugin has been removed
- **OpenCode AI Assistant**: Full integration with OpenCode for AI-powered coding assistance

## Keybindings

### Window Manager Navigation
- `<C-h>` - Go to left window
- `<C-j>` - Go to lower window  
- `<C-k>` - Go to upper window
- `<C-l>` - Go to right window

### OpenCode AI Assistant
- `<leader>oa` - Ask OpenCode (with @this context, auto-submit)
- `<leader>ox` - Execute OpenCode action (select from available actions)
- `<leader>oo` - Toggle OpenCode window
- `<leader>or` - Add range/selection to OpenCode
- `<leader>ol` - Add current line to OpenCode
- `<leader>ou` - Scroll OpenCode session half page up
- `<leader>od` - Scroll OpenCode session half page down

## Installation

Refer to the [LazyVim documentation](https://lazyvim.github.io/installation) for installation instructions.
